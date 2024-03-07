//
//  VehicleViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 22/10/2016.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit
import CoreLocation
import TeslaSwift

class VehicleViewController: UIViewController {
	@IBOutlet weak var textView: UITextView!

	var vehicle: Vehicle?

    @IBAction func getVehicle(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let vehicle2 = try await api.getVehicle(vehicle)
            self.textView.text = "Inside temp: \(vehicle2.jsonString!)"
        }
    }
	
	@IBAction func gettAll(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let extendedVehicle = try await api.getAllData(vehicle, endpoints: AllStatesEndpoints.allWithLocation)
            self.textView.text = "All data:\n" +
            extendedVehicle.jsonString!
        }
	}
	
	@IBAction func command(_ sender: AnyObject) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let response = try await api.sendCommandToVehicle(vehicle, command: VehicleCommand.setMaxDefrost(on: false))
            self.textView.text = (response.result! ? "true" : "false")
            if let reason = response.reason {
                self.textView.text.append(reason)
            }
        }
	}
	
	@IBAction func wakeup(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let response = try await api.wakeUp(vehicle)
            self.textView.text = response.state
        }
    }
	
	
	@IBAction func speedLimit(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let response = try await api.sendCommandToVehicle(vehicle, command: VehicleCommand.speedLimitClearPin(pin: "1234"))
            self.textView.text = (response.result! ? "true" : "false")
            if let reason = response.reason {
                self.textView.text.append(reason)
            }
        }
	}

    @IBAction func getNearbyChargingSites(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let nearbyChargingSites = try await api.getNearbyChargingSites(vehicle)
            self.textView.text = "NearbyChargingSites:\n" +
            nearbyChargingSites.jsonString!
        }
    }

    @IBAction func refreshToken(_ sender: Any) {
        Task { @MainActor in
            do {
                let token = try await api.refreshToken()
                self.textView.text = "New access Token:\n \(token)"
            } catch {
                self.textView.text = "Refresh Token:\n CATCH"
            }
        }
    }

    @IBAction func ampsTo16(_ sender: Any) {
        guard let vehicle = vehicle else { return }
        Task { @MainActor in
            let response = try await api.sendCommandToVehicle(vehicle, command: VehicleCommand.setCharging(amps: 16))
            self.textView.text = (response.result! ? "true" : "false")
            if let reason = response.reason {
                self.textView.text.append(reason)
            }
        }
    }

    @IBAction func revokeToken(_ sender: Any) {
        Task { @MainActor in
            do {
                let status = try await api.revokeToken()
                self.textView.text = "Revoked: \(status)"
            } catch {
                self.textView.text = "Revoke Token:\n CATCH"
            }
        }
    }

    @IBAction func logout(_ sender: Any) {
        api.logout()
    }
    @IBAction func sendKeyToVehicle(_ sender: Any) {
        let yourDomain = ""
        if let url = api.urlToSendPublicKeyToVehicle(domain: yourDomain) {
            UIApplication.shared.open(url)
        }
    }


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		if segue.identifier == "toStream" {
			let vc = segue.destination as! StreamViewController
			vc.vehicle = self.vehicle
		}
	}
}
