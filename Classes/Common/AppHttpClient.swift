//
//  AppHttpClient.swift
//  MyBike_v2_App
//
//  Created by Zehus on 08/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import CommonCrypto
import UIKit

let verboseResponse = true

let httpErrorDomain = "it.bitride.httpClient"

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum RequestSerializer {
    case urlEncoded
    case json
}

public protocol RouterConfigurationable {
    var BaseURL: String {get}
    var IdentityURL: String {get}
    var Version: String {get}
    var AuthScheme: String {get}
}

public protocol MSALConfigurationable {
    var TenantName: String {get}
    var AuthorityHostName: String {get}
    var ClientId: String {get}
    var SignupOrSigninPolicy: String {get}
    var ResetPasswordPolicy: String? {get}
    var GraphURI: String {get}
    var Scopes: [String] {get}
    var EndPoint: String {get}
}

public struct AppHttpClientConfiguration {
    public let masalConfiguration: MSALConfigurationable
    public let routerConfiguration: RouterConfigurationable
    
    public init(masalConfiguration: MSALConfigurationable, routerConfiguration: RouterConfigurationable) {
        self.masalConfiguration = masalConfiguration
        self.routerConfiguration = routerConfiguration
    }
}

public class AppHttpClient {
    // MARK: - CONFIGURATION
    public var configuration: AppHttpClientConfiguration
    
    // MARK: - PUBLIC
    lazy var router: APIRoute = {
       return APIRouteAF(with: configuration)
    }()
    public lazy var msalManager: MSALManager! = {
        try! MSALManager(configuration: configuration.masalConfiguration)
    }()
    
    public init(configuration: AppHttpClientConfiguration){
        self.configuration = configuration
    }

    // MARK: CONSTANT
    public let firmwareStorageURL: URL? = {
        let fileManager = FileManager()
        let storagePath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("OTA", isDirectory: true)
        if !fileManager.fileExists(atPath: storagePath.path) {
            do {
                try fileManager.createDirectory(at: storagePath, withIntermediateDirectories: true)
            } catch {
                return nil
            }
        }
        return storagePath
    }()

    // MARK: PUBLIC METHOD
    public func logIn(from presenter: UIViewController, completion: @escaping (Error?) -> Void) {
        msalManager.procedure_loginFrom(presenter: presenter).done { _ in
            completion(nil)
            }.catch { error in
                completion(error)
        }
    }
    public func logOut() {
        msalManager.cleanCredentialForLogout()
        msalManager = try! MSALManager(configuration: configuration.masalConfiguration)
        router.restartSession()
    }
    
    public func promise_logIn(from presenter: UIViewController) -> Promise<Void> {
        router.restartSession()
        return msalManager.procedure_loginFrom(presenter: presenter)
    }
}

// TODO: MOVE TO HOST APPLICATION
extension UIViewController {
    class func topViewController(rootViewController: UIViewController? = nil) -> UIViewController? {
        var rootVC: UIViewController?
        if let rootViewController = rootViewController {
            rootVC = rootViewController
        } else {
            if #available(iOS 13.0, *) {
                let windowScene = UIApplication.shared
                    .connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .first
                if let windowScene = windowScene as? UIWindowScene {
                    rootVC = windowScene.windows.first!.rootViewController
                }
            } else {
                rootVC = UIApplication.shared.keyWindow?.rootViewController
            }
        }
        guard let root = rootVC else {
            return nil
        }
        guard let presented = root.presentedViewController else {
            return rootVC
        }
        switch presented {
        case let navigationController as UINavigationController:
            return topViewController(rootViewController: navigationController.viewControllers.last)
        case let tabBarController as UITabBarController:
            return topViewController(rootViewController: tabBarController.selectedViewController)
        default:
            return topViewController(rootViewController: presented)
        }
    }
}
extension Data {
    private func hexString(_ iterator: Array<UInt8>.Iterator) -> String {
        return iterator.map { String(format: "%02x", $0) }.joined()
    }
    

    public var sha256: String {
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes { bytes in
            _ = CC_SHA256(bytes.baseAddress, CC_LONG(self.count), &digest)
        }
        return hexString(digest.makeIterator())
    }
}
