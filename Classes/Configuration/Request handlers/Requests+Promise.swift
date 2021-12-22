//
//  Requests+Promise.swift
//  MyBike_API
//
//  Created by Zehus on 31/05/2019.
//  Copyright © 2019 Andrea Finollo. All rights reserved.
//

import Foundation
import PromiseKit

public extension AppHttpClient {
     func promise_getuserInfo() -> Promise<UserModel> {
        return Promise<UserModel> { seal in
            getUserInfo(success: { userInfo in
                seal.fulfill(userInfo)
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_updateUser(userModel: UserUpdateModel) -> Promise<Void> {
        return Promise<Void> { seal in
            updateUser(userModel: userModel, success: {
                seal.fulfill(())
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_updateVehicleName(for vehicleId: String, newName: String) -> Promise<Void> {
        return Promise<Void> { seal in
            updateVehicleName(for: vehicleId, newName: newName, success: {
                seal.fulfill(())
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_sendTelemetry(`for` hubId: String, telemetryData: TelemetryData) -> Promise<Void> {
        return Promise<Void> { seal in
            seal.fulfill_()
            sendTelemetry( for: hubId, telemetryData: telemetryData, success: {
                seal.fulfill(())
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_sendTelemetryList(`for` hubId: String, telemetryDataList: [TelemetryData]) -> Promise<Void> {
        return Promise<Void> { seal in
            seal.fulfill_()
            sendTelemetryList( for: hubId, telemetryData: telemetryDataList, success: {
                seal.fulfill(())
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_getTelemetryList(for hubId: String, page: Int, row: Int) -> Promise<[TelemetryData]> {
        return Promise<[TelemetryData]> { seal in
            getTelemetryList(for: hubId, page: page, rows: row, success: { telemetryData in
                seal.fulfill(telemetryData)
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_getLastFault(for hubId: String) -> Promise<TelemetryData> {
        return Promise { seal in
            getLastFault(for: hubId, success: { telemetryData in
                seal.fulfill(telemetryData)
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_getUserVehicleList() -> Promise<[VehicleAPIModel]> {
        return Promise<[VehicleAPIModel]> { seal in
            getUserVehicleList(success: { vehicles in
                seal.fulfill(vehicles)
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
    func promise_getUserVehicleListLite() -> Promise<[VehicleLiteAPIModel]> {
        return Promise<[VehicleLiteAPIModel]> { seal in
            getUserVehicleLiteList(success: { vehicles in
                seal.fulfill(vehicles)
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
    func promise_getVehicleBySN(_ serial: String) -> Promise<VehicleAPIModel> {
        return Promise<VehicleAPIModel> { seal in
            getVehicleBySN(serial, success: { vehicle in
                seal.fulfill(vehicle)
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_createUserVehicleAssociation(hubSerialNumber: String, vehicleName: String, userLanguage: String) -> Promise<Void> {
        return Promise<Void> { seal in
            let model = AssociationUserVehicleModel(hubSerialNumber: hubSerialNumber, vehicleName: vehicleName, userLanguage: userLanguage)
            createUserVehicleAssociation(associationModel: model, success: {
                seal.fulfill(())
            }, failure: { error in
                seal.reject(error)
            })
        }
    }
     func promise_deleteUserVehicleAssociation(vehicleId: UUID) -> Promise<Void> {
        return Promise<Void> { seal in
            deleteUserVehicleAssociation(vehicleId: vehicleId, success: {
                seal.fulfill(())
            }) { error in
                seal.reject(error)
            }
        }
    }
     func promise_createRemoteVehicleAssociation(vehicleId: UUID, remoteModel: RemoteControllerAPIModel) -> Promise<Void> {
        return Promise<Void> { seal in
            createRemoteVehicleAssociation(vehicleId: vehicleId, remoteModel: remoteModel, success: {
                seal.fulfill(())
            }) { error in
                seal.reject(error)
            }
        }
    }
     func promise_deleteRemoteFromVehicle(vehicleId: UUID, remoteName: String) -> Promise<Void> {
        return Promise<Void> { seal in
            deleteRemoteFromVehicle(vehicleId: vehicleId, remoteName: remoteName, success: {
                seal.fulfill(())
            }) { error in
                seal.reject(error)
            }
        }
    }
     func promise_uploadProofOfPurchase(vehicleid: String,
                                              dateOfPurchase: Date,
                                              imageString: String?) -> Promise<Void> {
        return Promise<Void> { seal in
            let dop = Int64((dateOfPurchase.timeIntervalSince1970 * 1000).rounded())
            uploadProofOfPurchase(for: vehicleid,
                                  dateOfPurchase: dop,
                                  picture: imageString, success: {
                seal.fulfill(())
            }) { error in
                seal.reject(error)
            }
        }
    }
     func promise_uploadRemoteProofOfPurchase(remoteId: String,
                                                    dateOfPurchase: Date,
                                                    imageString: String?) -> Promise<Void> {
        return Promise<Void> { seal in
            let dop = Int64((dateOfPurchase.timeIntervalSince1970 * 1000).rounded())
            uploadRemoteProofOfPurchase(for: remoteId,
                                        dateOfPurchase: dop,
                                        picture: imageString, success: {
                                            seal.fulfill(())
            }) { error in
                seal.reject(error)
            }
        }
    }
     func promise_getProofOfPurchase(vehicleId: String) -> Promise<ProofOfPurchaseModel> {
        return Promise { seal in
            getProofOfPurchase(for: vehicleId, success: { pop in
                seal.fulfill(pop)
            }) { error in
                seal.reject(error)
            }
        }
    }
     func promise_getRemoteProofOfPurchase(remoteeId: String) -> Promise<ProofOfPurchaseModel> {
        return Promise { seal in
            getRemoteProofOfPurchase(for: remoteeId, success: { pop in
                seal.fulfill(pop)
            }) { error in
                seal.reject(error)
            }
        }
    }
}

// MARK: Firmware
public extension AppHttpClient {
    
    private  func saveFirmwareInCacheDirectory(withName name: String, with data: Data) throws {
        guard let storageURL = firmwareStorageURL else {
            throw GenericError.couldNotCreateFirmwareDirectory
        }
        let filePath = storageURL.appendingPathComponent(name)
        try data.write(to: filePath, options: [.atomicWrite])
    }
    
    private func checkFirmwareExistance(with name: String) throws -> Bool {
        guard let storageURL = firmwareStorageURL else {
            throw GenericError.couldNotCreateFirmwareDirectory
        }
        return FileManager.default.fileExists(atPath: storageURL.appendingPathComponent(name).path)
    }
    
    
    /// Promise to save FW locally
    private func promise_saveFirmware(_ firmware: FirmwareModel) -> Promise<Void> {
        return Promise { seal in
            if let encodedFile = firmware.file,
                let name = firmware.fileName,
                let data = Data(base64Encoded: encodedFile) {
                do {
                    try saveFirmwareInCacheDirectory(withName: name, with: data)
                } catch let error {
                    seal.reject(error)
                }
                seal.fulfill(())
            } else {
                seal.reject(GenericError.applicationFirmwareNotReturnedFromModel)
            }
        }
    }
    /// Promise to search firmware
    private func promise_firmwareAlreadySaved(_ firmware: FirmwareModel) -> Promise<Bool> {
        return promise_firmwareAlreadySaved(firmware.fileName)
    }
    private func promise_firmwareAlreadySaved(_ fileName: String?) -> Promise<Bool> {
        return Promise { seal in
            if let fileName = fileName {
                do {
                    let answer = try checkFirmwareExistance(with: fileName)
                    seal.fulfill(answer)
                } catch let error {
                    seal.reject(error)
                }
            } else {
                seal.reject(GenericError.applicationFirmwareNotReturnedFromModel)
            }
        }
    }
    
    func promise_checkDownloadAndCache(fwTypeId: String, fileName: String?) -> Promise<Void> {
        return firstly {
            promise_firmwareAlreadySaved(fileName)
        }.then { (answer) -> Promise<Void> in
            if answer {
                return Promise.value(())
            } else {
                return self.promise_getFirmware(firmwareTypeId: fwTypeId).then { (model) -> Promise<Void> in
                    self.promise_saveFirmware(model)
                }
            }
        }
    }
     func promise_checkDownloadAndCache(_ model: FirmwareModel) -> Promise<Void> {
        return promise_checkDownloadAndCache(fwTypeId: model.typeId, fileName: model.fileName)
    }
    
    func promise_downloadLatestFirmware(_ productTypeModel: FirmwareProductTypeModel) -> Promise<Void> {
        // TODO: Remove when I can filter for channel type
        guard productTypeModel.lastFirmwareVersion.count == 2 else {
            return Promise.value(())
        }
        return firstly { () -> Promise<FirmwareModel> in
            guard let bleFw = productTypeModel.bleFirmware else {
                throw GenericError.applicationFirmwareNotReturnedFromModel
            }
            guard let dscFW = productTypeModel.dscFirmware else {
                throw GenericError.applicationFirmwareNotReturnedFromModel
            }
            return promise_checkDownloadAndCache(bleFw).map{dscFW}
            }.then { dscFW in
                self.promise_checkDownloadAndCache(dscFW)
        }
    }
    
    func promise_downloadAllFirmware() -> Promise<Void> {
        return firstly {
            promise_getFirmwareProductList()
            }.then { (firmwareProductTypeModels) -> Promise<Void> in
                return when(fulfilled: firmwareProductTypeModels.map(self.promise_downloadLatestFirmware))
        }
    }
    
    func promise_getFirmware(firmwareTypeId: String) -> Promise<FirmwareModel> {
        return Promise { seal in
            getFirmware(firmwareTypeId: firmwareTypeId, success: { (model) in
                seal.fulfill(model)
            }, failure: { (error) in
                seal.reject(error)
            })
        }
    }
    
     func promise_getLastFirmwareVersion(firmwareProductId: String) -> Promise<FirmwareProductTypeModel> {
        return Promise { seal in
            getLastFirmwareVersion(firmwareProductId: firmwareProductId, success: { (model) in
                seal.fulfill(model)
            }, failure: { (error) in
                seal.reject(error)
            })
        }
    }
    
    func promise_getFirmwareProductList() -> Promise<[FirmwareProductTypeModel]> {
        return Promise { seal in
            getFirmwareProductList(page: 1, rows: 100, success: { (models) in
                seal.fulfill(models)
            }, failure: { (error) in
                seal.reject(error)
            })
        }
    }
     func promise_updateFirmwaresVersions(driverId: String, firmwareProductTypeId: String, bleFirmware: FirmwareVersion, dscFirmware: FirmwareVersion, bmsFirmware: FirmwareVersion? = nil) -> Promise<Void> {
        return Promise { seal in
                updateApplicationFirmwares(driverId: driverId, firmwareProductTypeId: firmwareProductTypeId, bleFirmware: bleFirmware, dscFirmware: dscFirmware, bmsFirmware: bmsFirmware, success: {
                seal.fulfill(())
            }, failure: { (error) in
                seal.reject(error)
            })
        }
    }

    func promise_sendVehicleReport(vehicleId: String, hubId: String, hubSerialNumber: String, diagnosticReportType: DiagnosticReportType, report: String) -> Promise<Void> {
       return Promise<Void> { seal in
           let model = SendReportAPIModel(vehicleId: vehicleId, hubId: hubId, hubSerialNumber: hubSerialNumber, diagnosticReportType: diagnosticReportType, report: report)
        sendVehicleReport(model: model, success: {
               seal.fulfill(())
           }, failure: { error in
               seal.reject(error)
           })
       }
    }
}

