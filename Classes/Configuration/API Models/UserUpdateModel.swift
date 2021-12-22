//
//  UserUpdateModel.swift
//  MyBike_API
//
//  Created by Andrea Finollo on 28/05/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation

public enum Gender: Int {
    case nd = 0
    case male = 1
    case female = 2
    public static let allValues: [Gender] = [.nd, .male, .female]
}

public struct UserUpdateModel {
    
    public let firstName: String?
    public let lastName: String?
    public let birthday: Date?
    public let weight: Double?
    public let gender: Gender?
    public let height: Double?
    public let updateDate = Date()
    
    public init(firstName: String?, lastName: String?, birthday: Date?, weight: Double?, gender: Gender?, height: Double?) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.weight = weight
        self.gender = gender
        self.height = height
    }
}
