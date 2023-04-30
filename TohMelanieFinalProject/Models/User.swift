//
//  User.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 6/12/2022.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
    let password: String
    var plants: [Plant]
}

extension User {
    
    // Empty user object
    static let empty = User(password: "", plants: [Plant]())
}
