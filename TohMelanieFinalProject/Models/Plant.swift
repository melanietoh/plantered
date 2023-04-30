//
//  Plant.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 5/12/2022.
//

import Foundation

struct Plant: Codable, Hashable {
    private var name:String
    private var recurrence:String
    
    init(name: String, recurrence: String) {
        self.name = name
        self.recurrence = recurrence
    }
    
    // To create a custom class in Firestore
    enum CodingKeys: String, CodingKey {
        case name
        case recurrence
    }
    
    func getName() -> String {
        return name
    }
    
    func getRecurrence() -> String {
        return recurrence
    }
}
