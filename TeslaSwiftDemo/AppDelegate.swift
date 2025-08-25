//
//  AppDelegate.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit
import TeslaSwift

// Change this!
let clientID = "ABC"
let clientSecret = "DEF"
let redirectURI = "teslaswift://teslaswift"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
    var api: TeslaSwift!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

        let teslaAPI = TeslaAPI.fleetAPI(region: .europeMiddleEastAfrica, clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI)
        api = TeslaSwift(teslaAPI: teslaAPI)
		api.debuggingEnabled = true
		
		if let jsonString = UserDefaults.standard.object(forKey: "tesla.token") as? String,
			let token: AuthToken = jsonString.decodeJSON(),
			let email = UserDefaults.standard.object(forKey: "tesla.email") as? String {
			api.reuse(token: token, email: email)
		}
		
		return true
	}

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        Task { @MainActor in
            do {
                _ = try await api.authenticateWebNative(url: url)
                NotificationCenter.default.post(name: Notification.Name.nativeLoginDone, object: nil)
            } catch {
                print("Error")
            }
        }

        return true
    }

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		
		UserDefaults.standard.set(api.token?.jsonString, forKey: "tesla.token")
		UserDefaults.standard.set(api.email, forKey: "tesla.email")
		UserDefaults.standard.synchronize()
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}
