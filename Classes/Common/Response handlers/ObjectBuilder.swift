//
//  ObjectBuilder.swift
//  BikeSharing
//
//  Created by Andrea Finollo on 25/01/18.
//  Copyright © 2018 Zehus. All rights reserved.
//

//TODO: rework dis

import Foundation
import ObjectMapper
import Alamofire

let DataKey = "Data"
let AntitamperKey = "IdentityCheck"

struct EmptyResponse: ImmutableMappable {
    init(map: Map) throws {}
}

enum ObjectResponse<T> {
    case value(T)
    case error(Error)
}

struct ObjectBuilder {
    private static func detectNull(from string: String) -> Bool {
        switch string {
        case "null", "Null", "NULL",
             "<null>", "<Null>", "<NULL>", "{\"Data\":[null]}":
            return true
        default:
            return false
        }
    }
    private static func detectAPIError<T>(from dictionary: [String: Any]) -> ObjectResponse<T>? {
        /*
         {
         "error": "UserNameOrPasswordNotValidKey",
         "error_description": "The user name or password is incorrect."
         }
         */
        if let _ = dictionary[CommonParameters.Error.ErrorLowerCase],
            let error = try? ApplicationServerError(JSON: dictionary) {
            return ObjectResponse<T>.error(error.error)
        }
        //------------------------------------------------------------
        guard let errors = try? Errors(JSON: dictionary), let errorsArray = errors.errors, errorsArray.count > 0 else {
            return nil
        }
        return ObjectResponse<T>.error(Errors.generateApiErrorFrom(errorsArray))
    }
    static func manageResponseError<T>(_ response: DataResponse<Any>) -> ObjectResponse<T>? {
        if let error = response.error {
            if let data = response.data,
                let jsonResp = try? JSONSerialization.jsonObject(with: data, options: []),
                let dict = jsonResp as? [String: Any],
                let err: ObjectResponse<T> = detectAPIError(from: dict) {
                return err
            }
            return ObjectResponse<T>.error(error)
        } else if let data = response.data, let string = String(data: data, encoding: .utf8), detectNull(from: string) {
            return ObjectResponse<T>.error(APIError.nullObject)
        } else if let jsonDict = response.result.value as? [String: Any] {
            if let error = jsonDict[ApiErrorJSONKey] as? String {
                guard let apierror = APIError(key: error) else {
                    return ObjectResponse<T>.error(APIError.generic)
                }
                return ObjectResponse<T>.error(apierror)
            } else if let err: ObjectResponse<T> = detectAPIError(from: jsonDict) {
                return err
            }
        }
        return nil
    }
    static func manageResponseResult<T: ImmutableMappable>(_ resultValue: Any) -> ObjectResponse<T> {
        if let jsonDict = resultValue as? [String: Any] {
            return mapObjectWith(jsonDict)
        }
        if let jsonDictArray = resultValue as? [[String: Any]] {
            // Add a fake key to roll back as a [String : Any]
            var modDict = [String: Any]()
            modDict[DataKey] = jsonDictArray
            return mapObjectWith(modDict)
        }
        return ObjectResponse<T>.error(APIError.generic)
    }
    static func mapObjectWith<T: ImmutableMappable>(_ dictionary: [String: Any]) -> ObjectResponse<T> {
        do {
            let object = try T(JSON: dictionary)
            return ObjectResponse<T>.value(object)
        } catch let error {
            return ObjectResponse<T>.error(error)
        }
    }
    static func buildObject<T: ImmutableMappable>(response: DataResponse<Any>) -> ObjectResponse<T> {
        if let error: ObjectResponse<T> = manageResponseError(response) {
            return error
        } else {
            if let responseValue = response.result.value {
                return  manageResponseResult(responseValue)
            }
            return ObjectResponse<T>.error(APIError.generic)
        }
    }
    /// Method to extract the `ant` value, if not present returns nil
    static func extractAntitamperFromFirst(response: DataResponse<Any>) -> String? {
        if let jsonDict = response.result.value as? [String: Any] {
            let dataDict = jsonDict[DataKey] as? [[String : Any]]
            return dataDict?.first?[AntitamperKey] as? String
        } else {
            return nil
        }
    }
}
