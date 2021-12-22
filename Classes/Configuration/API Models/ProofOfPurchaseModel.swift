//
//  ProofOfPurchaseModel.swift
//  MyBike_API
//
//  Created by Corso on 10/03/2020.
//  Copyright © 2020 Andrea Finollo. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ProofOfPurchaseModel: ImmutableMappable {
    public let purchaseDate: Date
    public let isImagePresent: Bool
    
    public init(map: Map) throws {
        self.purchaseDate = try map.value(BRResponse.ProofOfPurchase.purchaseDateMillisecs, using: DateFormatters.dateTransformMillis)
        self.isImagePresent = try map.value(BRResponse.ProofOfPurchase.isFilePresent)
    }
}
