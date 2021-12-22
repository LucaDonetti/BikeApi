//
//  TokenHelper.swift
//  MyBike_API
//
//  Created by Zehus on 08/07/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Alamofire

public struct TokenHelper {
    private (set) var token: String?

    public let parsedToken: JWT
    
    init(token: String?) throws {
       guard let tok = token else { throw MSALGeneralError.emptyAuthState}
       self.token = tok
       self.parsedToken = try DecodedJWT(jwt: tok)
    }
    func isExpired() throws {
        do {
            if self.parsedToken.expired {
                throw APIError.tokenExpiredError
            }
        }
    }
}

class RequestInterceptor: RequestRetrier, RequestAdapter {

    private var isRefreshing = false
    // To debug stuff, set debugTokenInvalidation to true
    private var debugTokenInvalidation = false // will see a invalid token the first time
    private var testedTokenInvalidation = false // will be switched to true later

    weak var msalManager: MSALManager?

    init(msal: MSALManager) {
        msalManager = msal
    }
    
    func should(_ manager: SessionManager, retry request: Request,
                with error: Error, completion: @escaping RequestRetryCompletion) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(false, 0.0)
        }
        NSLog("[tknflow]Alamofire.shouldRetry - VERBOSE - new token requested")
        if !isRefreshing {
            self.refreshTokens(completion: completion)
        }
        else {
            return completion(false, 0.0)
        }
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlReq = urlRequest
        guard var accessToken = msalManager?.tokenHelper?.token else {
            NSLog("[tknflow]Alamofire.adapt - WARNING - No token")
            return urlReq
        }

        NSLog("[tknflow]Alamofire.adapt - VERBOSE - Creating request with token")
        // Ignore, code is used only for debug
        if debugTokenInvalidation && !testedTokenInvalidation {
            testedTokenInvalidation.toggle()
            accessToken = "tokeninvalidated"
            NSLog("[tknflow]Alamofire.adapt - WARNING - Invalidated token on purpose ")
        }
        NSLog("[tknflow]Alamofire.adapt - VERBOSE - using token: ")
        print(accessToken)
        urlReq.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        return urlReq
    }

    private func refreshTokens(completion: @escaping RequestRetryCompletion) {
        NSLog("[tknflow]refreshTokens - VERBOSE - Start Refreshing Token")

        guard !isRefreshing else {
            NSLog("[tknflow]refreshTokens - WARNING - Already Refreshing ")
            return
        }
        isRefreshing.toggle()
        msalManager?.refreshToken { [weak self] (error) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.isRefreshing.toggle()
            if let er = error {
                NSLog("[tknflow]refreshTokens - ERROR - Refreshing token: \(er.localizedDescription)")
                completion(false, 0.0)
            } else {
                NSLog("[tknflow]refreshTokens - VERBOSE -  Refreshing SUCCESS")
                completion(true, 2.0)
            }
        }
    }
}
