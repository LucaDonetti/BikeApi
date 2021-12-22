//
//  EnumRouter.swift
//  MyBike_API
//
//  Created by Andrea Finollo on 27/05/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import Alamofire

enum Router {
    
    // MARK: GENERIC
    case getUserProfile
    case updateUser(userModel: UserUpdateModel)
    case getUserVehicleList(page: Int, rows: Int)
    case getUserVehicleLiteList(page: Int, rows: Int)
    case getVehicleBySN(serialNumber: String)
    case createUserVehicleAssociation(associationModel: AssociationUserVehicleModel)
    case deleteVehicleAssociation(vehicleId: String)
    case updateBikeName(vehicleId: String, newName: String)
    case uploadProofOfPurchase(vehicleId: String, purchaseDateMillisecs : Int64, fileContent: String?)
    case getProofOfPurchase(vehicleId: String)
    // MARK:  REMOTE
    case postRemoteController(vehicleId: String, remoteModel: RemoteControllerAPIModel)
    case deleteRemoteFromVehicle(vehicleId: String, remoteName: String)
    case uploadRemoteProofOfPurchase(remoteId: String, purchaseDateMillisecs: Int64, fileContent: String?)
    case getRemoteProofOfPurchase(remoteId: String)
    // MARK:  FIRMWARE
    case getFirmwareProductTypesList(page: Int, rows: Int)
    case getFirmware(firmwareTypeId: String)
    case getLastFirmwareVersion(firmwareProductId: String)
    case updateApplicationFirmwares(driverId: String, fwProductTypeId: String, bleVersion: FirmwareVersion?, dscVersion: FirmwareVersion?, bmsVersion: FirmwareVersion?)
    // MARK:  TELEMETRY
    case putTotalKmAndFaults(telemetryData: TelemetryData, hubId: String)
    case putTotalKmAndFaultsList(telemetryData: [TelemetryData], hubId: String)
    case getTelemetryList(hubId: String, page: Int, rows: Int)
    
    case getLastFault(hubId: String)
    case sendReport(model: SendReportAPIModel)

