//
//  Helper.swift
//  MyBike_API
//
//  Created by Andrea Finollo on 25/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation

protocol OptionalType {
    associatedtype Wrapped
    func intoOptional() -> Wrapped?
}

extension Optional : OptionalType {
    func intoOptional() -> Wrapped? {
        return self
    }
}

extension Dictionary where Value: OptionalType {
    func filterNil() -> [Key: Value.Wrapped] {
        var result: [Key: Value.Wrapped] = [:]
        for (key, value) in self {
            if let unwrappedValue = value.intoOptional() {
                result[key] = unwrappedValue
            }
        }
        return result
    }
}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
                                                                return nil
        }
        
        return String(data: theJSONData, encoding: .ascii)
    }
}

/*
- Zehus hub serial numbers have this format: 20116559 check the following documents for more details
    http://confluence.eldor.it/download/attachments/36838814/SerialNumberFormat_v1p0.pdf?api=v2
    This is how the app handles this serial number:
 - Cloud requires Zehus Sap Prefix (90) and will return the hub serial number with this prefix.
 - The hub ble name is written with Zehus Prefix (z:) (warning! it's case sensitive!)
 - On the iPhone database it is stored with the cloud format (90xxxxxxxx)
 
*/
extension String {
    
    enum SapConstant {
        static let ZehusPrefix = "z:"
        static let ZehusSapPrefix = "90"
    }
    var hasZehusPrefix: Bool {
        return hasPrefix(SapConstant.ZehusPrefix)
    }
    var hasSapPrefix: Bool {
        return hasPrefix(SapConstant.ZehusSapPrefix)
    }
    func removeZehusPrefix() -> String {
        if !hasZehusPrefix { return self }
        return String(dropFirst(SapConstant.ZehusPrefix.count))
    }
    func removeZehusSap() -> String {
        // if there is a zehus prefix z: remove it
        let oldString = self.removeZehusPrefix()
        // (the old type of serial had letters inside. Don't worry, it's no longer used.)
        // check whether it's a new type of serial (with 90 prefix) (no letters allowed)
        if CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: oldString)), oldString.hasSapPrefix {
            // then return if the resulting string has sap prefix (for instance 9020116559)
            return String(oldString.dropFirst(SapConstant.ZehusSapPrefix.count))
        } else {
            return self
        }
    }
    // if you want to make it more uniform, just follow the logic usied in addZehusSap
    func addZehusPrefix() -> String {
        if hasZehusPrefix { return self }
        return SapConstant.ZehusPrefix + self
    }
    func addZehusSap() -> String {
        let oldString = self.removeZehusPrefix()
        guard !self.hasSapPrefix else {
            return oldString
        }
        if CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: oldString)) {
            return SapConstant.ZehusSapPrefix + oldString
        } else {
            return oldString
        }
    }
}
