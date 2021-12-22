//
//  MSALManager.swift
//  MyBike_API
//
//  Created by Andrea Finollo on 27/01/2020.
//  Copyright © 2020 Andrea Finollo. All rights reserved.
//

import Foundation
import MSAL
import PromiseKit

public enum MSALGeneralError: ErrorProtocol {
    public static let errorDomain = "it.zehus.masal_error"
    case invalidIdToken
    case invalidAppSettings
    case configurationError
    case invalidPresenter
    case emptyResponse
    case emptyAuthState
    case unableToCreateAuthority
    case unableToAcquireToken
    case interactionRequired
    
    public var errorDescription: String? {
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
        case .unableToCreateAuthority:
            return "unable to create authority"
        case .unableToAcquireToken:
            return "unable to acquire token"
        case .interactionRequired:
            return "required use interaction"
        }
    }
    public var errorCode: Int {
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
        case .unableToCreateAuthority:
            return code + 7
        case .unableToAcquireToken:
            return code + 8
        case .interactionRequired:
            return code + 9
        }
    }
}

public class MSALManager: NSObject {

    var tokenHelper: TokenHelper?
    public var accessToken: String {
        self.tokenHelper?.token ?? ""
    }
    public var lastUserSub: String? {
        return tokenHelper? .parsedToken.subject ?? KeychainHelper.loadUserSubInKeychain()
    }

    public var hasAccountID: Bool {
        return (_accountID != nil) || (KeychainHelper.loadMSALResultKeychain() != nil)
    }

    private var _accountID: String? {
        willSet(newValue) {
            if newValue != nil {
                KeychainHelper.saveMSALResultInKeychain(newValue!)
            } else {
                KeychainHelper.clearKeychain()
            }
        }
    }

    private let msalConfig: MSALConfigurationable
    let msalApplication: MSALPublicClientApplication

    // - MARK: Initialization
    init(configuration: MSALConfigurationable) throws {
        self.msalConfig = configuration
        self.msalApplication = try MSALManager.buildMSALPublicClientApplication(with: configuration)
        super.init()
    }

    fileprivate static func buildMSALPublicClientApplication(with configuration: MSALConfigurationable) throws -> MSALPublicClientApplication {
        let siginPolicyAuthority = try MSALManager.getAuthority(with: configuration, forPolicy: configuration.SignupOrSigninPolicy)
//        let editProfileAuthority = try MSALManager.getAuthority(with: configuration, forPolicy: configuration.EditProfilePolicy)
        let knownAuthorities: [MSALB2CAuthority]
        if let passwordPolicy = configuration.ResetPasswordPolicy {
            let passwordResetAuthority = try MSALManager.getAuthority(with: configuration, forPolicy: passwordPolicy)
            knownAuthorities = [siginPolicyAuthority, passwordResetAuthority]
        } else {
            knownAuthorities = [siginPolicyAuthority]
        }
        let pcaConfig = MSALPublicClientApplicationConfig(clientId: configuration.ClientId, redirectUri: nil, authority: siginPolicyAuthority)
        pcaConfig.knownAuthorities = knownAuthorities
        return try MSALPublicClientApplication(configuration: pcaConfig)
    }

    
    fileprivate static func getAuthority(with config: MSALConfigurationable, forPolicy policy: String) throws -> MSALB2CAuthority {
        guard let authorityURL = URL(string: String(format: config.EndPoint, config.AuthorityHostName, config.TenantName, policy)) else {
            throw MSALGeneralError.unableToCreateAuthority
        }
        return try MSALB2CAuthority(url: authorityURL)
    }
    
