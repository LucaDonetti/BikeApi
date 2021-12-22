//
//  FirmwareModel.swift
//  Production_API
//
//  Created by Zehus on 15/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import ObjectMapper

public enum FirmwareVersionKey {
    public static let Major = "Major"
    public static let Minor = "Minor"
    public static let Fix = "Fix"
}

public struct FirmwareVersion {
    public let major: Int
    public let minor: Int
    public let fix: Int
    
    public var dictionaryRepresentation: [String : Int] {
        return [FirmwareVersionKey.Major : major,
                FirmwareVersionKey.Minor : minor,
                FirmwareVersionKey.Fix   : fix
        ]
    }
    
    public var stringRepresentation: String {
        return "\(String(major)).\(String(minor)).\(String(fix))"
    }
    
    /// Firmware version as Int value considering only major and minor
    public var intShortRepresentation: Int {
        return major * 10 + minor
    }
    
    public init(major: Int, minor: Int, fix: Int) {
        self.major = major
        self.minor = minor
        self.fix = fix
    }
    
    public init(string: String) {
        let values = string.components(separatedBy: ".").map {Int($0)!}
        self.major = values[0]
        self.minor = values[1]
        self.fix = values[2]
    }
}

/*
 "FileName": "string",
 "File": "string",
 "HashFile": "string"
 */
public struct FirmwareModel {
    
    public enum FirmwareType: Int {
        case dsc = 1
        case ble = 2
        case bms = 3
        case unknown = 0
    }
    
    private let applicationFWVersion: String
    private let bootloaderFWVersion: String?
    private let otherFWVersion: String?
    private let otherFWDetails: String?

    public let typeId: String
    public let typeName: String
    
    public let firmwareType: FirmwareType
    public let application: FirmwareVersion?
    public let bootloader: FirmwareVersion?
 
    public let fileName: String?
    public let file: String?
    public var firmwareProductTypeId: String?
}

extension FirmwareModel: ImmutableMappable {
    public init(map: Map) throws {
        self.typeId = try map.value(BRResponse.Firmware.TypeId)
        self.typeName = try map.value(BRResponse.Firmware.TypeName)
        self.fileName = (try? map.value(BRResponse.Firmware.FileName)) ?? (try? map.value(BRResponse.Firmware.LastFileName))
        self.file = try? map.value(BRResponse.Firmware.File)
        self.applicationFWVersion = (try? map.value(BRResponse.Firmware.ApplicationFirmwareVersion)) ?? (try! map.value(BRResponse.Firmware.LastApplicationFirmwareVersion))
        self.bootloaderFWVersion = (try? map.value(BRResponse.Firmware.BootloaderFirmwareVersion)) ?? (try? map.value(BRResponse.Firmware.LastBootloaderFirmwareVersion))
        self.otherFWVersion = try? map.value(BRResponse.Firmware.OtherFirmwareVersion)
        self.otherFWDetails = try? map.value(BRResponse.Firmware.OtherFirmwareVersionDetail)
        self.application = FirmwareVersion(string: self.applicationFWVersion)
        if self.bootloaderFWVersion != nil {
            self.bootloader = FirmwareVersion(string: self.bootloaderFWVersion!)
        } else {
            self.bootloader = nil
        }
        let rawType: Int? = try? map.value(BRResponse.Firmware.ComponentType)
        self.firmwareType = rawType == nil ? .unknown : (FirmwareType(rawValue: rawType!) ?? .unknown)
        self.firmwareProductTypeId = nil
    }
}

public enum FirmwareTypology: Int {
    case aioVirgin = 1
    case aioProduction = 2
    case aioRelease = 3
    case unknown
}

public struct FirmwareProductTypeModel {
    public let productTypeId: String
    public let productTypeName: String
    public let productTypology: [FirmwareTypology]
    public let lastFirmwareVersion: [FirmwareModel]
    
    public var dscFirmware: FirmwareModel? {
        var fw = self.lastFirmwareVersion.filter{ $0.firmwareType == .dsc }.filter{ firmware in
            if let fn = firmware.fileName, fn.lowercased().hasSuffix("zip") {
                return true
            }
            return false
        }.first
        fw?.firmwareProductTypeId = productTypeId
        return fw
    }
    
    public var bleFirmware: FirmwareModel? {
        var fw = self.lastFirmwareVersion.filter{ $0.firmwareType == .ble }.filter{ firmware in
            if let fn = firmware.fileName, fn.lowercased().hasSuffix("zip") {
                return true
            }
            return false
        }.first
        fw?.firmwareProductTypeId = productTypeId
        return fw
    }
    
    public var bmsFirmware: FirmwareModel? {
        var fw = self.lastFirmwareVersion.filter{ $0.firmwareType == .bms }.filter{ firmware in
            if let fn = firmware.fileName, fn.lowercased().hasSuffix("zip") {
                return true
            }
            return false
        }.first
        fw?.firmwareProductTypeId = productTypeId
        return fw
    }
}

extension FirmwareProductTypeModel: ImmutableMappable {
    public init(map: Map) throws {
        self.productTypeId = try map.value(BRResponse.Firmware.ProductTypeId)
        self.productTypeName = try map.value(BRResponse.Firmware.ProductTypeName)
        self.lastFirmwareVersion = try map.value(BRResponse.Firmware.LastFirmwareVersions)
        let fpt: [Int] = try map.value(BRResponse.Firmware.ProductTypology)
        self.productTypology = fpt.map{ FirmwareTypology(rawValue: $0)}.compactMap{$0}
    }
}
