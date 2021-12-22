//
//  HTTPParamAndResponse.swift
//  MyBike_v2_App
//
//  Created by Zehus on 08/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation

/**
 List of paths
 */

//TODO: remove UserForgotPassword

/*
 PUT https://zehus-api-common-integration.azure-api.net/MyBikeApp/Remote/PurchaseData
 GET https://zehus-api-common-integration.azure-api.net/MyBikeApp/Remote/{deviceUniqueName}/PurchaseData
*/

struct BRPath {
    static let GetUserProfile               = "/connect/userinfo" // GET
    static let UpdateUserProfile            = "/User" // PUT
    static let GetVehicleForUser            = "/User/Vehicles/{page}/{rows}" // GET
    static let GetVehicleLiteForUser        = "/User/Vehicles/{page}/{rows}/lite" // GET
    static let GetVehicle                   = "/Vehicle/{serialNumber}" // GET
    static let UpdateBikeName               = "/Vehicle/{id}" // PUT
    static let UploadProofOfPurchase        = "/Vehicle/PurchaseData" // PUT
    static let UploadRemoteProofOfPurchase  = "/Remote/PurchaseData" // PUT
    static let GetProofOfPurchase           = "/Vehicle/PurchaseDataInfo/{id}" //GET
    static let GetRemoteProofOfPurchase     = "/Remote/{id}/PurchaseData" //GET"
    static let CreateUserVehicleAssociation = "/Vehicle" // POST
    static let DeleteUserVehicleAssociation = "/Vehicle/{id}" // DELETE
    static let PutTelemetryData             = "/VehicleHub/{id}/TelemetryData" // PUT
    static let PostRemoteController         = "/Vehicle/RemoteController" // POST
    static let DeleteRemoteFromVehicle      = "/Vehicle/{vehicleId}/RemoteController/{deviceName}" // DELETE
    static let GetFaultList                 = "/VehicleHub/{id}/Faults/{page}/{rows}" // GET
    static let SendReport                   = "/Vehicle/Report" //POST"

    static let GetLastFault                 = "/VehicleHub/{id}/LastFault" // GET
    
    // MARK: - Firmware
    static let GetLastFirmwareProductType   = "/FirmwareProduct/{id}"         // GET
    static let GetAllFirmwareProductTypes   = "/FirmwareProductTypes"             // GET Returns indetifier for AIO or Remote
    static let GetFirmware                  = "/Firmware/{id}"       // GET
    static let FirmwareUpdate               = "/VehicleDriver/{id}/ApplicationFirmwares" // PUT
    
}
// MARK: - Parameters
/**
 List of parameters and their constant values that can receive during a request
 */
struct BRParameters {
    struct Placeholder {
        static let IdPh = "{id}"
        static let PagePh = "{page}"
        static let RowPh = "{rows}"
        static let VersionPh = "{version}"
        static let VehicleSerialPh = "{serialNumber}"
        static let Data = "Data"
        static let SerialNumber = "{serialnumber}"
    }
    
    struct User {
        static let FirstName = "firstName"
        static let LastName  = "lastName"
        static let Birthday = "birthday"
        static let Weight = "weight"
        static let Gender = "gender"
        static let Height = "height"
    }
    
    struct Telemetry {
        static let GpsInfo = "Gpsinfo"
        struct GpsInfoData {
            static let Latitude     = "Latitude"
            static let Longitude    = "Longitude"
            static let Altitude     = "Altitude"
        }
        static let FaultInfo = "FaultInfo"
        struct FaultInfoData {
            static let DSCErrorFault     = "DscFault"
            static let DSCWarningFault     = "DscWarning"
            static let BLEErrorFault   = "BleFault"
        }
        static let TotalKm = "TotalKm"
        static let MillisUtcDate = "MillisUtcDate"
        static let BatteryCycles = "BatteryCycles"
    }
    
    struct Driver {
        static let DriverId                         = "DriverId"
        static let BleMacAddress                    = "BleMacAddress"
        static let SerialNumber                     = "SerialNumber"
        static let DscApplicationFirmwareVersion    = "DscApplicationFirmwareVersion"
        static let DscBootloaderFirmwareVersion     = "DriverBootloaderFirmwareVersion"
        static let BleApplicationFirmwareVersion    = "ApplicationFirmwareVersion"
        static let BleBootloaderFirmwareVersion     = "BleBootloaderFirmwareVersion"
        static let BleSoftDeviceFirmwareVersion     = "BleSoftDeviceFirmwareVersion"
        static let FirmwareProductTypeId            = "FirmwareProductTypeId"
        
        static let DriverDscApplicationFirmwareVersion    = "DriverDscApplicationFirmwareVersion"
        static let DriverBleApplicationFirmwareVersion    = "DriverBleApplicationFirmwareVersion"
        static let DriverBmsApplicationFirmwareVersion    = "DriverBmsApplicationFirmwareVersion"
        
    }
    
    struct AssociateVehicle {
        static let HubSerialNumber = "HubSerialNumber"
        static let VehicleName = "VehicleName"
        static let UserLanguage = "UserLanguage"
    }
    struct Firmware {
        static let PreRelease = "PreRelease"
        static let FirmwareProductId = "FirmwareProductId"
        static let Version = "Version"
        static let File = "File"
        static let FileName = "FileName"
        static let UpdateChannelType = "uct"
        static let FirmwareProdutTypology = "fpt"
    }
    
    struct PaginationModel {
        static let data = "Data"
        static let totalPages = "PaginationViewModel.TotalPages"
        static let currentPage = "PaginationViewModel.Page"
        static let rows = "PaginationViewModel.Rows"
        static let queryPage = "page"
        static let queryRows = "rows"
        static let sort = "sort"
    }
    
