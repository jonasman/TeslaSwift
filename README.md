# TeslaSwift
Swift library to access Tesla API based on [Tesla JSON API (Unofficial)](https://tesla-api.timdorr.com) and [Tesla Fleet API](https://developer.tesla.com/docs/fleet-api)

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg?style=flat)](https://swift.org)
[![Build Status](https://travis-ci.org/jonasman/TeslaSwift.svg?branch=master)](https://travis-ci.org/jonasman/TeslaSwift)

## Installation

### Swift Package Manager

You can use [Swift Package Manager](https://swift.org/package-manager/) and specify a dependency in `Package.swift` by adding this or adding the dependency to Xcode:

```swift
.Package(url: "https://github.com/jonasman/TeslaSwift.git", majorVersion: 10)
```

There are also extensions for Combine `TeslaSwiftCombine`

The Streaming extensions are: `TeslaSwiftStreaming`, Combine `TeslaSwiftStreamingCombine` 

## Tesla API
There are 2 Tesla APIs available:
1. The old owner API
2. The new Fleet API

You can choose any of them. If you want to use FleetAPI, initialize the library with a `region`, `clientId`, `clientSecret` and `redirectURI`

## App registration for the Fleet API
To use the new Fleet API, you will need to register your app.

Follow the steps on the [official documentation](https://developer.tesla.com/docs/fleet-api#setup):
1. Create a private/public key and upload the public key to a website
2. Make a new app at [Tesla Developer](https://developer.tesla.com/dashboard)
3. Get a partner token (using this Library)
4. Register your app (using this Library)

This library helps you get a partner token and register your app with 2 APIs:
```swift
getPartnerToken()
registerApp(domain: String)
```

## Usage

Tesla's server is not compatible with ATS so you need to add the following to your app Info.plist

```XML
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

Import the module

```swift
import TeslaSwift
```

Add the extension modules if needed (with the previous line)

```swift
import TeslaSwiftCombine
```

Perform an authentication with your MyTesla credentials using the web oAuth2 flow with MFA support: 

```swift
let teslaAPI = ...
let api = TeslaSwift(teslaAPI: teslaAPI)
let (webloginViewController, result) = api.authenticateWeb()
guard let webloginViewController else { return }
present(webloginViewController, animated: true, completion: nil)
Task { @MainActor in
        do {
             _ = try await result()
             self.messageLabel.text = "Authentication success"
        } catch let error {
            // error
       }
}
```

To to perform an authentication in SwiftUI, create an UIViewControllerRepresentable to inject the UIViewController into a SwiftUI view:

```swift
import TeslaSwift
import SwiftUI

struct TeslaWebLogin: UIViewControllerRepresentable {
    let teslaAPI = ...
    let api = TeslaSwift(teslaAPI: teslaAPI)    
    
    func makeUIViewController(context: Context) -> TeslaWebLoginViewController {
        let (webloginViewController, result) = api.authenticateWeb()        
        Task { @MainActor in
                do {
                     _ = try await result()
                    print("Authentication success")                    
                    guard api.isAuthenticated else { return }
                    Task { @MainActor in
                        do {
                            let vehicles = try await api.getVehicles()

                            // post process your vehicles here

                        } catch {
                            print("Error",error)
                        }
                    }                    
                } catch let error {
                    print("Error", error)
               }
        }        
        return webloginViewController!
    }
    
    func updateUIViewController(_ uiViewController: TeslaWebLoginViewController, context: Context) {
    }
    
}
```

```swift
import SwiftUI
struct TeslaLogin: View {
    var body: some View {
        VStack {
            TeslaWebLogin()
        }
    }
}
```
## Public Key upload to vehicle
After authenticatiom, some vehicles might need to receive your public key.

```swift
if let url = api.urlToSendPublicKeyToVehicle(domain: yourDomain) {
    UIApplication.shared.open(url)
}
```

This will open the Tesla app and send the public key to the selected vehicle in the app.


## Token reuse
After authentication, store the AuthToken in a safe place.
The next time the app starts-up you can reuse the token:

```swift
let teslaAPI = ...
let api = TeslaSwift(teslaAPI: teslaAPI)
api.reuse(token: previousToken)

```

## Vehicle data
Example on how to get a list of vehicles

```swift

class CarsViewController: ViewController {
    func showCars() {
      do {
        let response = try await api.getVehicles()
        self.data = response
        self.tableView.reloadData()
      } catch let error {
        //Process error
     }
}
```

## Streaming
Import the module

```swift
import TeslaSwiftStreaming
```

Import the extension modules if needed (with the previous line)

```swift
import TeslaSwiftStreamingCombine
```
```swift
class CarsViewController: ViewController {

  func showStream() {
    stream = TeslaStreaming(teslaSwift: api)
    do {
        for try await event in try await stream.openStream(vehicle: myVehicle) {
            switch event {
                case .open:
                    // Open
                case .event(let streamEvent):
                    self.data.append(streamEvent)
                    self.tableView.reloadData()
                case .error(let error):                    
                    // Process error
                case .disconnet:
                    break
            }
        }
    } catch let error {
    // error
    }

    // After some events...
    stream.closeStream()
   }
}
```

## Encoder and Decoder

If you need a JSON Encoder and Decoder, the library provides both already configured to be used with Tesla's JSON formats

```swift
public let teslaJSONEncoder: JSONEncoder
public let teslaJSONDecoder: JSONDecoder
```  

## Options

You can enable debugging by setting: `api.debuggingEnabled = true`
Debug logs use Unified Logging and can be found by filtering for `subsystem: Tesla Swift`

## Other Features

After the authentication is done, the library will manage the access token. 
When the token expires the library will request a new token using the refresh token.

## Referral

If you want to buy a Tesla or signup for the mailing list using my referral as a "thank you" for this library here it is:
http://ts.la/joao290

## Apps using this library

* Key for Tesla (https://itunes.apple.com/us/app/key-for-tesla/id1202595802?mt=8)
* Camper for Tesla (https://itunes.apple.com/us/app/camper-for-tesla/id1227483065?mt=8)
* Power for Tesla (https://itunes.apple.com/us/app/power-for-tesla/id1194710823?mt=8)
* Plus - for Tesla Model S & X (https://itunes.apple.com/us/app/plus-for-tesla-model-s-x/id1187829197?mt=8)
* Nikola for Tesla (https://itunes.apple.com/us/app/nikola-for-tesla/id1244489779?mt=8)
* Charged - for Tesla (https://getcharged.app/)
* TeSlate (https://infinytum.co/)
* Companion for Tesla - oAuth - (https://teslacompanion.app)
* Pilot Log for Tesla (https://itunes.apple.com/us/app/pilot-log-for-Tesla/id1564398488?mt=8)
* EV Companion (https://itunes.apple.com/us/app/ev-companion/id1574209459?mt=8)
* S3XY Key Fob (https://kenmaz.net/tesla-app/)
* Meter (https://apps.apple.com/us/app/meter/id1603166204)
* Chargey (https://get.chargey.app/)

Missing your app? open a PR or issue

## License

The MIT License (MIT)

Copyright (c) 2016 João Nunes

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