    func procedure_resetPassword(presenter: UIViewController) -> Promise<Void> {
        return Promise<Void> { seal in
            guard let passwordPolicy = msalConfig.ResetPasswordPolicy else {
                seal.reject(MSALGeneralError.configurationError)
                return
            }
            let authority = try MSALManager.getAuthority(with: msalConfig, forPolicy: passwordPolicy)
            
            let webViewParameters = MSALWebviewParameters(parentViewController: presenter)
            let parameters = MSALInteractiveTokenParameters(scopes: msalConfig.Scopes, webviewParameters: webViewParameters)
            parameters.promptType = .selectAccount
            parameters.authority = authority
            msalApplication.acquireToken(with: parameters) { (result, error) in
            try? print("accounts \(self.msalApplication.allAccounts()) ")
                guard let result = result else {
                    if let er = error {
                        seal.reject(er)
                    }
                    seal.reject(MSALGeneralError.unableToAcquireToken)
                    return
                }
                do {
                    self.tokenHelper = try TokenHelper(token: result.accessToken)
                    KeychainHelper.saveUserSubInKeychain(self.tokenHelper!.parsedToken.subject)
                } catch let error {
                    print("Token not JWT conform \(error)")
                }
                self._accountID = result.account.homeAccountId?.identifier
                seal.fulfill(())
            }
        }
    }
    func procedure_loginFrom(presenter: UIViewController) -> Promise<Void> {
        return Promise<Void> { seal in
            let authority = try MSALManager.getAuthority(with: msalConfig, forPolicy: msalConfig.SignupOrSigninPolicy)
            let webViewParameters = MSALWebviewParameters(parentViewController: presenter)
            let parameters = MSALInteractiveTokenParameters(scopes: msalConfig.Scopes, webviewParameters: webViewParameters)
            parameters.promptType = .selectAccount
            parameters.authority = authority
            msalApplication.acquireToken(with: parameters) { (result, error) in
            try? print("accounts \(self.msalApplication.allAccounts()) ")
                guard let result = result else {
                    if let er = error {
                        if error.debugDescription.contains("AADB2C90118") {
                            self.procedure_resetPassword(presenter: presenter).done { res in
                                seal.fulfill(())
                            }.catch { error in
                                seal.reject(error)
                            }
                        }
                        seal.reject(er)
                    }
                    seal.reject(MSALGeneralError.unableToAcquireToken)
                    return
                }
                do {
                    self.tokenHelper = try TokenHelper(token: result.accessToken)
                    KeychainHelper.saveUserSubInKeychain(self.tokenHelper!.parsedToken.subject)
                } catch let error {
                    print("Token not JWT conform \(error)")
                }
                self._accountID = result.account.homeAccountId?.identifier
                seal.fulfill(())
            }
        }
    }
    
    func cleanCredentialForLogout() {
        if let accountToRemove = try? self.getAccountByPolicy(withAccounts: msalApplication.allAccounts(), policy: msalConfig.SignupOrSigninPolicy) {
            do {
                try msalApplication.remove(accountToRemove)
            }
            catch let error {
              print("error while removing account \(error)")
            }
        } else {
            print( "There is no account to signing out!")
        }
        _accountID = nil
        tokenHelper = nil
    }
    
    func refreshToken(with completion: @escaping (Error?) -> Void) {
        do {
            let authority = try MSALManager.getAuthority(with: msalConfig, forPolicy: msalConfig.SignupOrSigninPolicy)
            
            guard let thisAccount = try self.getAccountByPolicy(withAccounts: msalApplication.allAccounts(), policy: msalConfig.SignupOrSigninPolicy) else {
                print("No Account available")
                return
            }
            
            let parameters = MSALSilentTokenParameters(scopes:msalConfig.Scopes, account:thisAccount)
            parameters.authority = authority
            msalApplication.acquireTokenSilent(with: parameters) { (result, error) in
                if let error = error {
                    let nsError = error as NSError
                    if (nsError.domain == MSALErrorDomain) {
                        print("error --> \(nsError.code) msal \(MSALError.interactionRequired.rawValue)")
                        if (nsError.code == MSALError.interactionRequired.rawValue) {
                            completion(MSALGeneralError.interactionRequired)
                            self.cleanCredentialForLogout()
                            return
                        }
                    }
                    completion(error)
                    return
                }
                guard let result = result else {
                    completion(MSALGeneralError.unableToAcquireToken)
                    return
                }
                do {
                    self.tokenHelper = try TokenHelper(token: result.accessToken)
                    KeychainHelper.saveUserSubInKeychain(self.tokenHelper!.parsedToken.subject)
                } catch let error {
                    print("Token not JWT conform \(error)")
                }
                completion(nil)
            }
        } catch let error {
            completion(error)
        }
    }
    
    func getAccountByPolicy (withAccounts accounts: [MSALAccount], policy: String) throws -> MSALAccount? {
        
        for account in accounts {
            if let homeAccountId = account.homeAccountId, let objectId = homeAccountId.objectId {
                if objectId.hasSuffix(policy.lowercased()) {
                    return account
                }
            }
        }
        return nil
    }
}
