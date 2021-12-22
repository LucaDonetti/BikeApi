//
//  Vehicle.swift
//  MyBike_API
//
//  Created by Andrea Finollo on 28/05/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import ObjectMapper

public struct BeaconModel {
    public let uuid: String
    public let major: Int
    public let minor: Int
    public init(uuid: String, major: Int, minor: Int) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
}

extension BeaconModel: ImmutableMappable {
    public init(map: Map) throws {
        self.uuid = try map.value(BRResponse.Beacon.Uuid)
        self.major = try map.value(BRResponse.Beacon.Major)
        self.minor = try map.value(BRResponse.Beacon.Minor)
    }
    
    var stringRepresentation: String {
        get {
            return "\(uuid)-\(String(major))-\(String(minor))"
        }
    }
    
    var hexStringRepresentation: String {
        get {
            return "\(uuid)-\(String(format: "%04X", major))-\(String(format: "%04X", minor))"
        }
    }
}

public struct VehicleFirmwareInfo {
    public let driverFirmwareProductTypeId: String
    public let driverDscApplicationFirmwareVersion: String
    public let driverBleApplicationFirmwareVersion: String
    public let driverBmsApplicationFirmwareVersion: String?
    public init(driverFirmwareProductTypeId: String,
                driverDscApplicationFirmwareVersion: String,
                driverBleApplicationFirmwareVersion: String,
                driverBmsApplicationFirmwareVersion: String) {
        self.driverFirmwareProductTypeId = driverFirmwareProductTypeId
        self.driverDscApplicationFirmwareVersion = driverDscApplicationFirmwareVersion
        self.driverBleApplicationFirmwareVersion = driverBleApplicationFirmwareVersion
        self.driverBmsApplicationFirmwareVersion = driverBleApplicationFirmwareVersion
    }
}


public struct EOLModel {
    public let wheelLenght: Int
    public let frontRing: Int
    public let rearRing: Int
    public let motorKe: Float
    public init (wheelLenght: Int, frontRing: Int, rearRing: Int, motorKe: Float) {
        self.wheelLenght = wheelLenght
        self.frontRing = frontRing
        self.rearRing = rearRing
        self.motorKe = motorKe
    }
}

/* {
 "Data": [
 {
 "HubId": "string",
 "Beacon": {
 "Uuid": "string",
 "Major": 0,
 "Minor": 0
 },
 "SerialNumber": "string",
 "DriverBleMacAddress": "string",
 "DriverFirmwareProductTypeId": "string",
 "DriverDscApplicationFirmwareVersion": "string",
 "DriverBleApplicationFirmwareVersion": "string",
 "VehicleId": "string",
 "FrameNumber": "string",
 "VehicleModelName": "string",
 "WheelLength": 0,
 "FrontRing": 0,
 "RearRing": 0,
 "VehicleBrandName": "string",
 "ManufacturerName": "string"
 }
 ]
 }
 */

public struct VehicleAPIModel {
    public let hubId: String
    public let beacon: BeaconModel
    public let serialNumber: String
    public let driverBleMacAddress: String
    public let driverFirmwareProductTypeName: String
    public let vehicleFirmwareInfo: VehicleFirmwareInfo
    public let vehicleId: UUID
    public let driverId: String
    public let frameNumber: String
    public let vehicleModelName: String
    public let vehicleBrandName: String
    public let manufacturerName: String
    public let privateName: String?
    public let eol: EOLModel
    public let alreadyRegistered: Bool?
    public let associatedRemote: RemoteControllerAPIModel?
    
    public init( hubId: String,
                 beacon: BeaconModel,
                 serialNumber: String,
                 driverBleMacAddress: String,
                 driverFirmwareProductTypeName: String,
                 vehicleFirmwareInfo: VehicleFirmwareInfo,
                 vehicleId: UUID,
                 driverId: String,
                 frameNumber: String,
                 vehicleModelName: String,
                 vehicleBrandName: String,
                 manufacturerName: String,
                 eol: EOLModel,
                 alreadyRegistered: Bool?,
                 associatedRemote: RemoteControllerAPIModel?) {
        self.hubId = hubId
        self.beacon = beacon
        self.serialNumber = serialNumber
        self.driverBleMacAddress = driverBleMacAddress
        self.driverFirmwareProductTypeName = driverFirmwareProductTypeName
        self.vehicleFirmwareInfo = vehicleFirmwareInfo
        self.vehicleId = vehicleId
        self.driverId = driverId
        self.frameNumber = frameNumber
        self.vehicleBrandName = vehicleBrandName
        self.vehicleModelName = vehicleModelName
        self.manufacturerName = manufacturerName
        self.eol = eol
        self.alreadyRegistered = alreadyRegistered
        self.privateName = nil
        self.associatedRemote = associatedRemote
    }
}

