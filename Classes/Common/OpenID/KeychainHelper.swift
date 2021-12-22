//
//  KeychainHelper.swift
//  MyBike_v2_App
//
//  Created by Zehus on 12/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import KeychainAccess

public struct KeychainHelper {
    private struct KeychainKeys {
        static let MSALAccountIDResult = "MSALAccountID"
        static let UserSub = "LastUserSub"
    }
    private static let service = Bundle.main.bundleIdentifier!
    private static let keychain = Keychain(service: service)
    public static func clearKeychain() {
        do {
            print("clearing keychain")
            try keychain.remove(KeychainKeys.MSALAccountIDResult)
            try keychain.remove(KeychainKeys.UserSub)
        } catch let error {
            print("error cleaning up keychain: \(error)")
        }
    }
    static func loadMSALResultKeychain() -> String? {
        print("Loading from keychain")
        let accountID = keychain[string: KeychainKeys.MSALAccountIDResult]
        return accountID
    }
    /// Stores in the keychain the access token
    static func saveMSALResultInKeychain(_ accountID: String?) {
        print("Saving to keychain")
        if let accountID = accountID {
            keychain[string: KeychainKeys.MSALAccountIDResult] = accountID
        } else {
            clearKeychain()
        }
    }
    static func loadUserSubInKeychain() -> String? {
        let sub = keychain[string: KeychainKeys.UserSub]
        return sub
    }
    static func saveUserSubInKeychain(_ sub: String?) {
        if let sub = sub {
            keychain[string: KeychainKeys.UserSub] = sub
        }
    }
}
