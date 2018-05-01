//
//  EasyDocTestIO.swift
//  EasyDocTests
//
//  Created by Rodrigo Hilkner on 09/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import Firebase
@testable import EasyDoc

class EasyDocTestsIO {
    
    // Field dictionary to give as test input
    static func fieldDictInput() -> [String : [String : Any]] {
        
        let fieldDictInput: [String : [String : Any]] = [
            "fieldkey1": [
                "value": [
                    "fieldkey2": [
                        "value": "val",
                        "type": "string",
                        "order": 0
                    ]
                ],
                "type": "dict",
                "order": 0
            ]
        ]
        
        return fieldDictInput
    }
    
    // Field object corresponding to field dictionary above
    static func fieldObjectOutput() -> Field {
        
        let fieldObjectOutput: Field = Field(key: "fieldkey1",
                                             value: [Field(key: "fieldkey2",
                                                          value: "val",
                                                          type: .string,
                                                          order: 0,
                                                          path: "123/fields/fieldkey1/value/fieldkey2/value")],
                                             type: .dict,
                                             order: 0,
                                             path: "123/fields/fieldkey1/value")
        
        return fieldObjectOutput
    }
    
    // Document dictionary to give as test input
    static func documentDictInput() -> [String : Any] {
        
        let documentDictInput: [String : Any] = [
            "title": "abc",
            "type": "doctype",
            "contents": "Content: [/fieldkey1/fieldkey2].",
            "fields": self.fieldDictInput(),
            "last_modified": 1517992043.711909
        ]
        
        return documentDictInput
    }
    
    // Document object corresponding to document dictionary above
    static func documentObjectOutput() -> Document {
        let templateObject = Template(type: "doctype", content: "Content: [/fieldkey1/fieldkey2].", fields: [self.fieldObjectOutput()])
        
        let documentObjectOutput: Document = Document(autoID: "123",
                                                      title: "abc",
                                                      template: templateObject,
                                                      lastModified: Date(timeIntervalSince1970: 1517992043.711909 as TimeInterval))
        
        return documentObjectOutput
    }
    
}
