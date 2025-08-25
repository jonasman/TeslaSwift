//
//  VehicleCommands.swift
//  TeslaSwift
//
//  Created by João Nunes on 02/04/2022.
//  Copyright © 2022 Joao Nunes. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

public enum VehicleCommand {
    case valetMode(valetActivated: Bool, pin: String?)
    case resetValetPin
    case openChargeDoor
    case closeChargeDoor
    case chargeLimitStandard
    case chargeLimitMaxRange
    case chargeLimitPercentage(limit: Int)
    case startCharging
    case stopCharging
    case scheduledCharging(enable: Bool, time: Int)
    case scheduledDeparture(options: ScheduledDepartureCommandOptions)
    case flashLights
    case triggerHomeLink(location: CLLocation)
    case honkHorn
    case unlockDoors
    case lockDoors
    case remoteBoombox
    case setTemperature(driverTemperature: Double, passengerTemperature: Double)
    case setMaxDefrost(on: Bool)
    case startAutoConditioning
    case stopAutoConditioning
    case setSunRoof(state: RoofState, percentage: Int?)
    case startVehicle(password: String)
    case openTrunk(options: OpenTrunkOptions)
    case togglePlayback
    case nextTrack
    case previousTrack
    case nextFavorite
    case previousFavorite
    case volumeUp
    case volumeDown
    case shareToVehicle(options: ShareToVehicleOptions)
    case cancelSoftwareUpdate
    case scheduleSoftwareUpdate
    case speedLimitSetLimit(speed: Measurement<UnitSpeed>)
    case speedLimitActivate(pin: String)
    case speedLimitDeactivate(pin: String)
    case speedLimitClearPin(pin: String)
    case setSeatHeater(seat: HeatedSeat, level: HeatLevel)
    case setSteeringWheelHeater(on: Bool)
    case sentryMode(activated: Bool)
    case windowControl(state: WindowState)
    case setCharging(amps: Int)

    func path() -> String {
        switch self {
            case .valetMode:
                return "command/set_valet_mode"
            case .resetValetPin:
                return "command/reset_valet_pin"
            case .openChargeDoor:
                return "command/charge_port_door_open"
            case .closeChargeDoor:
                return "command/charge_port_door_close"
            case .chargeLimitStandard:
                return "command/charge_standard"
            case .chargeLimitMaxRange:
                return "command/charge_max_range"
            case .chargeLimitPercentage:
                return  "command/set_charge_limit"
            case .startCharging:
                return  "command/charge_start"
            case .stopCharging:
                return "command/charge_stop"
            case .scheduledCharging:
                return "command/set_scheduled_charging"
            case .scheduledDeparture:
                return "command/set_scheduled_departure"
            case .flashLights:
                return "command/flash_lights"
            case .triggerHomeLink:
                return "command/trigger_homelink"
            case .honkHorn:
                return "command/honk_horn"
            case .unlockDoors:
                return "command/door_unlock"
            case .lockDoors:
                return "command/door_lock"
            case .remoteBoombox:
                return "command/remote_boombox"
            case .setTemperature:
                return "command/set_temps"
            case .setMaxDefrost:
                return "command/set_preconditioning_max"
            case .startAutoConditioning:
                return "command/auto_conditioning_start"
            case .stopAutoConditioning:
                return "command/auto_conditioning_stop"
            case .setSunRoof:
                return "command/sun_roof_control"
            case .startVehicle:
                return "command/remote_start_drive"
            case .openTrunk:
                return "command/actuate_trunk"
            case .togglePlayback:
                return "command/media_toggle_playback"
            case .nextTrack:
                return "command/media_next_track"
            case .previousTrack:
                return "command/media_prev_track"
            case .nextFavorite:
                return "command/media_next_fav"
            case .previousFavorite:
                return "command/media_prev_fav"
            case .volumeUp:
                return "command/media_volume_up"
            case .volumeDown:
                return "command/media_volume_down"
            case .shareToVehicle:
                return "command/share"
            case .scheduleSoftwareUpdate:
                return "command/schedule_software_update"
            case .cancelSoftwareUpdate:
                return "command/cancel_software_update"
            case .speedLimitSetLimit:
                return "command/speed_limit_set_limit"
            case .speedLimitActivate:
                return "command/speed_limit_activate"
            case .speedLimitDeactivate:
                return "command/speed_limit_deactivate"
            case .speedLimitClearPin:
                return "command/speed_limit_clear_pin"
            case .setSeatHeater:
                return "command/remote_seat_heater_request"
            case .setSteeringWheelHeater:
                return "command/remote_steering_wheel_heater_request"
            case .sentryMode:
                return "command/set_sentry_mode"
            case .windowControl:
                return "command/window_control"
            case .setCharging:
                return "command/set_charging_amps"
        }
    }
}
