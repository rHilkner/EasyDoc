//
//  FirebaseManager.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    
    /// FIRDatabaseReference for the root of Guarded's Firebase Database
    static var databaseReference = Database.database().reference()
    
}
