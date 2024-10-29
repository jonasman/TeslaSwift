//
//  FirstViewController.swift
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

class FirstViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [Product]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVehicles()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.loginDone, object: nil, queue: nil) { [weak self] (notification: Notification) in
            
            self?.getVehicles()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.estimatedRowHeight = 50.0
        
    }
    
    nonisolated func getVehicles() {
        Task { @MainActor in
            let products = try await api.getProducts()
            self.data = products
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let product = data![(indexPath as NSIndexPath).row]

        cell.textLabel?.text = product.vehicle?.displayName ?? ""
        cell.detailTextLabel?.text = product.vehicle?.vin ?? product.energySite?.id

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toDetail" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let vc = segue.destination as! VehicleViewController
                if let vehicle = data![indexPath.row].vehicle {
                    vc.vehicle = vehicle
                }
            }
            
        }
    }
    
}

