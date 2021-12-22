//
//  OpenIDConstants.swift
//  MyBike_API
//
//  Created by Zehus on 15/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
//import AppAuth

enum Constants {
    /**
     The OIDC issuer from which the configuration will be discovered.
     */
    static let Issuer: URL = URL(string: "https://zehusidentityserverwebintegration.azurewebsites.net")!
    /**
     The OAuth client ID.
     */
    static let ClientID: String = "mybikeapp"
    /**
     Client secret.
     */
    static let ClientSecret: String? = nil //TODO: should be implemented in production
    /**
     The OAuth redirect URI for the client @c kClientID.
     */
    // WARNING: redirect URI must be ALL LOWERCASE
    static let RedirectURI = URL(string: "net.openid.mybikeapp://oauth2redirect")!
    static let LogOutID: String = "LogoutId"
    static let OIDStateKey: String = "OIDAuthState"
   // static let MyBikeScopes: [String] = [OIDScopeOpenID, OIDScopePhone, "IdentityServerApi", "custom.profile", "email", "roles", "offline_access", "B2CApi", "ProductionApi", "VehicleManufacturerApi"]
}
