//
//  TemplateParser.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 02/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class TemplateParser {
    
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
        return DocumentParser.parseFields(fieldsDict, path: path)
    }
    
}
