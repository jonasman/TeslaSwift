//
//  SecondViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit
#if canImport(Combine)
import Combine
#endif
import TeslaSwift

class SecondViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var data:[Product]?
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        getProducts()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.loginDone, object: nil, queue: nil) { [weak self] (notification: Notification) in
            
            self?.getProducts()
        }
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.estimatedRowHeight = 50.0
    }
    
    nonisolated func getProducts() {
        Task { @MainActor in
            self.data = try await api.getProducts()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product-cell", for: indexPath)
        
        let product = data![(indexPath as NSIndexPath).row]
        
        if let vehicle = product.vehicle {
            cell.textLabel?.text = vehicle.displayName
            cell.detailTextLabel?.text = vehicle.vin
        } else if let energySite = product.energySite {
            cell.textLabel?.text = energySite.id
            cell.detailTextLabel?.text = energySite.resourceType
        } else {
            cell.textLabel?.text = "Unknown"
            cell.detailTextLabel?.text = "Unknown"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toProductDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let vc = segue.destination as! ProductViewController
                vc.product = data![indexPath.row]
            }
        }
    }
}