extension VehicleAPIModel: ImmutableMappable {
    public init(map: Map) throws {
        self.hubId = try map.value(BRResponse.Vehicle.HubId)
        self.beacon = try map.value(BRResponse.Vehicle.Beacon)
        self.serialNumber = (try? map.value(BRResponse.Vehicle.SerialNumber)) ?? (try! map.value(BRResponse.Vehicle.HubSerialNumber))
        self.driverBleMacAddress = try map.value(BRResponse.Vehicle.DriverBleMacAddress)
        self.driverFirmwareProductTypeName = try map.value(BRResponse.Vehicle.DriverFirmwareProductTypeName)
        let driverFirmwareProductTypeId: String = try map.value(BRResponse.Vehicle.DriverFirmwareProductTypeId)
        let driverDscApplicationFirmwareVersion: String = try map.value(BRResponse.Vehicle.DriverDscApplicationFirmwareVersion)
        let driverBleApplicationFirmwareVersion: String = try map.value(BRResponse.Vehicle.DriverBleApplicationFirmwareVersion)
        self.vehicleFirmwareInfo = VehicleFirmwareInfo(driverFirmwareProductTypeId: driverFirmwareProductTypeId,
                                                       driverDscApplicationFirmwareVersion: driverDscApplicationFirmwareVersion,
                                                       driverBleApplicationFirmwareVersion: driverBleApplicationFirmwareVersion, driverBmsApplicationFirmwareVersion: "1") // N
        self.vehicleId = UUID(uuidString: try map.value(BRResponse.Vehicle.VehicleId))!
        self.driverId = try map.value(BRResponse.Vehicle.DriverId)
        self.frameNumber = try map.value(BRResponse.Vehicle.FrameNumber)
        self.vehicleBrandName = try map.value(BRResponse.Vehicle.VehicleBrandName)
        self.vehicleModelName = try map.value(BRResponse.Vehicle.VehicleModelName)
        self.manufacturerName = try map.value(BRResponse.Vehicle.ManufacturerName)
        let wheelLenght: Int = try map.value(BRResponse.Vehicle.WheelLength)
        let frontRing: Int = try map.value(BRResponse.Vehicle.FrontRing)
        let rearRing: Int  = try map.value(BRResponse.Vehicle.RearRing)
        let motorKe: Double = try map.value(BRResponse.Eol.MotorTypeKe)
        self.eol = EOLModel(wheelLenght: wheelLenght, frontRing: frontRing, rearRing: rearRing, motorKe: Float(motorKe))
        self.alreadyRegistered = try? map.value(BRResponse.Vehicle.AlreadyRegister)
        self.privateName = try? map.value(BRResponse.Vehicle.PrivateVehicleName)
        self.associatedRemote = try? map.value(BRResponse.Vehicle.RemoteController)
    }
}

//    {
//        "vehicleId": "string",
//        "vehicleName": "string",
//        "serialNumber": "string",
//        "hubSerialNumber": "string",
//        "remoteController": {
//            "deviceUniqueName": "string",
//            "firmwareRevision": "string",
//            "hardwareRevision": "string",
//            "manufacturerName": "string"
//        }
//    }

public struct VehicleLiteAPIModel {
    public let vehicleId: String
    public let vehicleName: String
    public let serialNumber: String
    public let hubSerialNumber: String
    public let associatedRemote: RemoteControllerAPIModel?

    public init(vehicleId: String,
                 vehicleName: String,
                 serialNumber: String,
                 hubSerialNumber: String,
                 associatedRemote: RemoteControllerAPIModel?) {
        self.vehicleId = vehicleId
        self.vehicleName = vehicleName
        self.serialNumber = serialNumber
        self.hubSerialNumber = hubSerialNumber
        self.associatedRemote = associatedRemote
    }
}

extension VehicleLiteAPIModel: ImmutableMappable {
    public init(map: Map) throws {
        self.vehicleId = try map.value(BRResponse.VehicleLite.VehicleId)
        self.vehicleName = try map.value(BRResponse.VehicleLite.VehicleName)
        self.serialNumber = try map.value(BRResponse.VehicleLite.SerialNumber)
        self.hubSerialNumber = try map.value(BRResponse.VehicleLite.HubSerialNumber)
        self.associatedRemote = try? map.value(BRResponse.Vehicle.RemoteController)
    }
}
