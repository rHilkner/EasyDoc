//
//  Document.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class Document {
    var autoID: String?
    var title: String
    var type: String
    var contents: String
    var fields: [Field]
    var lastModified: Date
    
    init(autoID: String?, title: String, type: String, content: String, fields: [Field], lastModified: Date) {
        self.autoID = autoID
        self.title = title
        self.type = type
        self.contents = content
        self.fields = fields
        self.lastModified = lastModified
    }
    
    
    /// Replace blank fields of the document's contents with it's value or with "_____" if value is nil
    func readContentsWithValues() -> String? {
        
        var readableContents = self.contents
        
        // Getting all occurrences of "[" and "]"
        let indicesInitial = readableContents.indicesOf(string: "[")
        let indicesFinal = readableContents.indicesOf(string: "]")
        
        guard indicesInitial.count == indicesFinal.count else {
            print("-> WARNING: EasyDocQueryError.databaseObject @ Template.readContents()")
            return nil
        }
        
        // offset holds how many characters in total the text lost with the replacing
        var offset = 0
        
        // Replacing every empty field value with "____"
        for i in 0..<indicesInitial.count {
            
            // Getting the path string
            let pathInitialIndex = readableContents.index(readableContents.startIndex, offsetBy: indicesInitial[i] + offset + 1)
            let pathFinalIndex = readableContents.index(readableContents.startIndex, offsetBy: indicesFinal[i] + offset)
            
            let path = String(readableContents[pathInitialIndex..<pathFinalIndex])
            
            // Getting the field value
            let value = self.fieldValue(path: path)
            
            // Getting range to be replaced
            let replaceInitialIndex = readableContents.index(readableContents.startIndex, offsetBy: indicesInitial[i] + offset)
            let replaceFinalIndex = readableContents.index(readableContents.startIndex, offsetBy: indicesFinal[i] + offset + 1)
            let replaceRange = replaceInitialIndex..<replaceFinalIndex
            
            // Replacing field with value
            if value != "" {
                offset += value.count - readableContents.distance(from: replaceInitialIndex, to: replaceFinalIndex)
                readableContents.replaceSubrange(replaceRange, with: value)
            } else {
                offset += 5 - readableContents.distance(from: replaceInitialIndex, to: replaceFinalIndex)
                readableContents.replaceSubrange(replaceRange, with: "_____")
            }
        }
        
        return readableContents
    }
    
    
    /// Finds the value of the field of given path.
    func fieldValue(path: String) -> String {
        
        let separatorIndices = path.indicesOf(string: "/")
        var fields = self.fields
        
        for i in 0..<separatorIndices.count-1 {
            // Getting key string from path
            let keyInitialIndex = path.index(path.startIndex, offsetBy: separatorIndices[i] + 1)
            let keyFinalIndex = path.index(path.startIndex, offsetBy: separatorIndices[i+1])
            
            let key = String(path[keyInitialIndex..<keyFinalIndex])
            
            // Getting next key of the path
            for field in fields {
                if field.key == key {
                    // Reseting fields array
                    fields = field.value as! [Field]
                    break
                }
            }
        }
        
        // Getting last key
        let keyInitialIndex = path.index(path.startIndex, offsetBy: separatorIndices[separatorIndices.count-1] + 1)
        
        let key = String(path[keyInitialIndex...])
        
        // Finding field with determined key
        for field in fields {
            if field.key == key {
                return field.value as! String
            }
        }
        
        return ""
    }
    
}