    struct RemoteControllerModel {
        static let vehicleId = "VehicleId"
        static let deviceUniqueName = "DeviceUniqueName"
        static let firmwareRevision = "FirmwareRevision"
        static let hardwareRevision = "HardwareRevision"
        static let manufacturerName = "ManufacturerName"
    }
    struct ProofOfPurchaseModel {
        static let vehicleId = "VehicleId"
        static let purchaseDateMillisecs = "PurchaseDateMillisecs"
        static let fileContent = "FileContent"
    }
    struct RemoteProofOfPurchaseModel {
        static let remoteId = "DeviceUniqueName"
        static let purchaseDateMillisecs = "PurchaseDateMillisecs"
        static let fileContent = "FileContent"
    }
    struct VehicleReport {
        static let VehicleId = "vehicleId"
        static let HubSerialNumber = "hubSerialNumber"
        static let HubId = "hubId"
        static let Report = "report"
        static let diagnosticReportType = "diagnosticReportType"
    }
}
struct BRResponse {
    
    struct Telemetry {
        static let Altitude        = "Altitude"
        static let Longitude       = "Longitude"
        static let Latitude        = "Latitude"
        static let TotalKm         = "TotalKm"
        static let DSCErrorFault   = "DscFault"
        static let DSCWarningFault = "DscWarning"
        static let BLEErrorFault   = "BleFault"
        static let FaultUtcMillis  = "MillisUtcDate"
        static let BatteryCycles   = "BatteryCicles"
        static let GpsInfo         = "Gpsinfo"
        static let FaultInfo       = "FaultInfo"
    }
    
    struct User {
        static let firstName      = "firstName"
        static let lastName       = "lastName"
        static let birthdate      = "birthday"
        static let gender         = "gender"
        static let weight         = "weight"
        static let height         = "height"
        static let country        = "country"
        static let creationDate   = "creationDate"
        static let updateDate     = "updateDate"
        static let sub            = "sub"
        static let roles          = "role"
        static let email          = "emailAddress"
        static let email_verified = "email_verified"
    }
    struct ProofOfPurchase {
        static let purchaseDateMillisecs = "PurchaseDateMillisecs"
        static let isFilePresent = "FileExist"
    }
    struct Id {
        static let Id = "Id"
        static let Serial = "SerialNumber"
        static let Beacon = "Beacon"
    }
    
    struct Beacon {
        static let Uuid = "Uuid"
        static let Major = "Major"
        static let Minor = "Minor"
    }
   
    struct Vehicle {
        static let HubId = "HubId"
        static let Beacon = "Beacon"
        static let SerialNumber = "SerialNumber"
        static let HubSerialNumber = "HubSerialNumber"
        static let DriverBleMacAddress = "DriverBleMacAddress"
        static let DriverFirmwareProductTypeName = "DriverFirmwareProductTypeName"
        static let DriverFirmwareProductTypeId = "DriverFirmwareProductTypeId"
        static let DriverDscApplicationFirmwareVersion = "DriverDscApplicationFirmwareVersion"
        static let DriverBleApplicationFirmwareVersion = "DriverBleApplicationFirmwareVersion"
        static let VehicleId = "VehicleId"
        static let DriverId = "DriverId"
        static let FrameNumber = "FrameNumber"
        static let WheelLength = "WheelLength"
        static let FrontRing = "FrontRing"
        static let RearRing = "RearRing"
        static let VehicleBrandName = "VehicleBrandName"
        static let ManufacturerName = "ManufacturerName"
        static let VehicleModelName = "VehicleModelName"
        static let AlreadyRegister = "AlreadyRegistered"
        static let PrivateVehicleName = "VehicleName"
        static let RemoteController = "RemoteController"
    }

    struct VehicleLite {
        static let VehicleId = "VehicleId"
        static let VehicleName = "VehicleName"
        static let SerialNumber = "SerialNumber"
        static let HubSerialNumber = "HubSerialNumber"
        static let RemoteController = "RemoteController"
    }

    struct Eol {
        static let Circumference = "Circumference"
        static let FrontRingGear = "FrontRingGear"
        static let RearRingGear = "RearRingGear"
        static let Brand = "Brand"
        static let Model = "Model"
        static let FrameNumber = "FrameNumber"
        static let HubCaseSerialNumber = "HubCaseSerialNumber"
        static let `operator` = "Operator"
        static let MotorTypeKe = "MotorTypeKe"
        static let CreationDate = "CreationDate"
    }
  
    struct Firmware {
        static let ProductId = "FirmwareProductId"
        static let ProductName = "FirmwareProductName"
        static let ProductTypeId = "FirmwareProductTypeId"
        static let ProductTypeName = "FirmwareProductTypeName"
        static let LastFirmwareVersions = "LastFirmwareVersions"
        static let TypeId = "FirmwareTypeId"
        static let TypeName = "FirmwareTypeName"
        static let ApplicationFirmwareVersion = "ApplicationFirmwareVersion"
        static let BootloaderFirmwareVersion = "BootloaderFirmwareVersion"
        static let LastApplicationFirmwareVersion = "LastAppFirmwareVersion"
        static let LastBootloaderFirmwareVersion = "LastBootloaderFirmwareVersion"
        static let OtherFirmwareVersion = "OtherFirmwareVersion"
        static let OtherFirmwareVersionDetail = "OtherFirmwareVersionDetails"
        static let Version = "Version"
        static let Major = "Major"
        static let Minor = "Minor"
        static let Build = "Build"
        static let Revision = "Revision"
        static let FileName = "FileName"
        static let LastFileName = "LastFirmwareFileName"
        static let File = "File"
        static let HashFile = "HashFile"
        static let ProductTypology = "FirmwareProductTypology"
        static let ComponentType = "ComponentType"
    }
}
