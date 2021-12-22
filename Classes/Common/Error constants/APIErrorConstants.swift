//
//  APIErrorConstants.swift
//  MyBike_v2_App
//
//  Created by Zehus on 13/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
public enum APIError: BackEndError {
    enum ServerErrorKey {
        static let Internal = "InternalServerErrorKey"
        static let Generic = "GenericErrorKey"
        static let Multiple = "multipleErrors"
        static let NullObject = "nullObjectError"
        static let BatteryPackNotFound = "BatteryPackNotFoundKey"
        static let BmsNotFound = "BmsNotFoundKey"
        static let BmsAlreadyUsed = "BmsAlreadyUsedKey"
        static let DriverNotFound = "DriverNotFoundKey"
        static let DriverAlreadyAssociatedWithSmartMotor = "DriverAlreadyAssociatedWithASmartMotorKey"
        static let ModelValidation = "ModelValidationErrorKey"
        static let DriverAlreadyCreated = "DriverAlreadyCreatedKey"
        static let HubNotFound = "HubNotFoundKey"
        static let BatteryPackAlreadyAssociatedWithAnHub = "BatteryPackAlreadyAssociatedWithAnHubKey"
        static let SmartMotorNotFound = "SmartMotorNotFoundKey"
        static let SmartMotorAlreadyAssociatedWithAnHub = "SmartMotorAlreadyAssociatedWithAnHubKey"
        static let FirmwareProductTypeNotFoundException = "FirmwareProductTypeNotFoundException"
        static let DscApplicationFirmwareVersionIsGreaterException = "DscApplicationFirmwareVersionIsGreaterException"
        static let ServiceInoperativeKey = "ServiceInoperativeKey"
        static let HubAlreadyConfiguredKey = "HubAlreadyConfiguredKey"
        
        // User
        static let duplicateUserNameKey                 = "DuplicateUserNameKey"                // If the passed email exists on IDP
        static let passwordTooShortKey                  = "PasswordTooShortKey"                 // Invalid password format
        static let passwordRequiresNonAlphanumericKey   = "PasswordRequiresNonAlphanumericKey"  // Invalid password format
        static let PasswordRequiresDigitKey             = "PasswordRequiresDigitKey"            // Invalid password format
        static let CompanyNotFoundKey                   = "CompanyNotFoundKey"                  // If the CompanyId not exist in the database
        static let AccountNotFoundKey                   = "AccountNotFoundKey"                  // If the passed UserId not exist on IDP
        static let UsersAlreadyCreatedKey               = "UsersAlreadyCreatedKey"              // if the passed UserId alredy exist on Production tool context
        static let UserNotFoundKey                      = "UserNotFoundKey"                     // user not found on cloud
        
        // Vehicle
        static let VehicleAlreadyAssociatedKey          = "VehicleAlreadyAssociatedKey"
        static let VehicleAlreadyDisassociatedKey       = "VehicleAlreadyDisassociatedKey"
        static let VehicleNotFoundKey                   = "VehicleNotFoundKey"
        static let AntitamperActivatedKey               = "AntitamperActivated"
        
    }
    
    public static let errorDomain = "it.mybike.api_error"
    
    case `internal`
    case generic
    case multiple
    case nullObject
    case batteryPackNotFound
    case bmsNotFound
    case bmsAlreadyUsed
    case driverNotFound
    case driverAlreadyAssociatedWithSmartMotor
    case modelValidation
    case driverAlreadyCreated
    case hubNotFound
    case batteryPackAlreadyAssociatedWithAnHub
    case smartMotorNotFound
    case smartMotorAlreadyAssociatedWithAnHub
    case firmwareProductTypeNotFoundException
    case dscApplicationFirmwareVersionIsGreaterException
    case vehicleAlreadyAssociated
    case vehicleAlreadyDisassociated
    case vehicleNotFoundKey
    case noInternetConnection
    case tokenExpiredError
    case userNotFoundkey
    case serviceInoperative
    case antitamperActivated
    case hubAlreadyConfigured
    
