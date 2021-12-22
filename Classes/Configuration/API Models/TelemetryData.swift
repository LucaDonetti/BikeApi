//
//  TelemetryData.swift
//  MyBike_API
//
//  Created by Zehus on 27/06/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ApiGpsInfo {
    public let latitude: Double
    public let longitute: Double
    public let altitude: Double?
    public init(latitude: Double, longitute: Double, altitude: Double?) {
        self.latitude = latitude
        self.longitute = longitute
        self.altitude = altitude
    }
    public var dictionaryRepresentation: [String : Double] {
        return [
            BRParameters.Telemetry.GpsInfoData.Latitude: self.latitude,
            BRParameters.Telemetry.GpsInfoData.Longitude: self.longitute,
            BRParameters.Telemetry.GpsInfoData.Altitude: self.altitude ?? 0
        ]
    }
}
extension ApiGpsInfo: ImmutableMappable {
     public init(map: Map) throws {
        self.latitude = try map.value(BRResponse.Telemetry.Latitude)
        self.longitute = try map.value(BRResponse.Telemetry.Longitude)
        self.altitude = try? map.value(BRResponse.Telemetry.Altitude)
    }
}
public struct ApiFaultInfo {
    public let dscErrorFault: Int
    public let dscWarningFault: Int
    public let bleErrorFault: Int
    public init(errorFault: UInt16, warningFault: UInt16, bleErrorFault: UInt16) {
        self.dscErrorFault = Int(errorFault)
        self.dscWarningFault = Int(warningFault)
        self.bleErrorFault = Int(bleErrorFault)
    }
     public var dictionaryRepresentation: [String : Int] {
        return [
            BRParameters.Telemetry.FaultInfoData.DSCErrorFault: self.dscErrorFault,
            BRParameters.Telemetry.FaultInfoData.DSCWarningFault: self.dscWarningFault,
            BRParameters.Telemetry.FaultInfoData.BLEErrorFault: self.bleErrorFault
        ]
    }
}

extension ApiFaultInfo: ImmutableMappable {
     public init(map: Map) throws {
        self.dscErrorFault = try map.value(BRResponse.Telemetry.DSCErrorFault)
        self.dscWarningFault = try map.value(BRResponse.Telemetry.DSCWarningFault)
        self.bleErrorFault = try map.value(BRResponse.Telemetry.BLEErrorFault)
    }
}
public struct TelemetryData: CustomStringConvertible {
    public var description: String {
        return """
        ******* TELEMETRY DATA *******
        Total km: \(self.totalKm)
        millisUtcDate: \(self.millisUtcDate)
        batteryCicle: \(String(describing: self.batteryCicle))
        gpsInfo: \(String(describing: self.gpsInfo))
        faults: \(String(describing: self.faults))
        ************************
        """
    }
    
    public let totalKm: Double
    public let millisUtcDate: Int64
    public let batteryCicle: Int?
    public let gpsInfo: ApiGpsInfo?
    public let faults: ApiFaultInfo
    public init(faultInfo: ApiFaultInfo, gpsInfo: ApiGpsInfo?, totalKm: Double, date: Date = Date(), batteryCicle: Int?) {
        self.faults = faultInfo
        self.gpsInfo = gpsInfo
        self.totalKm = totalKm
        self.millisUtcDate = Int64((date.timeIntervalSince1970 * 1000).rounded())
        self.batteryCicle = batteryCicle
    }
}
extension TelemetryData: ImmutableMappable {
     public init(map: Map) throws {
        self.totalKm = try map.value(BRResponse.Telemetry.TotalKm)
        self.millisUtcDate = try map.value(BRResponse.Telemetry.FaultUtcMillis)
        self.faults = try map.value(BRResponse.Telemetry.FaultInfo)
        self.gpsInfo = try? map.value(BRResponse.Telemetry.GpsInfo)
        self.batteryCicle = try? map.value(BRResponse.Telemetry.BatteryCycles)
    }
}
