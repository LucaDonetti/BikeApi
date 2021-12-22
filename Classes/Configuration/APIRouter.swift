//
//  APIRouter.swift
//  MyBike_API
//
//  Created by Zehus on 21/01/2020.
//  Copyright © 2020 Andrea Finollo. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol APIRoute {
    func restartSession()
    var configuration: AppHttpClientConfiguration { get set}
    func request<T: ImmutableMappable>(_ route: Router, resultHandler: @escaping (Swift.Result<T, Error>) -> Void)
    init(with configuration: AppHttpClientConfiguration)
}

class APIRouteAF: APIRoute {
    // MARK: - CONFIGURATION
    public var configuration: AppHttpClientConfiguration

    var msalManager: MSALManager!

    var session: SessionManager!

    func restartSession() {
        let cfg = URLSessionConfiguration.default
        let cooks = HTTPCookieStorage.shared
        cfg.httpCookieStorage = cooks
        cfg.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        cfg.httpAdditionalHeaders =  SessionManager.defaultHTTPHeaders.merging(["X-Parse-Application-Id": "ios"], uniquingKeysWith:  { (_, new) in new })
        if #available(iOS 11.0, *) {
            cfg.waitsForConnectivity = false
        }
        let serverTrustPolicies = ["https://idpdev.azurewebsites.net": ServerTrustPolicy.disableEvaluation]
        let manager = SessionManager(configuration: cfg,
                                     serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        msalManager = try! MSALManager(configuration: configuration.masalConfiguration)
        let interceptor = RequestInterceptor(msal: msalManager)
        manager.adapter = interceptor
        manager.retrier = interceptor
        session = manager
    }
    
    required init(with configuration: AppHttpClientConfiguration) {
        self.configuration = configuration
        self.restartSession()
    }
    
    func request<T: ImmutableMappable>(_ route: Router, resultHandler: @escaping (Swift.Result<T, Error>) -> Void) {
        if case .getVehicleBySN(_) = route {
            session.request(RequestAF(routing: route,configuration: configuration.routerConfiguration))
                .validate().responseJSON { response in
                    let objectResponse: ObjectResponse<PagelessResponse<VehicleAPIModel>> = ObjectBuilder.buildObject(response: response)
                    switch objectResponse {
                    case .value(let value):
                        let first = value.first!
                        let antitamper = self.antitamper(serial: first.serialNumber, rr: first.eol.rearRing, fr: first.eol.frontRing, wl: first.eol.wheelLenght)
                        if let orig = ObjectBuilder.extractAntitamperFromFirst(response: response),
                           antitamper == orig {
                            resultHandler(.success(value as! T))
                        } else {
                            resultHandler(.failure(APIError.antitamperActivated))
                        }
                    case .error(let error):
                        resultHandler(.failure(error))
                    }
                }
        } else {
            session.request(RequestAF(routing: route, configuration: configuration.routerConfiguration)).validate().responseJSON { response in
                let objectResponse: ObjectResponse<T> = ObjectBuilder.buildObject(response: response)
                switch objectResponse {
                case .value(let value):
                    resultHandler(.success(value))
                case .error(let error):
                    resultHandler(.failure(error))
                }
            }
        }
    }
    
    // MARK: Private
    public  func antitamper(serial: String, rr: Int, fr: Int, wl: Int) -> String {
        guard let oid = msalManager?.tokenHelper?.parsedToken.oid?.lowercased() else {
            return ""
        }
        let sn = serial.lowercased()
        let components = oid.components(separatedBy: "-")
        let composed = components[0] + components[2] + String(components[3].reversed()) + components[1] + sn + String(rr) + String(fr) + String(wl)
        let charView = composed.utf8
        let shaString = Data(charView).sha256
        return shaString
    }
}


struct RequestAF: URLRequestConvertible {
    let routing: Router
    let configuration: RouterConfigurationable
    var baseURL: URL {
        switch routing {
        case .getUserProfile:
            return try! configuration.IdentityURL.asURL()
        default:
            return try! configuration.BaseURL.asURL()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        let versionedURL = url.appendingPathComponent(routing.path.replacingOccurrences(of: BRParameters.Placeholder.VersionPh, with: configuration.Version))
        var request = URLRequest(url: versionedURL)
        request.httpMethod = routing.method.rawValue
        print("DEBUG REQUEST : \(request)")
        switch routing.method {
        case .get:
            return try URLEncoding(destination: .queryString).encode(request, with: routing.parameters)
        case .post, .put:
            return try routing.encoding(request: request, parameters: routing.parameters)
            /* case .put:
             return URLEncoding(destination: .httpBody).encode(request, with: parameters)*/
        case .delete:
            return request
        }
    }
}
