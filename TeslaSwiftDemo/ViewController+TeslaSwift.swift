//
//  APIViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 03/12/2016.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit
import TeslaSwift

extension UIViewController {
	public var api: TeslaSwift {
		return (UIApplication.shared.delegate as! AppDelegate).api
	}
}
