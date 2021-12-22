//
//  ConstantsDateAndNumberFormatters.swift
//  MyBike_v2_App
//
//  Created by Zehus on 14/02/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import ObjectMapper

struct GenericFormatters {
    static let formatMimeType = TransformOf<MimeType, String>(fromJSON: { (value: String?) -> MimeType? in
        switch value {
        case MimeType.imgPng.rawValue:
            return MimeType.imgPng
        case MimeType.appPdf.rawValue:
            return MimeType.appPdf
        default:
            return nil
        }
    }) { (value: MimeType?) -> String? in
        return value?.rawValue
    }
    static let rolesMapper = TransformOf<[String], Any>(fromJSON: { (value) -> [String]? in
        switch value {
        case is [String]:
            return value as? [String]
        case is String:
            return [value as! String]
        default:
            return nil
        }
    }) { (value) -> Any? in
        return value
    }
}

struct NumberFormatters {
    static func floatToString(_ formatter: NumberFormatter, value: Double) -> String {
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    static var FloatTwoDigitsFormatter: NumberFormatter = {
       let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.decimalSeparator = "."
        return numberFormatter
    }()
}

struct DateFormatters {
    static func formatDateToString(_ formatter: DateFormatter, date: Date?) -> String? {
        if let date = date {
            return formatter.string(from: date)
        } else {
            return nil
        }
    }
    static func formatDateToDate(_ formatter: DateFormatter, date: String?) -> Date? {
        if let date = date {
            return formatter.date(from: date)
        } else {
            return nil
        }
    }
    static let dateTransformMillis = TransformOf<Date, Any>(fromJSON: { (value: Any?) -> Date? in
        var convertedValue: Double?
        if let val = value as? Float {
            print("value \(val)")
        }
        switch value {
        case is Double:
            convertedValue = value as? Double
        case is String:
            convertedValue = Double(value as! String)
        default:
            break
        }
        if let timeInterval = convertedValue {
            return Date(timeIntervalSince1970: TimeInterval(timeInterval) / 1000)
        }
        return nil
    }, toJSON: { (value: Date?) -> Any? in
        return value?.timeIntervalSince1970
    })
    static let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        //TODO: remove force unwrap
        if let date = formatDateToDate(DateFormatters.apiDateFormatterGMT, date: value) {
            return date
        }
        if let date = formatDateToDate(DateFormatters.drunkBackendDateFormatter, date: value) {
            return date
        }
        if let date = formatDateToDate(DateFormatters.extraDrunkBackendDateFormatter, date: value) {
            return date
        }
        return formatDateToDate(DateFormatters.failureMillisBackendFormatter, date: value)
    }, toJSON: { (value: Date?) -> String? in
        return formatDateToString(DateFormatters.apiDateFormatter, date: value)
    })
    static let failureMillisBackendFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.isLenient = false
        //  dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }()
    static let drunkBackendDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.isLenient = false
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }()
    static let extraDrunkBackendDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.isLenient = false
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }()
    /// Format as `MM/dd/yyyy`
    static let facebookBirthdayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    static let googleBirthdayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    /// Format a string 2017-12-21T15:47:033Z into Date
    static let apiDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.isLenient = false
        //  dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }()
    /// Format a string 2017-12-21T15:47:033Z into Date
    static let apiDateFormatterGMT: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.isLenient = false
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }()
    ///
    static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter
    }()
    /// Formatta secondo la stringa `dd-MM-yyyy`. Usata DateToString
    static let advancedSearchDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    /// Formatta secondo la stringa `yyyy-MM-dd`
    static let dateUnderscoreFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    /// Formatta secondo la stringa `HH:mm:ss,SSS`
    static let onlyTimeMillisFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss,SSS"
        return formatter
    }()
    /// Formatta solo il tempo secondo lo stile `3:30` su 24h
    static let onlyTimeNewsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    /// Formatta solo il tempo secondo lo stile `3:30:32` su 24h
    static let onlyTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()
    /// Formatta secondo la stringa `d MMM`
    static let onlyDateNoYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
    /// Formatta solo la data secondo lo stile `November 23, 1937`
    static let onlyDateLongFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    /// Formatta secondo la stringa `dd/MM/yyyy`
    static let onlyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    /// Formatta secondo la stringa "dd/MM/yyyy' 'HH:mm:ss" con time zone Europe/Rome
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Rome")
        formatter.dateFormat = "dd/MM/yyyy' 'HH:mm:ss"
        return formatter
    }()
    /// Formatta secondo la stringa `dd/MM/yyyy` con time zone Europe/Rome
    ///
    static let onlyDateNewsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Rome")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    /// Formatta secondo la stringa `dd/MM` forza il time zone a roma
    static let onlyDateFilterNewsNoYearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Rome")
        formatter.dateFormat = "dd/MM"
        return formatter
    }()
    /// Formatta secondo la stringa `MMM' 'dd', 'yyyy' 'hh:mm:ss' 'a` forza il time zone a roma
    static let dossierPositionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Rome")
        formatter.dateFormat = "MMM' 'dd', 'yyyy' 'hh:mm:ss' 'a"
        formatter.locale = Locale(identifier: "us_US")
        return formatter
    }()
    /// Formatta secondo la stringa `MMM' 'dd', 'yyyy' 'hh:mm:ss' 'a`
    static let orderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    /// Formatta secondo la stringa `HH.mm.ss,SSS` forza il time zone a roma
    static let tradeTimeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Rome")
        formatter.dateFormat = "HH.mm.ss,SSS"
        return formatter
    }()
    /// Formatta secondo la stringa `yyyy.MM.dd HH.mm.ss,SSS` forza il time zone a roma
    static let tradeDateDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Rome")
        formatter.dateFormat = "yyyy.MM.dd HH.mm.ss,SSS"
        return formatter
    }()
    /// Formatta secondo la stringa `yyyyMMdd` forza il time zone a roma
    static let plainDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Rome")
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    /// Formatta secondo la stringa `yyyyMMddyyyyMMddHHmmssSSS` forza il time zone a roma
    static let alertDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Rome")
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        return formatter
    }()
}
