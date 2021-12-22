//
//  PaginationModel.swift
//  MyBike_v2_App
//
//  Created by Zehus on 13/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import ObjectMapper

struct PaginationModel<T: ImmutableMappable> {
    let data: [T]
    let totalPages: Int?
    let currentPage: Int
    let rows: Int
}

extension PaginationModel: ImmutableMappable {
    //    {
    //        "PaginationViewModel": {
    //            "Rows": 100,
    //            "Page": 1,
    //            "Sort": null
    //        },
    //        "TotalPages": 0,
    //        "Data": []
    //    }
    init(map: Map) throws {
        print("map of pagination model \(map.JSON)")
        data = try map.value(CommonParameters.PaginationModel.data)
        totalPages = try? map.value(CommonParameters.PaginationModel.totalPages)
        currentPage = try map.value(CommonParameters.PaginationModel.currentPage)
        rows = try map.value(CommonParameters.PaginationModel.rows)
    }
}

struct PagelessResponse<T: ImmutableMappable> {
    let responseArray: [T]
}

extension PagelessResponse: ImmutableMappable {
    init(map: Map) throws {
        self.responseArray = try map.value(DataKey)
    }
}

extension PagelessResponse: Collection {
    var startIndex: Int {
        return responseArray.startIndex
    }
    var endIndex: Int {
        return responseArray.endIndex
    }
    func index(after index: Int) -> Int {
        return responseArray.index(after: index)
    }
    subscript(position: Int) -> T {
        return responseArray[position]
    }
}
