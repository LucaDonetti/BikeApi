//
//  Report.swift
//  MyBike_API
//
//  Created by Piccirilli Federico on 10/7/21.
//  Copyright © 2021 Andrea Finollo. All rights reserved.
//

public enum DiagnosticReportType: Int {
    case NoAssistance = 0
    case LowAssistance = 1
    case RandomAssistance = 2
    case BatteryRange = 3
    case NoKers = 4
    case HubLocked = 5
    case WrongDistanceAndSpeed = 6
    case UnexpectedSwitchOff = 7
    case Noise = 8
}

public struct SendReportAPIModel {
    public let vehicleId: String
    public let hubId: String
    public let hubSerialNumber: String
    public let diagnosticReportType: DiagnosticReportType
    public let report: String
}
