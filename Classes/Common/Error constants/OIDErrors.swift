//
//  OIDErrors.swift
//  Example
//
//  Created by Zehus on 29/01/2019.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import Foundation

enum OIDError: ErrorProtocol {
    static let errorDomain = "it.zehus.oid_error"
    case invalidIdToken
    case invalidAppSettings
    case configurationError
    case invalidPresenter
    case emptyResponse
    case emptyAuthState
    var errorDescription: String? {
        switch self {
        case .invalidIdToken:
            return "tokenId is not valid"
        case .invalidAppSettings:
            return "please check whether the app is properly configured (constants,bundle id, etc)"
        case .configurationError:
            return "invalid configuration from cloud"
        case .invalidPresenter:
            return "presenter viewController is not valid"
        case .emptyResponse:
            return "empty response from auth server"
        case .emptyAuthState:
            return "no authorization state found"
        }
    }
    var errorCode: Int {
        let code = 1000
        switch self {
        case .invalidIdToken:
            return code + 1
        case .invalidAppSettings:
            return code + 2
        case .configurationError:
            return code + 3
        case .invalidPresenter:
            return code + 4
        case .emptyResponse:
            return code + 5
        case .emptyAuthState:
            return code + 6
        }
    }
}
