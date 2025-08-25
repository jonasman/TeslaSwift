//
//  StreamViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 10/11/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import UIKit
import TeslaSwift
import TeslaSwiftStreaming

class StreamViewController: UIViewController {
	@IBOutlet weak var textView: UITextView!
	
	var streaming = false
	var vehicle: Vehicle?
    var stream: TeslaStreaming!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        stream = TeslaStreaming(teslaSwift: api)
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		stopStream(self)
	}

	@IBAction func stream(_ sender: Any) {
        if !streaming {
            guard let vehicle = vehicle else { return }
            self.textView.text = ""
            Task { @MainActor in
                for try await event in try await stream.openStream(vehicle: vehicle) {
                    self.processEvent(event: event)
                }
                self.streaming = true
            }
        }
	}
	
    func processEvent(event: TeslaStreamingEvent) {
        switch event {
            case .error(let error):
                textView.text = error.localizedDescription
            case .event(let event):
                textView.text = "\(self.textView.text ?? "")\nevent:\n \(event.descriptionKm)"
            case .disconnected:
                break
            case .open:
                textView.text = "open"
        }
    }

	@IBAction func stopStream(_ sender: Any) {
        stream.closeStream()
		streaming = false
	}
}
