//
//  FieldServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 03/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import UIKit

public enum FieldType: String {
    case dict = "dict"
    case string = "string"
}

class FieldServices {
    
    /// Returns if a field array has multiple sections in a table view
    static func hasMultipleFieldSections(fields: [Field]) -> Bool {
        
        // A field has multiple sections if every field in the "fields" array is of type "dict"
        for field in fields {
            if field.type != .dict {
                return false
            }
        }
        
        return true
    }
    
    
    /// Returns the field for certain index path 
    static func getTemplateField(fields: [Field], cellForRowAt indexPath: IndexPath) -> Field? {
        
        // First and second sections are for adding template to user's documents and visualizing the document, respectively
        if indexPath.section == 0 || indexPath.section == 1 {
            return nil
        }
        
        // Getting field according to the index path
        return self.getField(fields: fields, cellForRowAt: IndexPath(row: indexPath.row, section: indexPath.section - 1))
        
    }
    
    static func getDocumentField(fields: [Field], cellForRowAt indexPath: IndexPath) -> Field? {
        
        // First and second sections are for adding template to user's documents and visualizing the document, respectively
        if indexPath.section == 0 {
            return nil
        }
        
        // Getting field according to the index path
        return self.getField(fields: fields, cellForRowAt: IndexPath(row: indexPath.row, section: indexPath.section))
    }
    
    static func getField(fields: [Field], cellForRowAt indexPath: IndexPath) -> Field {
        
        let section = indexPath.section
        let row = indexPath.row
        
        // Checking case if fields have multiple sections
        if self.hasMultipleFieldSections(fields: fields) {
            // Getting fields of the determined section
            let sectionFields = fields[section].value as! [Field]
            // Getting field of the determined cell
            return sectionFields[row]
        }
        
        // If field has only one section
        return fields[row]
    }
    
}


// Handles alerts on viewcontrollers
extension FieldServices {
    
    /// Handles filling field alert
    static func displayFillingFieldAlert(field: Field, viewController: UIViewController, completionHandler: @escaping (Bool) -> Void) {
        
        // Creating the alert controller
        let alert = UIAlertController(title: field.key, message: "Insira o valor abaixo", preferredStyle: .alert)
        
        // Adding the text field
        alert.addTextField {
            (textField) in
            
            textField.autocapitalizationType = .sentences
            textField.placeholder = field.key
            textField.text = (field.value as! String)
        }
        
        // Grabbing the value from the text field when the user clicks OK
        let settingValueAction = UIAlertAction(title: "OK", style: .default) {
            _ in
            
            // Force unwrapping because we know it exists
            let text = alert.textFields![0].text!
            
            // Setting value to field
            DocumentServices.setValueToField(field: field, value: text) {
                error in
                
                if error != nil {
                    completionHandler(false)
                    return
                }
                
                completionHandler(true)
            }
        }
        
        // Creating cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Adding actions
        alert.addAction(cancelAction)
        alert.addAction(settingValueAction)
        
        // Presenting the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    /// Displays error from unsuccessfully setting a field with a value
    static func displaySettingFieldErrorAlert(viewController: UIViewController, completionHandler: (() -> Void)?) {
        
        // Creating alert
        let alert = UIAlertController(title: "Erro ao definir valor", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
        
        // Creating and adding "OK" action
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            _ in
            
            if completionHandler != nil {
                completionHandler!()
            }
        }
        
        alert.addAction(okAction)
        
        // Presenting the alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
