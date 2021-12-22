//
//  ApplicationType.swift
//  MyBike_API
//
//  Created by Zehus on 15/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation

public enum HubType: Int {
    case bikePlus
    case bike
    case smartPed
    case bikePlusJp
    case bikeJp
    case bikePlusUs
    case bikeUs
    case rearDynamo
}
/*
 3    V2Ext
 2    V2
 1    Slim
 0    Full
 */
public enum BmsType: Int, CustomStringConvertible {
    public var description: String {
        switch self {
        case .slim:
            return "Slim"
        case .full:
            return "Full"
        case .v2:
            return "V2"
        case .v2ext:
            return "V2Ext"
        }
    }
    
    case slim = 1
    case full = 2
    case v2 = 3
    case v2ext = 4
}


public enum MotorType: Int, CustomStringConvertible {
    public var description: String {
        switch self {
        case .scooter:
            return "HB000004 code: \(self.rawValue)"
        case .bikeNormal:
            return "HB000006 code: \(self.rawValue)"
        case .motor120:
            return "HB000005 code: \(self.rawValue)"
        case .motor130:
            return "HB000099 code: \(self.rawValue)"
        case .motor145:
            return "HB000003 code: \(self.rawValue)"
        }
    }
    
    case scooter = 0
    case bikeNormal = 1
    case motor120 = 2
    case motor130 = 3
    case motor145 = 4
    
    
}
/*
 image/png
 application/pdf
 */
public enum MimeType: String {
    case imgPng = "image/png"
    case appPdf = "application/pdf"
}

/*
 2    ProductionLine
 3    BatteryPack
 4    Bms
 5    Driver
 6    BikeManufacturer
 7    ServiceCenterBackOfficeOperator
 8    ServiceCenterTechnical
 9    ServiceCenterAdmin
 */

public enum UserRole: Int {
    case productionLine = 2
    case batteryPack = 3
    case bms = 4
    case driver = 5
    case bikeManufacturer = 6
    case serviceCenterBackOfficeOperator = 7
    case serviceCenterTechnical = 8
    case serviceCenterAdmin = 9
}
