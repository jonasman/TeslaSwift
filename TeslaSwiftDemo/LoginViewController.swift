//
//  LoginViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let loginDone = Notification.Name("loginDone")
    static let nativeLoginDone = Notification.Name("nativeLoginDone")
}

class LoginViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction func webLoginAction(_ sender: AnyObject) {
        let (webloginViewController, result) = api.authenticateWeb()

        guard let webloginViewController else { return }

        self.present(webloginViewController, animated: true, completion: nil)

        Task { @MainActor in
            do {
                _ = try await result()
                self.messageLabel.text = "Authentication success"
                NotificationCenter.default.post(name: Notification.Name.loginDone, object: nil)

                self.dismiss(animated: true, completion: nil)
            } catch let error {
                self.messageLabel.text = "Authentication failed: \(error)"
            }
        }
    }

    @IBAction func nativeLoginAction(_ sender: AnyObject) {
        if let url = api.authenticateWebNativeURL() {
            UIApplication.shared.open(url)
        }
        NotificationCenter.default.addObserver(forName: Notification.Name.nativeLoginDone, object: nil, queue: nil) { [weak self] (notification: Notification) in
            NotificationCenter.default.post(name: Notification.Name.loginDone, object: nil)

            self?.dismiss(animated: true, completion: nil)
        }
    }
}