    func encoding(request: URLRequest, parameters: [String: Any]?) throws ->  URLRequest {
        switch self {
        case .createUserVehicleAssociation,
             .updateUser,
             .updateBikeName,
             .putTotalKmAndFaults,
             .putTotalKmAndFaultsList,
             .postRemoteController,
             .sendReport,
             .uploadProofOfPurchase,
             .uploadRemoteProofOfPurchase,
             .updateApplicationFirmwares:
            return try JSONEncoding(options: []).encode(request, with: parameters)
        default:
            return try URLEncoding(destination: .httpBody).encode(request, with: parameters)
        }
    }
//    var baseURL: URL {
//        switch self {
//        case .getUserProfile:
//            return try! Router.indentityURLString.asURL()
//        default:
//            return try! Router.bitrideURLString.asURL()
//        }
//    }
    var method: HTTPMethod {
        switch self {
        case  .createUserVehicleAssociation, .postRemoteController, .sendReport:
            return .post
        case .updateUser, .updateBikeName, .putTotalKmAndFaults, .putTotalKmAndFaultsList, .uploadProofOfPurchase, .uploadRemoteProofOfPurchase, .updateApplicationFirmwares:
            return .put
        case .deleteVehicleAssociation,
             .deleteRemoteFromVehicle:
            return .delete
        default:
            return .get
        }
    }
    var path: String {
        switch self {
        case .getUserProfile:
            return BRPath.GetUserProfile
        case .updateUser(_):
            return BRPath.UpdateUserProfile
        case .updateBikeName(let vehicleId, _):
            return BRPath.UpdateBikeName
                .replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: vehicleId)
        case .getUserVehicleList(let page, let rows):
            return BRPath.GetVehicleForUser
            .replacingOccurrences(of: BRParameters.Placeholder.RowPh, with: String(rows))
            .replacingOccurrences(of: BRParameters.Placeholder.PagePh, with: String(page))
        case .getUserVehicleLiteList(page: let page, rows: let rows):
            return BRPath.GetVehicleLiteForUser
            .replacingOccurrences(of: BRParameters.Placeholder.RowPh, with: String(rows))
            .replacingOccurrences(of: BRParameters.Placeholder.PagePh, with: String(page))
        case .getVehicleBySN(let serialNumber):
            return BRPath.GetVehicle
                .replacingOccurrences(of: BRParameters.Placeholder.VehicleSerialPh, with: serialNumber)
        case .createUserVehicleAssociation(_):
            return BRPath.CreateUserVehicleAssociation
        case .getLastFirmwareVersion(let firmwareProductId):
            return BRPath.GetLastFirmwareProductType.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: firmwareProductId)
        case .getFirmwareProductTypesList(_, _):
            return BRPath.GetAllFirmwareProductTypes
        case .getFirmware(let firmwareTypeId):
            return BRPath.GetFirmware.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: firmwareTypeId)
        case .updateApplicationFirmwares(let driverId, _, _, _, _):
            return BRPath.FirmwareUpdate.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: driverId)
        case .deleteVehicleAssociation(let vehicleId):
            return BRPath.DeleteUserVehicleAssociation.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: vehicleId)
        case .putTotalKmAndFaults(_, let hubId):
            return BRPath.PutTelemetryData.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: hubId)
        case .putTotalKmAndFaultsList(_ , let hubId):
            return BRPath.PutTelemetryData.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: hubId)
        case .getTelemetryList(let hubId, let page, let rows):
            return BRPath.GetFaultList
                .replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: hubId)
                .replacingOccurrences(of: BRParameters.Placeholder.RowPh, with: String(rows))
                .replacingOccurrences(of: BRParameters.Placeholder.PagePh, with: String(page))
        case .getLastFault(let hubId):
            return BRPath.GetLastFault.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: hubId)
        case .postRemoteController(_, _):
            return BRPath.PostRemoteController
        case .deleteRemoteFromVehicle(_, _):
            return BRPath.DeleteRemoteFromVehicle
        case .uploadProofOfPurchase(_, _, _):
            return BRPath.UploadProofOfPurchase
        case .uploadRemoteProofOfPurchase(_, _, _):
            return BRPath.UploadRemoteProofOfPurchase
        case .getProofOfPurchase(let vehicleId):
            return BRPath.GetProofOfPurchase.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: vehicleId)
        case .getRemoteProofOfPurchase(let remoteId):
            return BRPath.GetRemoteProofOfPurchase.replacingOccurrences(of: BRParameters.Placeholder.IdPh, with: remoteId)
        case .sendReport(_):
            return BRPath.SendReport
        }
    }
    var parameters: [String: Any]? {
            switch self {
            case .getUserProfile:
                return nil
            case .getVehicleBySN(_):
                return nil
            case .getUserVehicleList(_, _):
                return nil
            case .getUserVehicleLiteList(_, _):
                    return nil
            case .deleteVehicleAssociation:
                return nil
            case .deleteRemoteFromVehicle:
                return nil
            case .updateUser(let userModel):
                var bdayMillis: Double? = nil
                if let bday = userModel.birthday {
                    bdayMillis = bday.timeIntervalSince1970 * 1000.0
                }
                let params = ([
                    BRParameters.User.FirstName: userModel.firstName,
                    BRParameters.User.LastName: userModel.lastName,
                    BRParameters.User.Birthday: bdayMillis,
                    BRParameters.User.Weight: userModel.weight,
                    BRParameters.User.Height: userModel.height,
                    BRParameters.User.Gender: userModel.gender?.rawValue
                    ] as [String: Any?]).filterNil()
                return params
            case .createUserVehicleAssociation(let associationModel):
                let params = [
                    BRParameters.AssociateVehicle.HubSerialNumber: associationModel.hubSerialNumber,
                    BRParameters.AssociateVehicle.VehicleName: associationModel.vehicleName,
                    BRParameters.AssociateVehicle.UserLanguage: associationModel.userLanguage
                ]
                return params
            case.updateBikeName(_ , let newName):
                let params = ([BRParameters.AssociateVehicle.VehicleName : newName] as [String: Any?]).filterNil()
                return params
            case .getFirmwareProductTypesList(let page, let rows):
                let params = ([
                    CommonParameters.PaginationModel.queryPage: page,
                    CommonParameters.PaginationModel.queryRows: rows,
                    BRParameters.Firmware.FirmwareProdutTypology: 3,
                    BRParameters.Firmware.UpdateChannelType: 3
                    ] as [String: Any?]).filterNil()
                return params
            case .getFirmware(_):
                return nil
            case .getLastFirmwareVersion(_):
                return nil
            case .getLastFault(_):
                return nil
            case .updateApplicationFirmwares(_ , let fwProductTypeId, let bleVersion, let dscVersion,  let bmsVersion):
                let params = ([
                    BRParameters.Driver.DriverDscApplicationFirmwareVersion: dscVersion?.dictionaryRepresentation,
                    BRParameters.Driver.DriverBleApplicationFirmwareVersion: bleVersion?.dictionaryRepresentation,
                    BRParameters.Driver.DriverBmsApplicationFirmwareVersion: bmsVersion?.dictionaryRepresentation,
                    BRParameters.Driver.FirmwareProductTypeId: fwProductTypeId
                    ] as [String: Any?]).filterNil()
                print("fwupdateInfoparams \(params)")
                return params
            case .putTotalKmAndFaults(let telemetryData, _):
                print("telemetryData : \(telemetryData)")
                let params = ([
                    BRParameters.Telemetry.GpsInfo: telemetryData.gpsInfo?.dictionaryRepresentation,
                    BRParameters.Telemetry.FaultInfo: telemetryData.faults.dictionaryRepresentation,
                    BRParameters.Telemetry.TotalKm: telemetryData.totalKm,
                    BRParameters.Telemetry.MillisUtcDate: telemetryData.millisUtcDate,
                    BRParameters.Telemetry.BatteryCycles: telemetryData.batteryCicle
                    ] as [String : Any?]).filterNil()
                print("params to send \(params)")
                return [BRParameters.Placeholder.Data: [params]]
            case .putTotalKmAndFaultsList(let telemetryDataList, _):
                print("telemetryData : \(telemetryDataList)")
                var list = [[String : Any]]()
                telemetryDataList.forEach { (telemetryData) in
                    list.append(([
                        BRParameters.Telemetry.GpsInfo: telemetryData.gpsInfo?.dictionaryRepresentation,
                        BRParameters.Telemetry.FaultInfo: telemetryData.faults.dictionaryRepresentation,
                        BRParameters.Telemetry.TotalKm: telemetryData.totalKm,
                        BRParameters.Telemetry.MillisUtcDate: telemetryData.millisUtcDate
                        ] as [String : Any?]).filterNil())
                }
                print("params to send \(list)")
                return [BRParameters.Placeholder.Data: list]
            case .getTelemetryList(_, _, _):
                return [BRParameters.PaginationModel.sort: "-FaultUtcMillis"]
            case .postRemoteController(let vehicleId, let remoteModel):
                let params = [
                    BRParameters.RemoteControllerModel.vehicleId: vehicleId,
                    BRParameters.RemoteControllerModel.deviceUniqueName: remoteModel.deviceUniqueName,
                    BRParameters.RemoteControllerModel.firmwareRevision:remoteModel.firmwareRevision,
                    BRParameters.RemoteControllerModel.hardwareRevision:remoteModel.hardwareRevision,
                    BRParameters.RemoteControllerModel.manufacturerName:remoteModel.manufacturerName
                ]
                return params
            case .sendReport(let model):
                let params = [
                    BRParameters.VehicleReport.VehicleId: model.vehicleId,
                    BRParameters.VehicleReport.HubId: model.hubId,
                    BRParameters.VehicleReport.HubSerialNumber: model.hubSerialNumber,
                    BRParameters.VehicleReport.diagnosticReportType: model.diagnosticReportType.rawValue,
                    BRParameters.VehicleReport.Report: model.report
                ] as [String : Any]
                return params
            case .uploadProofOfPurchase(let vehicleId, let purchaseDateMillisecs, let fileContent):
                let params = ([
                    BRParameters.ProofOfPurchaseModel.vehicleId: vehicleId,
                    BRParameters.ProofOfPurchaseModel.purchaseDateMillisecs: purchaseDateMillisecs,
                    BRParameters.ProofOfPurchaseModel.fileContent: fileContent
                    ] as [String : Any?]).filterNil()
                return params
            case .uploadRemoteProofOfPurchase(let remoteId, let purchaseDateMillisecs, let fileContent):
                let params = ([
                    BRParameters.RemoteProofOfPurchaseModel.remoteId: remoteId,
                    BRParameters.RemoteProofOfPurchaseModel.purchaseDateMillisecs: purchaseDateMillisecs,
                    BRParameters.RemoteProofOfPurchaseModel.fileContent: fileContent
                    ] as [String : Any?]).filterNil()
                return params
            case .getProofOfPurchase(_):
                return nil
            case .getRemoteProofOfPurchase(_):
                return nil
        }
        }/*()
        let url = baseURL
        let versionedURL = url.appendingPathComponent(path.replacingOccurrences(of: BRParameters.Placeholder.VersionPh,
                                                                                with: NetworkConfig.apiVersion))
        var request = URLRequest(url: versionedURL)
        request.httpMethod = method.rawValue
        print("DEBUG REQUEST : \(request)")
        switch method {
        case .get:
            return try URLEncoding(destination: .queryString).encode(request, with: parameters)
        case .post, .put:
            return try encoding(request: request, parameters: parameters)
       /* case .put:
            return URLEncoding(destination: .httpBody).encode(request, with: parameters)*/
        case .delete:
            return request
        }
    }*/
}
