//
//  MainUser.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class MainUser {
    var email: String
    var documents: [Document]
    
    init(email: String, documents: [Document]) {
        self.email = email
        self.documents = documents
    }
}
