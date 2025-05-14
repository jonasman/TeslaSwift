//
//  LoginViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit
import SafariServices

extension Notification.Name {
    static let loginDone = Notification.Name("loginDone")
    static let nativeLoginDone = Notification.Name("nativeLoginDone")
}

class LoginViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction func webLoginAction(_ sender: AnyObject) {
        let webloginViewController = api.authenticateWeb(delegate: self)

        guard let webloginViewController else { return }

        self.present(webloginViewController, animated: true, completion: nil)

        NotificationCenter.default.addObserver(forName: Notification.Name.nativeLoginDone, object: nil, queue: nil) { [weak self] (notification: Notification) in
            self?.dismiss(animated: false) {
                self?.dismiss(animated: false)
            }

            NotificationCenter.default.post(name: Notification.Name.loginDone, object: nil)
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

extension LoginViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: false) {
        }
        print("cancelled")
    }
}
