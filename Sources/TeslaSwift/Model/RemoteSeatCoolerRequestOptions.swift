//
//  RemoteSeatCoolerRequestOptions.swift
//  TeslaSwift
//

import Foundation

open class RemoteSeatCoolerRequestOptions: Encodable {

    open var position: SeatPosition
    open var level: CoolerLevel

    public init(position: SeatPosition, level: CoolerLevel) {
        self.position = position
        self.level = level
    }

    enum CodingKeys: String, CodingKey {
        case position = "seat_position"
        case level = "seat_cooler_level"
    }
}

public enum SeatPosition: Int, Encodable {
    case driver = 0
    case passenger = 1
    case rearLeft = 2
    case rearCenter = 4
    case rearRight = 5
}

public enum CoolerLevel: Int, Encodable {
    case off = 0
    case low = 1
    case mid = 2
    case high = 3
}
