//
//  RemoteSeatHeaterAutoOptions.swift
//  TeslaSwift
//

import Foundation

open class RemoteSeatHeaterAutoOptions: Encodable {

    open var seat: AutoHeatedSeat
    open var on: Bool

    public init(seat: AutoHeatedSeat, on: Bool) {
        self.seat = seat
        self.on = on
    }

    enum CodingKeys: String, CodingKey {
        case seat = "auto_seat_position"
        case on = "auto_climate_on"
    }
}

public enum AutoHeatedSeat: Int, Encodable {
    case driver = 0
    case passenger = 1
    case rearLeft = 2
    case rearCenter = 4
    case rearRight = 5
}
