//
//  BioweaponModeOptions.swift
//  TeslaSwift
//

import Foundation

open class BioweaponModeOptions: Encodable {
    open var on: Bool

    public init(state: Bool) {
        on = state
    }

    enum CodingKeys: String, CodingKey {
        case on
    }
}
