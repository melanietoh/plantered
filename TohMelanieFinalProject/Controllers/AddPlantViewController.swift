//
//  AddPlantViewController.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 5/12/2022.
//

import Foundation
import UIKit
import FirebaseFirestore

class AddPlantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let plantsModel = PlantsModel.sharedInstance
    
    var completion: ((_ name: String?, _ recurrence: String?) -> Void)?
    var pickerData: [String] = [String]()
    var recurrence: String = ""
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var recurrenceSelector: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.isEnabled = false
        cancelButton.isEnabled = true
        
        // Picker initialization
        recurrenceSelector.delegate = self
        recurrenceSelector.dataSource = self
        pickerData = ["Every day", "Every 2 days", "Every 3 days", "Every 4 days", "Every week", "Every 2 weeks"]
    }
    
    // Picker functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Number of columns of picker data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of picker data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Retrieving the picker data at row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Background touch -> Dismiss keyboard
    @IBAction func dismissKeyboard(_ sender: UIButton) {
        nameField.resignFirstResponder()
    }

    // Enabling save only if the text field isn't empty
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        saveButton.isEnabled = !(nameField.text!.isEmpty)
    }
    
    // Dismiss keyboard
    @IBAction func donePressed(_ sender: UITextField) {
        nameField.resignFirstResponder()
    }
    
    // Adds a plant and clears inputs
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let name = nameField.text
        else {
            nameField.text = ""
            return
        }
        recurrence = pickerData[recurrenceSelector.selectedRow(inComponent: 0)]
        
        // TODO: SAVE THE PLANT TO FIRESTORE
        let plant: Plant = Plant(name: name, recurrence: recurrence)
        plantsModel.addPlant(plant)
        
        // Reset
        nameField.text = ""
        
        completion?(name, recurrence)
    }
    
    // Clears inputs and exits AddViewController
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        nameField.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
        
}
