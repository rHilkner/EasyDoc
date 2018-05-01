//
//  MainUser.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class MainUser {
    var autoID: String
    var email: String
    var documents: [Document]

    init(autoID: String, email: String, documents: [Document]) {
        self.autoID = autoID
        self.email = email
        self.documents = documents
    }
}