    public init?(key: String) {
        self = APIError.errorFromKey(key)
    }
    static func errorFromKey(_ key: String) -> APIError {
        switch key {
        case ServerErrorKey.Internal:
            return APIError.internal
        case ServerErrorKey.Generic:
            return APIError.generic
        case ServerErrorKey.Multiple:
            return APIError.multiple
        case ServerErrorKey.NullObject:
            return APIError.nullObject
        case ServerErrorKey.BatteryPackNotFound:
            return APIError.batteryPackNotFound
        case ServerErrorKey.BmsNotFound:
            return APIError.bmsNotFound
        case ServerErrorKey.BmsAlreadyUsed:
            return APIError.bmsAlreadyUsed
        case ServerErrorKey.DriverNotFound:
            return APIError.driverNotFound
        case ServerErrorKey.DriverAlreadyAssociatedWithSmartMotor:
            return APIError.driverAlreadyAssociatedWithSmartMotor
        case ServerErrorKey.ModelValidation:
            return APIError.modelValidation
        case ServerErrorKey.DriverAlreadyCreated:
            return APIError.driverAlreadyCreated
        case ServerErrorKey.HubNotFound:
            return APIError.hubNotFound
        case ServerErrorKey.BatteryPackAlreadyAssociatedWithAnHub:
            return APIError.batteryPackAlreadyAssociatedWithAnHub
        case ServerErrorKey.SmartMotorNotFound:
            return APIError.smartMotorNotFound
        case ServerErrorKey.SmartMotorAlreadyAssociatedWithAnHub:
            return APIError.smartMotorAlreadyAssociatedWithAnHub
        case ServerErrorKey.DscApplicationFirmwareVersionIsGreaterException:
            return APIError.dscApplicationFirmwareVersionIsGreaterException
        case ServerErrorKey.FirmwareProductTypeNotFoundException:
            return APIError.firmwareProductTypeNotFoundException
        case ServerErrorKey.VehicleAlreadyAssociatedKey:
            return APIError.vehicleAlreadyAssociated
        case ServerErrorKey.VehicleAlreadyDisassociatedKey:
            return APIError.vehicleAlreadyDisassociated
        case ServerErrorKey.VehicleNotFoundKey:
            return APIError.vehicleNotFoundKey
        case ServerErrorKey.UserNotFoundKey:
            return APIError.userNotFoundkey
        case ServerErrorKey.ServiceInoperativeKey:
            return APIError.serviceInoperative
        case ServerErrorKey.AntitamperActivatedKey:
            return APIError.antitamperActivated
        case ServerErrorKey.HubAlreadyConfiguredKey:
            return APIError.hubAlreadyConfigured
        default:
            return APIError.generic
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .internal:
            return "Internal exception"
        case .generic:
            return "Generic error"
        case .multiple:
            return "Multiple errors"
        case .nullObject:
            return "Null object error"
        case .batteryPackNotFound:
            return "Battery Pack not found"
        case .bmsNotFound:
            return "BMS not found"
        case .bmsAlreadyUsed:
            return "BMS already used"
        case .driverNotFound:
            return "Driver not found"
        case .driverAlreadyAssociatedWithSmartMotor:
            return "Driver already associated with SmartMotor"
        case .modelValidation:
            return "Model validation error: some parameters are missing from the call"
        case .driverAlreadyCreated:
            return "Driver already created"
        case .hubNotFound:
            return "Hub not found"
        case .batteryPackAlreadyAssociatedWithAnHub:
            return "Battery pack already used by a Hub"
        case .smartMotorNotFound:
            return "Smart motor not found"
        case .smartMotorAlreadyAssociatedWithAnHub:
            return "Smart motor already used by a Hub"
        case .firmwareProductTypeNotFoundException:
            return "There is no such firware with this product type"
        case .dscApplicationFirmwareVersionIsGreaterException:
            return "The firmware version is greater than expected"
        case .vehicleAlreadyAssociated:
            return "Vehicle already registered to another account"
        case .vehicleAlreadyDisassociated:
            return "Vehicle already disassociated on cloud"
        case .vehicleNotFoundKey:
            return "Vehicle not found"
        case .noInternetConnection:
            return "No internet connection available"
        case .tokenExpiredError:
            return "Access token expired"
        case .userNotFoundkey:
            return "User not found"
        case .serviceInoperative:
            return "Service inoperative"
        case .antitamperActivated:
            return "Somone has changed the response"
        case .hubAlreadyConfigured:
            return "Hub already configured"
        }
    }
    
    public var errorCode: Int {
        let code = 700
        switch self {
        case .internal:
            return code + 1
        case .generic:
            return code + 2
        case .multiple:
            return code + 3
        case .nullObject:
            return code + 4
        case .batteryPackNotFound:
            return code + 5
        case .bmsNotFound:
            return code + 6
        case .bmsAlreadyUsed:
            return code + 7
        case .driverNotFound:
            return code + 8
        case .modelValidation:
            return code + 9
        case .driverAlreadyCreated:
            return code + 10
        case .hubNotFound:
            return code + 11
        case .batteryPackAlreadyAssociatedWithAnHub:
            return code + 12
        case .smartMotorNotFound:
            return code + 13
        case .smartMotorAlreadyAssociatedWithAnHub:
            return code + 14
        case .driverAlreadyAssociatedWithSmartMotor:
            return code + 15
        case .firmwareProductTypeNotFoundException:
            return code + 16
        case .dscApplicationFirmwareVersionIsGreaterException:
            return code + 17
        case .vehicleAlreadyAssociated:
            return code + 18
        case .vehicleAlreadyDisassociated:
            return code + 19
        case .vehicleNotFoundKey:
            return code + 20
        case .noInternetConnection:
            return code + 21
        case .tokenExpiredError:
            return code + 22
        case .userNotFoundkey:
            return code + 23
        case .serviceInoperative:
            return code + 24
        case .antitamperActivated:
            return code + 25
        case .hubAlreadyConfigured:
            return code + 26
        }
    }
}
