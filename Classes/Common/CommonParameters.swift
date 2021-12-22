//
//  CommonParameters.swift
//  MyBike_API
//
//  Created by Zehus on 15/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
struct CommonParameters {
    struct PaginationModel {
        static let data = "Data"
        static let totalPages = "PaginationViewModel.TotalPages"
        static let currentPage = "PaginationViewModel.Page"
        static let rows = "PaginationViewModel.Rows"
        static let queryPage = "page"
        static let queryRows = "rows"
        static let sort = "sort"
    }
    struct Error {
        static let Errors = "Errors"
        static let Error = "Error"
        static let ErrorLowerCase = "error"
        static let ErrorDescriptionLowerCase = "error_description"
        static let ErrorDescription = "ErrorDescription"
        static let Fields = "Fields"
        static let FieldName = "Name"
        static let Value = "Value"
    }
    struct Generic {
        static let ErrorCode = "Error"
        static let ErrorMessage = "Message"
        static let StatusCode = "StatusCode"
        static let Message = "Message"
    }
}
