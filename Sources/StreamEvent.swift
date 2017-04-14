//
//  StreamEvent.swift
//  TeslaSwift
//
//  Created by Jacob Holland on 4/11/17.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

open class StreamEvent: Mappable {
    
    open var timestamp: Date?
    open var speed: Int?
    open var odometer: Double?
    open var soc: Int?
    open var elevation: Int?
    open var estLat: Double?
    open var estLng: Double?
    open var power: Int?
    open var shiftState: String?
    open var range: Int?
    open var estRange: Int?
    open var estHeading: Int?
    open var heading: Int?
    
    // MARK: Mappable protocol
    
    public init() {
    }
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        timestamp			<- map["timestamp"]
        odometer			<- map["odometer"]
        soc                 <- map["soc"]
        elevation			<- map["elevation"]
        estLat              <- map["est_lat"]
        estLng             <- map["est_lng"]
        power               <- map["power"]
        shiftState			<- map["shift_state"]
        range               <- map["range"]
        estRange			<- map["est_range"]
        estHeading			<- map["est_heading"]
        heading             <- map["heading"]
    }
}
