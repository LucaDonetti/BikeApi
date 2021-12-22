//
//  RemoteControllerModel.swift
//  MyBike_API
//
//  Created by Zehus on 18/10/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import ObjectMapper

/*{
  "VehicleId": "string",
  "DeviceUniqueName": "string",
  "FirmwareRevision": "string",
  "HardwareRevision": "string",
  "ManufacturerName": "string"
}*/
public struct RemoteControllerAPIModel {
    public let deviceUniqueName: String
    public let firmwareRevision: String
    public let hardwareRevision: String
    public let manufacturerName: String
    
    public init(deviceUniqueName: String,
                firmwareRevision: String,
                hardwareRevision: String,
                manufacturerName: String) {
        self.deviceUniqueName = deviceUniqueName
        self.firmwareRevision = firmwareRevision
        self.hardwareRevision = hardwareRevision
        self.manufacturerName = manufacturerName
    }
}
extension RemoteControllerAPIModel: ImmutableMappable {
    public init(map: Map) throws {
        self.deviceUniqueName = try map.value(BRParameters.RemoteControllerModel.deviceUniqueName)
        self.firmwareRevision = try map.value(BRParameters.RemoteControllerModel.firmwareRevision)
        self.hardwareRevision = try map.value(BRParameters.RemoteControllerModel.hardwareRevision)
        self.manufacturerName = try map.value(BRParameters.RemoteControllerModel.manufacturerName)
    }
}
