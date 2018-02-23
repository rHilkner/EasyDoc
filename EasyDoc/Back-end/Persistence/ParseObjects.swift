//
//  ParseDictionary.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 26/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class ParseObjects {
    
    /// Parse given dictionary to create main user object. Returns nil if parse gone wrong.
    static func parseMainUserDictionary(_ userDict: [String : [String : Any]], autoID: String) -> MainUser? {
        
        // Getting user's email
        guard let profileDict = userDict["profile_information"] else {
            return nil
        }
        
        guard let userEmail = profileDict["email"] as? String else {
            return nil
        }
        
        // Getting user's documents
        var userDocuments: [Document] = []
        
        let documentsDict = userDict["documents"] as? [String : [String : Any]] ?? [:]
        
        for documentDict in documentsDict {
            guard let document = self.parseDocumentDictionary(documentDict.value, autoID: documentDict.key) else {
                return nil
            }
            
            userDocuments.append(document)
        }
        
        // Returns main user object
        return MainUser(autoID: autoID, email: userEmail, documents: userDocuments)
    }
    
    
    /// Parse given dictionary to create document object. Returns nil if parse gone wrong.
    static func parseDocumentDictionary(_ documentDict: [String : Any], autoID: String) -> Document? {
        // Getting document title
        guard let documentTitle = documentDict["title"] as? String else {
            return nil
        }
        
        // Getting document template type
        guard let documentTemplateType = documentDict["type"] as? String else {
            return nil
        }
        
        // Getting document template contents
        guard let documentTemplateContents = documentDict["contents"] as? String else {
            return nil
        }
        
        // Getting document template fields
        guard let _documentTemplateFields = documentDict["fields"] as? [String : [String : Any]] else {
            return nil
        }
        
        // Parsing document template fields
        let path = autoID + "/fields"
        
        guard let documentTemplateFields = self.parseFields(_documentTemplateFields, path: path) else {
            return nil
        }
        
        // Constructing document's template
        let documentTemplate = Template(type: documentTemplateType, content: documentTemplateContents, fields: documentTemplateFields)
        
        // Getting date when document was last modified
        guard let documentTimestamp = documentDict["last_modified"] as? TimeInterval else {
            return nil
        }
        
        let lastModified = Date(timeIntervalSince1970: documentTimestamp)
        
        // Returns document object
        return Document(autoID: autoID, title: documentTitle, template: documentTemplate, lastModified: lastModified)
    }
    
    
    /// Parse given dictionary to create template object. Returns nil if parse gone wrong.
    static func parseTemplateDictionary(_ templateDict: [String : Any], autoID: String) -> Template? {
        
        // Getting template type
        guard let templateType = templateDict["type"] as? String else {
            return nil
        }
        
        // Getting template contents
        guard let templateContent = templateDict["contents"] as? String else {
            return nil
        }
        
        // Getting template fields
        guard let _templateFields = templateDict["fields"] as? [String : [String : Any]] else {
            return nil
        }
        
        // Getting template fields
        let path = autoID + "/fields"
        
        guard let templateFields = self.parseFields(_templateFields, path: path) else {
            return Template(type: templateType, content: templateContent, fields: [])
        }
        
        return Template(type: templateType, content: templateContent, fields: templateFields)
    }
    
    
    /// Parse given dictionary of fields an array of fields of fields.
    static func parseFields(_ fieldsDict: [String : [String : Any]], path: String) -> [Field]? {
        var fields = [Field?](repeating: nil, count: fieldsDict.count)
        
        // Parsing each field
        for fieldDict in fieldsDict {
            
            // Reading field's key, type and order
            let key = fieldDict.key
            let fieldPath = path + "/" + key + "/value"
            
            guard let type = fieldDict.value["type"] as? String,
                  let order = fieldDict.value["order"] as? Int else {
                return nil
            }
            
            if fields[order] != nil {
                print("-> BIG WARNING: Error in the database - 2 fields have the same order in the document")
                return nil
            }
            
            // Parsing field's value
            if type == "dict" {
                guard let valueDict = fieldDict.value["value"] as? [String : [String : Any]]
                    else {
                    return nil
                }
                
                guard let value = self.parseFields(valueDict, path: fieldPath) else {
                    return nil
                }
                
                fields[order] = Field(key: key, value: value, type: type, order: order, path: fieldPath)
                
            } else {
                guard let value = fieldDict.value["value"] else {
                    return nil
                }
                
                fields[order] = Field(key: key, value: value, type: type, order: order, path: fieldPath)
            }
            
        }
        
        // Returning array of fields
        return fields as? [Field]
    }
    
    
    /// Create new user dictionary from given email and password.
    static func createNewUserDictionary(email: String) -> [String : AnyObject] {
        // Creating user's profile dictionary
        let newUserProfileDict : [String : AnyObject] = [
            "email" : email as AnyObject
        ]
        
        // Creating user's object dictionary
        let newUserDict : [String : AnyObject] = [
            "profile_information": newUserProfileDict as AnyObject,
            "documents": NSNull()
        ]
        
        // Returns new user dictionary
        return newUserDict
    }
    
    
    /// Create document dictionary from given document object
    static func createDocumentDictionary(_ document: Document) -> [String : Any] {
        // Creating document dictionary
        let documentDict: [String : Any] = [
            "title": document.title,
            "type": document.template.type,
            "contents": document.template.contents,
            "fields": createFieldsDictionary(document.template.fields),
            "last_modified": document.lastModified.timeIntervalSince1970
        ]
        
        // Returns document dictionary
        return documentDict
    }
    
    static func createFieldsDictionary(_ fields: [Field]) -> [String : [String : Any]] {
        // Creating field dictionary
        var fieldsDict: [String : [String : Any]] = [:]
        
        for field in fields {
            fieldsDict[field.key] = [
                "type": field.type,
                "order": field.order
            ]
            
            if field.type == "dict" {
                fieldsDict[field.key]!["value"] = self.createFieldsDictionary(field.value as! [Field])
            } else {
                fieldsDict[field.key]!["value"] = field.value
            }
        }
        
        // Returns fields dictionary
        return fieldsDict
    }
}
