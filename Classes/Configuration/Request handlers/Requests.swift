//
//  Requests.swift
//  MyBike_API
//
//  Created by Zehus on 31/05/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation

extension AppHttpClient {
    func getUserInfo(success: @escaping (UserModel) -> Void,
                       failure: @escaping (Error) -> Void) {
        router.request(.getUserProfile) { (response: Result<UserModel, Error>) in
                switch response {
                case .success(let user):
                    success(user)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    func updateUser(userModel: UserUpdateModel,
                    success: @escaping () -> Void,
                    failure: @escaping (Error) -> Void) {
        router.request(.updateUser(userModel: userModel)) { (response: Result<EmptyResponse, Error>) in
                switch response {
                case .success:
                    success()
                case .failure(let error):
                    failure(error)
                }
        }
    }
    func updateVehicleName(`for` vehicleId: String, newName: String,
                           success: @escaping () -> Void,
                           failure: @escaping (Error) -> Void) {
        router.request(.updateBikeName(vehicleId: vehicleId, newName: newName)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
    func uploadProofOfPurchase(`for` vehicleId: String,
                               dateOfPurchase: Int64,
                               picture: String?,
                               success: @escaping () -> Void,
                               failure: @escaping (Error) -> Void) {
        router.request(.uploadProofOfPurchase(vehicleId: vehicleId, purchaseDateMillisecs: dateOfPurchase, fileContent: picture)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
    func uploadRemoteProofOfPurchase(`for` remoteId: String,
                                            dateOfPurchase: Int64,
                                            picture: String?,
                                            success: @escaping () -> Void,
                                            failure: @escaping (Error) -> Void) {
        router.request(.uploadRemoteProofOfPurchase(remoteId: remoteId, purchaseDateMillisecs: dateOfPurchase, fileContent: picture)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
    func getProofOfPurchase(`for` vehicleId: String,
                            success: @escaping (ProofOfPurchaseModel) -> Void,
                            failure: @escaping (Error) -> Void) {
        router.request(.getProofOfPurchase(vehicleId: vehicleId)) { (response: Result<PagelessResponse<ProofOfPurchaseModel>, Error>) in
            switch response {
            case .success(let proofOfPurchase):
                guard let pop = proofOfPurchase.first else {
                    failure(APIError.firmwareProductTypeNotFoundException)
                    break
                }
                success(pop)
            case .failure(let error):
                failure(error)
            }
        }
    }
    func getRemoteProofOfPurchase(`for` remoteId: String,
                                         success: @escaping (ProofOfPurchaseModel) -> Void,
                                         failure: @escaping (Error) -> Void) {
        router.request(.getRemoteProofOfPurchase(remoteId:  remoteId)) { (response: Result<PagelessResponse<ProofOfPurchaseModel>, Error>) in
            switch response {
            case .success(let proofOfPurchase):
                guard let first = proofOfPurchase.first else {
                    failure(GenericError.notFound)
                    break
                }
                success(first)
            case .failure(let error):
                failure(error)
            }
        }
     }
    func sendTelemetry(`for` hubId: String, telemetryData: TelemetryData,
                       success: @escaping () -> Void,
                       failure: @escaping (Error) -> Void) {
        router.request(.putTotalKmAndFaults(telemetryData: telemetryData, hubId: hubId)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
    func sendTelemetryList(`for` hubId: String, telemetryData: [TelemetryData],
                           success: @escaping () -> Void,
                           failure: @escaping (Error) -> Void) {
        router.request(.putTotalKmAndFaultsList(telemetryData: telemetryData, hubId: hubId)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
     func getUserVehicleList(page: Int = 1, rows: Int = 100,
                                   success: @escaping ([VehicleAPIModel]) -> Void,
                                   failure: @escaping (Error) -> Void) {
        router.request(.getUserVehicleList(page: page, rows: rows)) { (response: Result<PaginationModel<VehicleAPIModel>, Error>) in
            switch response {
            case .success(let value):
                success(value.data)
            case .failure(let error):
                failure(error)
            }
        }
    }

    func getUserVehicleLiteList(page: Int = 1, rows: Int = 100,
                                  success: @escaping ([VehicleLiteAPIModel]) -> Void,
                                  failure: @escaping (Error) -> Void) {
       router.request(.getUserVehicleLiteList(page: page, rows: rows)) { (response: Result<PaginationModel<VehicleLiteAPIModel>, Error>) in
           switch response {
           case .success(let value):
               success(value.data)
           case .failure(let error):
               failure(error)
           }
       }
   }

     func getVehicleBySN(_ serialNumber: String,
                               success: @escaping (VehicleAPIModel) -> Void,
                               failure: @escaping (Error) -> Void) {
        router.request(.getVehicleBySN(serialNumber: serialNumber)) {(response: Result<PagelessResponse<VehicleAPIModel>, Error>) in
            switch response {
            case .success(let value):
//                    let first = value.first!
//                    let antitamper = self.antitamper(serial: first.serialNumber, rr: first.eol.rearRing, fr: first.eol.frontRing, wl: first.eol.wheelLenght)
//                    if let orig = ObjectBuilder.extractAntitamperFromFirst(response: response), antitamper == orig {
                        success(value.first!)
//                    } else {
//                        failure(APIError.antitamperActivated)
//                    }
            case .failure(let error):
                    failure(error)
                }
        }
    }

    func createUserVehicleAssociation(associationModel: AssociationUserVehicleModel,
                               success: @escaping () -> Void,
                               failure: @escaping (Error) -> Void) {
        router.request(.createUserVehicleAssociation(associationModel: associationModel)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }

    }
   
     func createRemoteVehicleAssociation(vehicleId: UUID, remoteModel: RemoteControllerAPIModel,
                                               success: @escaping () -> Void,
                                               failure: @escaping (Error) -> Void) {
        router.request(.postRemoteController(vehicleId: vehicleId.uuidString, remoteModel: remoteModel)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
   
     func deleteRemoteFromVehicle(vehicleId: UUID, remoteName: String,
                                        success: @escaping () -> Void,
                                        failure: @escaping (Error) -> Void) {
        router.request(.deleteRemoteFromVehicle(vehicleId: vehicleId.uuidString, remoteName: remoteName)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }

     func deleteUserVehicleAssociation(vehicleId: UUID,
                                             success: @escaping () -> Void,
                                             failure: @escaping (Error) -> Void) {
        router.request(.deleteVehicleAssociation(vehicleId: vehicleId.uuidString)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }

     func getFirmware(firmwareTypeId: String,
                            success: @escaping (FirmwareModel) -> Void,
                            failure: @escaping (Error) -> Void) {
        router.request(.getFirmware(firmwareTypeId: firmwareTypeId)) { (response: Result<PagelessResponse<FirmwareModel>, Error>) in
            switch response {
            case .success(let value):
                if let val = value.responseArray.first {
                    success(val)
                } else {
                    failure(GenericError.notFound)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

     func getLastFirmwareVersion(firmwareProductId: String,
                                       success: @escaping (FirmwareProductTypeModel) -> Void,
                                       failure: @escaping (Error) -> Void) {
        router.request(.getLastFirmwareVersion(firmwareProductId: firmwareProductId)) { (response: Result<PagelessResponse<FirmwareProductTypeModel>, Error>) in
            switch response {
            case .success(let value):
                if let val = value.responseArray.first {
                    success(val)
                } else {
                    failure(GenericError.notFound)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
   
    func getFirmwareProductList(page: Int, rows: Int, success: @escaping ([FirmwareProductTypeModel]) -> Void,
                                       failure: @escaping (Error) -> Void) {
        router.request(.getFirmwareProductTypesList(page: page, rows: rows)) { (response: Result<PaginationModel<FirmwareProductTypeModel>, Error>) in
            switch response {
            case .success(let val):
                success(val.data)
            case .failure(let error):
                failure(error)
            }
        }
    }

     func getTelemetryList(for hubId: String, page: Int = 1, rows: Int = 100,
                                   success: @escaping ([TelemetryData]) -> Void,
                                   failure: @escaping (Error) -> Void) {
        router.request(.getTelemetryList(hubId: hubId, page: page, rows: rows)) { (response: Result<PaginationModel<TelemetryData>, Error>) in
            switch response {
            case .success(let value):
                    success(value.data)
            case .failure(let error):
                failure(error)
            }
        }
    }

     func getLastFault(for hubId: String,
                             success: @escaping (TelemetryData) -> Void,
                             failure: @escaping (Error) -> Void) {
        router.request(.getLastFault(hubId: hubId)) { (response: Result<PagelessResponse<TelemetryData>, Error>) in
            switch response {
            case .success(let value):
                if let val = value.responseArray.first {
                    success(val)
                } else {
                    failure(GenericError.notFound)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

     func updateApplicationFirmwares(driverId: String, firmwareProductTypeId: String,
                                     bleFirmware: FirmwareVersion?,
                                     dscFirmware: FirmwareVersion?,
                                     bmsFirmware: FirmwareVersion? = nil,
                                     success: @escaping ()-> Void,
                                     failure: @escaping (Error) -> Void) {
        router.request(.updateApplicationFirmwares(driverId: driverId, fwProductTypeId: firmwareProductTypeId, bleVersion: bleFirmware, dscVersion:  dscFirmware, bmsVersion: bmsFirmware)) { (response: Result<EmptyResponse, Error>) in
            switch response {
            case .success:
                    success()
            case .failure(let error):
                failure(error)
            }
        }
    }

    func sendVehicleReport(model: SendReportAPIModel,
                           success: @escaping ()-> Void,
                           failure: @escaping (Error) -> Void){
        router.request(.sendReport(model: model)) { (response: Result<EmptyResponse, Error>) in
                switch response {
                case .success:
                    success()
                case .failure(let error):
                    failure(error)
                }
        }
    }
}
