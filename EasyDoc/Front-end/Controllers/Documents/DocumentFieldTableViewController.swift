//
//  DocumentFieldTableViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 01/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class DocumentFieldTableViewController: UITableViewController {
    
    var fields: [Field]?
    var navigationTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.fields == nil {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentFieldTableViewController.viewDidLoad()")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        // Setting view controller title
        self.navigationItem.title = self.navigationTitle
    }
}


// MARK: - Table view data source
extension DocumentFieldTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Setting heights of all cells equal to the standard height of the UITableViewCell
        return UITableViewCell().frame.height
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var numberOfSections: Int
        
        // Verifying if fields are multi-section
        if FieldServices.hasMultipleFieldSections(fields: self.fields!) {
            numberOfSections = self.fields!.count
        } else {
            numberOfSections = 1
        }
        
        return numberOfSections
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle: String?
        
        // If fields are multi-section, then each of their keys are the headers
        if FieldServices.hasMultipleFieldSections(fields: self.fields!) {
            sectionTitle = self.fields![section].key
            
        // If fields are single-section, there's no header
        } else {
            sectionTitle = nil
        }
            
        return sectionTitle
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsInSection: Int
        
        if FieldServices.hasMultipleFieldSections(fields: self.fields!) {
            // Field keys are headers and their children are cells
            let sectionFields = self.fields![section].value as! [Field]
            
            rowsInSection = sectionFields.count
        } else {
            // Every field is a cell
            rowsInSection = self.fields!.count
        }
        
        return rowsInSection
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        // Getting field corresponding to wanted cell
        let cellField = FieldServices.getField(fields: self.fields!, cellForRowAt: indexPath)
        
        switch cellField.type {
            
        // .dict: return document dict cell
        case .dict:
            cell = CellFactory.documentFieldDictCell(tableView: tableView, title: cellField.key)
            
        // .string: return document string cell
        case .string:
            cell = CellFactory.documentFieldStringCell(tableView: tableView, title: cellField.key, detail: cellField.value as? String)
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselecting the selected cell
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // Getting field corresponding to wanted cell
        let cellField = FieldServices.getField(fields: self.fields!, cellForRowAt: indexPath)
        
        switch cellField.type {
        
        // .dict: open cell's field view controller
        case .dict:
            self.goToDocumentFieldTableViewController(field: self.fields![indexPath.row])
            
        // .string: open alert to fill field
        case .string:
            self.openFillingFieldAlert(field: self.fields![indexPath.row])
            
        }
    }
    
}


// Handling segues and pushing view controllers
extension DocumentFieldTableViewController {
    
    /// Goes to selected field's view controller
    func goToDocumentFieldTableViewController(field: Field) {
        
        let documentFieldVC = ViewControllerFactory.instantiateViewController(ofType: .documentField) as! DocumentFieldTableViewController
        
        documentFieldVC.fields = (field.value as! [Field])
        documentFieldVC.navigationTitle = field.key
        
        self.navigationController?.pushViewController(documentFieldVC, animated: true)
    }
    
}


// Handling alerts/textfields
extension DocumentFieldTableViewController {
    
    /// Opens alert for filling the field's value
    func openFillingFieldAlert(field: Field) {
        
        // Tries to fill field using an alert with textfield
        FieldServices.displayFillingFieldAlert(field: field, viewController: self) {
            (success) in
            
            if !success {
                self.handleSettingFieldError()
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
}


// Handling errors
extension DocumentFieldTableViewController {
    
    /// Handles setting value error and presents it to the user
    func handleSettingFieldError() {
        
        // Displays error from unsuccessfully setting a field with a value
        FieldServices.displaySettingFieldErrorAlert(viewController: self, completionHandler: nil)
    }
}
