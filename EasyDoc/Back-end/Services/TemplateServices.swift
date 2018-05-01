//
//  TemplateServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import UIKit


class TemplateServices {
    
}


// Performs online services
extension TemplateServices {
    
    /// Loads Template list fetched from database into AppShared.templates.
    /// Note: It is extremely important for the developer to set AppShared.isLoadingTemplates.value = true before calling this method.
    static func loadTemplates(completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Tries to fetch main user object from EasyDoc's Database
        TemplatePersistence.fetchTemplates() {
            (templatesFetched, fetchingError) in
            
            // Verifying possible errors
            if let error = fetchingError {
                DispatchQueue.main.async {
                    // Not loading user anymore
                    AppShared.isLoadingTemplates.value = false
                }

                completionHandler(error)
                return
            }
            
            // Gettings templates
            guard let templates = templatesFetched else {
                DispatchQueue.main.async {
                    // Not loading user anymore
                    AppShared.isLoadingTemplates.value = false
                }

                completionHandler(EasyDocGeneralError.unexpectedError)
                return
            }
            
            // Setting templates
            AppShared.templates = templates

            DispatchQueue.main.async {
                // Not loading user anymore
                AppShared.isLoadingTemplates.value = false
            }
            
            completionHandler(nil)
        }
    }
    
    
    /// Adds a given template with title to the main user in-app and into EasyDoc's database
    static func addTemplateToUserDocuments(_ template: Template, title: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Creating new document object
        let newDocument = Document(autoID: nil, title: title, template: template, lastModified: Date())
        
        // Adding document to user
        DocumentServices.addDocumentToUser(newDocument) {
            addingError in
            
            if let error = addingError {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    
    /// Returns the template's contents with blank fields replaced with "_____"
    static func readContents(template: Template) -> String? {
        
        var readableContents = template.contents
        var searchStartIndex = readableContents.startIndex
        
        // Replacing every empty field value with "____"
        while let fieldPathStartRange = readableContents.range(of: "[", range: searchStartIndex..<readableContents.endIndex) {
            
            guard let fieldPathEndRange = readableContents.range(of: "]", range: fieldPathStartRange.upperBound..<readableContents.endIndex) else {
                print("-> WARNING: EasyDocQueryError.databaseObject @ Template.readContents()")
                return nil
            }
            
            // Getting range to be replaced
            let replaceRange = fieldPathStartRange.lowerBound..<fieldPathEndRange.upperBound
            
            // Replacing field path with the replaceString
            let replaceString = "_____"
            
            readableContents.replaceSubrange(replaceRange, with: replaceString)
            
            // Reseting search start index
            searchStartIndex = readableContents.index(fieldPathStartRange.lowerBound, offsetBy: replaceString.count)
        }
        
        return readableContents
    }
    
}


// Handles alerts and actions when adding a template to the user's documents
extension TemplateServices {
    
    /// Adds template to user documents (in-app and database).
    static func handleAddingTemplateToUserDocuments(template: Template, viewController: UIViewController) {
        
        self.displayAddTemplateToUserDocumentsAlert(template: template, viewController: viewController) {
            success in
            
            // Verifying error case
            guard success else {
                self.displayAddingDocumentError(viewController: viewController, completionHandler: nil)
                return
            }
            
            // Handling success case
            self.displayAddingDocumentSuccess(viewController: viewController) {

               // Pops to root view controller of navigation controller
                viewController.navigationController?.popToRootViewController(animated: true)

                // Performing segue
                viewController.performSegue(withIdentifier: SegueIds.unwindToDocuments.rawValue, sender: nil)
            }
        }
        
    }
    
    /// Display alert for adding the selected template to the user's document
    static func displayAddTemplateToUserDocumentsAlert(template: Template, viewController: UIViewController, completionHandler: @escaping (Bool) -> Void) {
        
        // Creating the alert controller
        let alert = UIAlertController(title: "Insira um título para seu novo documento", message: nil, preferredStyle: .alert)
        
        // Adding the text field
        alert.addTextField {
            (textField) in
            
            textField.autocapitalizationType = .sentences
            textField.placeholder = "Título do documento"
        }
        
        // Grabbing the value from the text field and saving the new document to the database and in-app when the user clicks OK
        let addDocumentAction = UIAlertAction(title: "OK", style: .default) {
            _ in
            
            // Force unwrapping because we know it exists
            let documentTitle = alert.textFields![0].text!
            
            guard documentTitle != "" else {
                print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentTableViewController.openFillingFieldAlert()")
                completionHandler(false)
                return
            }
            
            // Trying to add the template to the main user's documents
            self.addTemplateToUserDocuments(template, title: documentTitle) {
                addingError in
                
                if addingError != nil {
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
        alert.addAction(addDocumentAction)
        
        // Presenting the alert
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    
    /// Displays alert to show user that the template was successfully added to the user documents
    static func displayAddingDocumentSuccess(viewController: UIViewController, completionHandler: @escaping (() -> Void)) {
        
        // Creating the alert
        let alert = UIAlertController(title: "O template foi adicionado com sucesso aos seus documentos!", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) {
            _ in
            
            completionHandler()
            
        }
        
        alert.addAction(okAction)
        
        // Presenting the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    /// Displays alert to show user that there was an error when trying to add the template to the user documents
    static func displayAddingDocumentError(viewController: UIViewController, completionHandler: (() -> Void)?) {
        
        // Creating the alert
        let alert = UIAlertController(title: "Erro ao adicionar template", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) {
            _ in
            
            if completionHandler != nil {
                completionHandler!()
            }
        }
        
        alert.addAction(okAction)
        
        // Presenting the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Returns template from parents' view controller
    static func getTemplate(_ fieldViewController: TemplateFieldTableViewController) -> Template {
        
        // Getting list of view controllers from navigation controller
        let viewControllers = fieldViewController.navigationController!.viewControllers
        
        // Getting index of last view controller in the navigation controller's hierarchy
        var i = viewControllers.count-1
        
        while let _ = viewControllers[i] as? TemplateFieldTableViewController {
            i -= 1
        }
        
        // Instantiating template view controller
        let templateVC = viewControllers[i] as! TemplateTableViewController
        
        // Returning template
        return templateVC.template!
    }
    
}
