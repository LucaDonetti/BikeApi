//
//  NetworkConfig.swift
//  MyBike_v2_App
//
//  Created by Zehus on 08/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//
/*
import Foundation
import Alamofire

//TODO: add the required scheme to implement this

struct NetworkConfig {
    static let apiVersion = "1"
    /* Dev */
    #if ENV_TEST
    static let Enviroment = ConfigurationMode.stage
    static let BitrideURL = "https://" + BitrideHOST
    static let BitrideHOST = "zehusmybikegatewayintegration.azurewebsites.net"
    static let IndentityURL = "https://" + IdentityHOST
    static let IdentityHOST = "zehusidentityserverwebintegration.azurewebsites.net"
    static let TrustPolicies = [String: ServerTrustPolicy]()
    static let CookieStorage = HTTPCookieStorage.shared
    static let CachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    /* Production */
    #elseif ENV_PRODUCTION
    static let Enviroment = ConfigurationMode.production
    static let BitrideURL = "https://" + BitrideHOST
    static let BitrideHOST = "zehusmybikegatewayintegration.azurewebsites.net"
    static let IndentityURL = "https://" + IdentityHOST
    static let IdentityHOST = "zehusidentityserverwebintegration.azurewebsites.net"
    static let TrustPolicies = [String: ServerTrustPolicy]()
    static let CookieStorage = HTTPCookieStorage.shared
    static let CachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    /* Only for IB */
    #else
    static let Enviroment = ConfigurationMode.development
    static let BitrideURL = "https://" + BitrideHOST
    static let BitrideHOST = "zehusmybikegatewayintegration.azurewebsites.net"
    static let IndentityURL = "https://" + IdentityHOST
    static let IdentityHOST = "zehusidentityserverwebintegration.azurewebsites.net"
    static let TrustPolicies = [String: ServerTrustPolicy]()
    static let CookieStorage = HTTPCookieStorage.shared
    static let CachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    #endif
}
*/
