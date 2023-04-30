//
//  TableViewController.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 5/12/2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class TableViewController: UITableViewController {

    let plantsModel = PlantsModel.sharedInstance
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        loadFirestoreData()
    }
    
    // Refresh the table
    func viewWillAppear() {
        self.tableView.reloadData()
    }
    
    // Retrieving data from Firestore
    func loadFirestoreData() {
        let docRef = db.collection("users").document(plantsModel.getUsername())
        
        docRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.plantsModel.user = user
                self.plantsModel.plants = user.plants
                // Reload data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error retrieving user: \(error)")
                return
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Number of rows
    override func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
        return self.plantsModel.plants.count
    }
    
    // Retrieving Plant objects to display in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        if let plant = self.plantsModel.getPlant(at: indexPath.row) {
            cell.textLabel?.text = "Name: \(plant.getName())"
            cell.detailTextLabel?.text = "Water Frequency: \(plant.getRecurrence())"
        }
        return cell
    }
    
    // Return from AddPlantVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addPlantVC = segue.destination as! AddPlantViewController
        addPlantVC.completion = {(name: String?, recurrence: String?) in
            self.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tableView.reloadData()
        if editingStyle == .delete {
            plantsModel.removePlant(at: indexPath.row)

            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
