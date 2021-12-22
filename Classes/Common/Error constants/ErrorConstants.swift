//
//  ErrorConstants.swift
//  MyBike_v2_App
//
//  Created by Zehus on 13/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
let ApiErrorJSONKey = "error"
let ApiErrorsJSONKey = "Errors"
let ApiNestedErrorJSONKey = "Error"

public protocol ErrorProtocol: LocalizedError, CustomNSError {}
public protocol BackEndError: ErrorProtocol {
    init?(key: String)
}
public enum GenericError: ErrorProtocol {
    
    case emptyModelList
    case notFound
    case applicationFirmwareNotReturnedFromModel
    case couldNotCreateFirmwareDirectory
    public var errorDescription: String? {
        switch self {
        case .emptyModelList:
            return "List returned from the server is empty"
        case .notFound:
            return "The object was not found on the server"
        case .applicationFirmwareNotReturnedFromModel:
            return "Firmware not returned from model"
        case .couldNotCreateFirmwareDirectory:
            return "Not possible to create the firmware directory"
        }
    }
    public static let errorDomain = "it.mybike.generic_error"
    
    
    public var errorCode: Int {
        let code = 1000
        switch self {
       case .emptyModelList:
            return code + 1
        case .notFound:
            return code + 2
        case .applicationFirmwareNotReturnedFromModel:
            return code + 3
        case .couldNotCreateFirmwareDirectory:
            return code + 4
        }
    }
}
