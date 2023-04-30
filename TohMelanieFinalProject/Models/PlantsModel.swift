//
//  PlantsModel.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 5/12/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PlantsModel: ObservableObject {
    static let sharedInstance = PlantsModel()
    
    var user: User = .empty
    var plants = [Plant]()
    var username: String = ""
    let db = Firestore.firestore()
    
    func setUsername(_ username: String) {
        self.username = username
    }
    
    func getUsername() -> String {
        return self.username
    }
    
    // Returns the number of plants
    func getNumberOfPlants() -> Int {
        initialize()
        return plants.count
    }
    
    // Initalizes/updates plants variable
    func initialize() {
        let docRef = db.collection("users").document(username)
        
        docRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.user = user
                self.plants = user.plants
            case .failure(let error):
                print("Error retrieving user: \(error)")
                return
            }
        }
    }
    
    // Returns all plants stored with user
    func getPlants() -> [Plant] {
        initialize()
        return plants
    }
    
    // Returns plant at given index
    func getPlant(at index: Int) -> Plant? {
        initialize()
        if(index < plants.count && plants.count != 0) {
           return plants[index]
        }
        return nil
    }
    
    // Adds plant
    func addPlant(_ plant: Plant) {
        initialize()
        plants.insert(plant, at: getNumberOfPlants())
        user.plants = self.plants
        
        let docRef = db.collection("users").document(username)
        do {
            try docRef.setData(from: user)
            print("The plant was successfully added!")
        }
        catch {
            print("Error adding the plant: \(error)")
        }
        
        initialize()
    }
    
    // Removes plant at given index
    func removePlant(at index: Int) {
        initialize()
        plants.remove(at: index)
        user.plants = self.plants
        
        let docRef = db.collection("users").document(username)
        do {
            try docRef.setData(from: user)
            print("The plant was successfully deleted!")
        }
        catch {
            print("Error deleting the plant: \(error)")
        }
        
        initialize()
    }

}
