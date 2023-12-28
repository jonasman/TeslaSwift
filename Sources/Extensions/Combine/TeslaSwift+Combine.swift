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
    public func revokeWeb() -> Future<Bool, Error> {
        let future = Future<Bool, Error> { (subscriber: @escaping (Result<Bool, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.revokeWeb()
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func getVehicles() -> Future<[Vehicle], Error> {
        let future = Future<[Vehicle], Error> { (subscriber: @escaping (Result<[Vehicle], Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getVehicles()
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func getVehicle(_ vehicleID: String) -> Future<Vehicle, Error> {
        let future = Future<Vehicle, Error> { (subscriber: @escaping (Result<Vehicle, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getVehicle(vehicleID)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func getVehicle(_ vehicle: Vehicle) -> Future<Vehicle, Error> {
        let future = Future<Vehicle, Error> { (subscriber: @escaping (Result<Vehicle, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getVehicle(vehicle)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func getAllData(_ vehicle: Vehicle) -> Future<VehicleExtended, Error> {
        let future = Future<VehicleExtended, Error> { (subscriber: @escaping (Result<VehicleExtended, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getAllData(vehicle)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func getVehicleMobileAccessState(_ vehicle: Vehicle) -> Future<Bool, Error> {
        let future = Future<Bool, Error> { (subscriber: @escaping (Result<Bool, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getVehicleMobileAccessState(vehicle)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func wakeUp(_ vehicle: Vehicle) -> Future<Vehicle, Error> {
        let future = Future<Vehicle, Error> { (subscriber: @escaping (Result<Vehicle, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.wakeUp(vehicle)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) -> Future<CommandResponse, Error> {
        let future = Future<CommandResponse, Error> { (subscriber: @escaping (Result<CommandResponse, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.sendCommandToVehicle(vehicle, command: command)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func getProducts() -> Future<[Product], Error> {
        let future = Future<[Product], Error> { (subscriber: @escaping (Result<[Product], Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getProducts()
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
    
    public func getEnergySiteStatus(siteID: SiteId) -> Future<EnergySiteStatus, Error> {
        let future = Future<EnergySiteStatus, Error> { (subscriber: @escaping (Result<EnergySiteStatus, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getEnergySiteStatus(siteID: siteID)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }

    public func getEnergySiteLiveStatus(siteID: SiteId) -> Future<EnergySiteLiveStatus, Error> {
        let future = Future<EnergySiteLiveStatus, Error> { (subscriber: @escaping (Result<EnergySiteLiveStatus, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getEnergySiteLiveStatus(siteID: siteID)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }

    public func getEnergySiteInfo(siteID: SiteId) -> Future<EnergySiteInfo, Error> {
        let future = Future<EnergySiteInfo, Error> { (subscriber: @escaping (Result<EnergySiteInfo, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getEnergySiteInfo(siteID: siteID)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }

    public func getEnergySiteHistory(siteID: SiteId, period: EnergySiteHistory.Period) -> Future<EnergySiteHistory, Error> {
        let future = Future<EnergySiteHistory, Error> { (subscriber: @escaping (Result<EnergySiteHistory, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getEnergySiteHistory(siteID: siteID, period: period)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }

    public func getBatteryStatus(batteryID: BatteryId) -> Future<BatteryStatus, Error> {
        let future = Future<BatteryStatus, Error> { (subscriber: @escaping (Result<BatteryStatus, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getBatteryStatus(batteryID: batteryID)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }

    public func getBatteryData(batteryID: BatteryId) -> Future<BatteryData, Error> {
        let future = Future<BatteryData, Error> { (subscriber: @escaping (Result<BatteryData, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getBatteryData(batteryID: batteryID)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }

    public func getBatteryPowerHistory(batteryID: BatteryId) -> Future<BatteryPowerHistory, Error> {
        let future = Future<BatteryPowerHistory, Error> { (subscriber: @escaping (Result<BatteryPowerHistory, Error>) -> Void) in
            Task {
                do {
                    let result = try await self.getBatteryPowerHistory(batteryID: batteryID)
                    subscriber(.success(result))
                } catch let error {
                    subscriber(.failure(error))
                }
            }
        }
        return future
    }
}

#endif
