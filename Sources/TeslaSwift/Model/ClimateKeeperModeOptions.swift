//
//  ClimateKeeperModeOptions.swift
//  TeslaSwift
//

import Foundation

open class ClimateKeeperModeOptions: Encodable {

    open var mode: ClimateKeeperMode

    public init(mode: ClimateKeeperMode) {
        self.mode = mode
    }

    enum CodingKeys: String, CodingKey {
        case mode = "climate_keeper_mode"
    }
}

public enum ClimateKeeperMode: Int, Encodable {
    case off = 0
    case on = 1
    case dog = 2
    case camp = 3
}
