//
//  ParseDocument.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 02/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class DocumentParser {
    
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
    
    
    /// Create fields dictionary from given field array
    static func createFieldsDictionary(_ fields: [Field]) -> [String : [String : Any]] {
        // Creating field dictionary
        var fieldsDict: [String : [String : Any]] = [:]
        
        for field in fields {
            fieldsDict[field.key] = [
                "type": field.type.rawValue,
                "order": field.order
            ]
            
            switch field.type {
                
            case .dict:
                fieldsDict[field.key]!["value"] = self.createFieldsDictionary(field.value as! [Field])
                
            case .string:
                fieldsDict[field.key]!["value"] = field.value
                
            }
        }
        
        // Returns fields dictionary
        return fieldsDict
    }
    
    
    /// Parse given dictionary of fields an array of fields of fields.
    static func parseFields(_ fieldsDict: [String : [String : Any]], path: String) -> [Field]? {
        var fields = [Field?](repeating: nil, count: fieldsDict.count)
        
        // Parsing each field
        for fieldDict in fieldsDict {
            
            // Reading field's key, type and order
            let key = fieldDict.key
            let fieldPath = path + "/" + key + "/value"
            
            guard let typeString = fieldDict.value["type"] as? String,
                  let order = fieldDict.value["order"] as? Int else {
                    return nil
            }
            
            if fields[order] != nil {
                print("-> BIG WARNING: Error in the database - 2 fields have the same order in the document")
                return nil
            }
            
            // Parsing field's value
            switch typeString {
                
            // Reading field type as .dict
            case FieldType.dict.rawValue:
                guard let valueDict = fieldDict.value["value"] as? [String : [String : Any]],
                      let value = self.parseFields(valueDict, path: fieldPath)
                    else {
                        return nil
                }
                
                fields[order] = Field(key: key, value: value, type: FieldType.dict, order: order, path: fieldPath)
                
            // Reading field type as .string
            case FieldType.string.rawValue:
                guard let value = fieldDict.value["value"] else {
                    return nil
                }
                
                fields[order] = Field(key: key, value: value, type: FieldType.string, order: order, path: fieldPath)
                
            default:
                print("-> WARNING: @ ParseDocument.parseFields()")
                
            }
            
        }
        
        // Returning array of fields
        return fields as? [Field]
    }
    
}
