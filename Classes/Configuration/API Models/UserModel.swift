//
//  UserModel.swift
//  MyBike_API
//
//  Created by Zehus on 31/05/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation

import ObjectMapper

public struct UserModel: ImmutableMappable {
    /*
     @NSManaged public var address: String?
     @NSManaged public var birthdate: Date?
     @NSManaged public var country: String?
     @NSManaged public var createdOn: Date?
     @NSManaged public var editedOn: Date?
     @NSManaged public var email: String?
     @NSManaged public var gender: String?
     @NSManaged public var height: Double
     @NSManaged public var name: String?
     @NSManaged public var phone: String?
     @NSManaged public var surname: String?
     @NSManaged public var weight: Double
     @NSManaged public var vehicle: NSSet?
     */
    public let address: String?
    public let birthdate: Date?
    public let country: String?
    public let creationDate: Date?
    public let updateDate: Date?
    public let email: String?
    public let gender: Gender?
    public let height: Double?
    public let firstName: String?
    public let phone: String?
    public let lastName: String?
    public let weight: Double?
    public let sub: String
    public let roles: [String]?
    public let email_verified: Bool?

    // we did this because we don't have a myBike user model so we rely on API model.
    public init(address: String?,
                birthdate: Date?,
                country: String?,
                creationDate: Date?,
                updateDate: Date?,
                email: String?,
                gender: Gender?,
                height: Double?,
                firstName: String,
                phone: String?,
                lastName: String,
                weight: Double?,
                sub: String,
                roles: [String]?,
                email_verified: Bool?) {
        self.firstName      = firstName
        self.lastName       = lastName
        self.birthdate      = birthdate
        self.gender         = gender
        self.weight         = weight
        self.height         = height
        self.country        = country
        self.creationDate   = creationDate
        self.updateDate     = updateDate
        self.sub            = sub
        self.roles          = roles
        self.email          = email
        self.email_verified = email_verified
        self.phone          = ""
        self.address        = ""
    }
    public init(map: Map) throws {
        self.firstName      = try? map.value(BRResponse.User.firstName) ?? ""
        self.lastName       = try? map.value(BRResponse.User.lastName) ?? ""
        self.birthdate      = try? map.value(BRResponse.User.birthdate, using: DateFormatters.dateTransformMillis)
        if let intGender: Int = try? map.value(BRResponse.User.gender) {
            self.gender = Gender(rawValue: intGender)
        } else {
            self.gender = nil
        }
        
        self.weight         = try? map.value(BRResponse.User.weight)
        self.height         = try? map.value(BRResponse.User.height)
        self.country        = try? map.value(BRResponse.User.country)
        self.creationDate   = try? map.value(BRResponse.User.creationDate, using: DateFormatters.dateTransformMillis)
        self.updateDate     = try? map.value(BRResponse.User.updateDate, using: DateFormatters.dateTransformMillis)
        self.sub            = try map.value(BRResponse.User.sub)
        self.roles          = try? map.value(BRResponse.User.roles, using: GenericFormatters.rolesMapper)
        self.email          = try? map.value(BRResponse.User.email)
        self.email_verified = try? map.value(BRResponse.User.email_verified)
        self.phone          = ""
        self.address        = ""
    }
}
