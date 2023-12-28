//
//  TeslaSwift+Combine.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 08/07/2019.
//  Copyright © 2019 Joao Nunes. All rights reserved.
//

#if swift(>=5.1)
import Combine
import TeslaSwift

extension TeslaSwift {
    public func revokeToken() -> Future<Bool, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.revokeToken()
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func getVehicles() -> Future<[Vehicle], Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getVehicles()
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func getVehicle(_ vehicleID: String) -> Future<Vehicle, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getVehicle(vehicleID)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func getVehicle(_ vehicle: Vehicle) -> Future<Vehicle, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getVehicle(vehicle)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func getAllData(_ vehicle: Vehicle) -> Future<VehicleExtended, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getAllData(vehicle)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func getVehicleMobileAccessState(_ vehicle: Vehicle) -> Future<Bool, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getVehicleMobileAccessState(vehicle)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func wakeUp(_ vehicle: Vehicle) -> Future<Vehicle, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.wakeUp(vehicle)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) -> Future<CommandResponse, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.sendCommandToVehicle(vehicle, command: command)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func getNearbyChargingSite(vehicle: Vehicle) -> Future<NearbyChargingSites, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getNearbyChargingSites(vehicle)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func getProducts() -> Future<[Product], Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getProducts()
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }

    public func getEnergySiteStatus(siteID: SiteId) -> Future<EnergySiteStatus, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getEnergySiteStatus(siteID: siteID)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }

    public func getEnergySiteLiveStatus(siteID: SiteId) -> Future<EnergySiteLiveStatus, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getEnergySiteLiveStatus(siteID: siteID)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }

    public func getEnergySiteInfo(siteID: SiteId) -> Future<EnergySiteInfo, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getEnergySiteInfo(siteID: siteID)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
    public func getEnergySiteHistory(siteID: SiteId, period: EnergySiteHistory.Period) -> Future<EnergySiteHistory, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getEnergySiteHistory(siteID: siteID, period: period)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }


    public func getBatteryStatus(batteryID: String) -> Future<BatteryStatus, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getBatteryStatus(batteryID: batteryID)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }

    public func getBatteryData(batteryID: BatteryId) -> Future<BatteryData, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getBatteryData(batteryID: batteryID)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }

    public func getBatteryPowerHistory(batteryID: BatteryId) -> Future<BatteryPowerHistory, Error> {
        Future { promise in
            Task {
                do {
                    let result = try await self.getBatteryPowerHistory(batteryID: batteryID)
                    promise(.success(result))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
}

#endif
