//
//  EasyDocTests.swift
//  EasyDocTests
//
//  Created by Rodrigo Hilkner on 09/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import XCTest
import Firebase
@testable import EasyDoc

class EasyDocTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Tests if documents are being parsed correctly
    func testDocumentsParse() {
        // 1. given
        let documentDict = EasyDocTestsIO.documentDictInput()
        
        // 2. when
        let documentObject = DocumentParser.parseDocumentDictionary(documentDict, autoID: "123")
        let documentAnswer = EasyDocTestsIO.documentObjectOutput()
        
        // 3. then
        XCTAssert(self.documentsAreEqual(document1: documentObject!, document2: documentAnswer), "Document dictionary was not correctly parsed.")
    }
    
    // Checks if two documents are equivalent
    func documentsAreEqual(document1: Document, document2: Document) -> Bool {
        
        return document1.autoID == document2.autoID &&
               document1.title == document2.title &&
               document1.lastModified == document2.lastModified &&
               self.templatesAreEqual(template1: document1.template, template2: document2.template)
    }
    
    // Checks if two templates are equivalent
    func templatesAreEqual(template1: Template, template2: Template) -> Bool {
        return template1.contents == template2.contents &&
               template1.type == template2.type &&
               self.fieldsAreEqual(fields1: template1.fields, fields2: template2.fields)
    }
    
    // Checks if two fields are equivalent
    func fieldsAreEqual(fields1: [Field], fields2: [Field]) -> Bool {
        
        for field1 in fields1 {
            var fieldNotFound = true
            
            for field2 in fields2 {
                if field1.key == field2.key &&
                   field1.type == field2.type &&
                   field1.order == field2.order &&
                   ((field1.type == FieldType.dict && self.fieldsAreEqual(fields1: field1.value as! [Field], fields2: field2.value as! [Field])) ||
                   (field1.type == FieldType.string && field1.value as! String == field2.value as! String)) {
                    
                    fieldNotFound = false
                    break
                }
            }
            
            if fieldNotFound {
                return false
            }
        }
        
        return true
    }
    
}
