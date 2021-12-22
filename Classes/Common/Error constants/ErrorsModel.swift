//
//  ErrorsModel.swift
//  BikeSharing
//
//  Created by Andrea Finollo on 07/03/18.
//  Copyright © 2018 Zehus. All rights reserved.
//

import Foundation
import ObjectMapper

struct Errors {
    let errors: [ApplicationServerError]?
    static func generateApiErrorFrom(_ errors: [ApplicationServerError] ) -> BackEndError {
        switch errors.count {
        case 1:
            return errors.first!.error
        case 2...:
            return APIError.multiple
        default:
            return APIError.generic
        }
    }
}

extension Errors: ImmutableMappable {
    init(map: Map) throws {
        self.errors = try? map.value(CommonParameters.Error.Errors)
    }
}

struct ApplicationServerError {
    let key: String
    let description: String?
    let fields: [ApplicationServerErrorField]?
    var error: BackEndError {
        if let error = APIError(key: key) {
            return error
        }
        return APIError.generic
    }
}

extension ApplicationServerError: ImmutableMappable {
    init(map: Map) throws {
        self.key = (try? map.value(CommonParameters.Error.Error)) ?? (try! map.value(CommonParameters.Error.ErrorLowerCase))
        self.description = try? map.value(CommonParameters.Error.ErrorDescription) ?? ""
        self.fields = try? map.value(CommonParameters.Error.Fields)
    }
}

struct ApplicationServerErrorField {
    let name: String?
    let value: [String]?
}

extension ApplicationServerErrorField: ImmutableMappable {
    init(map: Map) throws {
        self.name = try? map.value(CommonParameters.Error.FieldName)
        self.value = try? map.value(CommonParameters.Error.Value)
    }
}
