//
//  TemplateFieldTableViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 01/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class TemplateFieldTableViewController: UITableViewController {
    
    var fields: [Field]?
    var navigationTitle: String?
    let sectionsBeforeFieldsSection = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.fields == nil {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateFieldTableViewController.viewDidLoad()")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        // Setting view controller title
        self.navigationItem.title = self.navigationTitle
    }
}


// MARK: - Table view data source
extension TemplateFieldTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Setting heights of all cells equal to the standard height of the UITableViewCell
        return UITableViewCell().frame.height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections: Int
        
        // Verifying if fields are multi-section
        if FieldServices.hasMultipleFieldSections(fields: self.fields!) {
            numberOfSections = self.sectionsBeforeFieldsSection + self.fields!.count
        } else {
            numberOfSections = self.sectionsBeforeFieldsSection + 1
        }
        
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionTitle: String?
        
        switch section {
            
        // First section doesn't have a header
        case 0:
            sectionTitle = nil
            
        // Other sections depends on case of multiple field sections
        default:
            
            // If fields are multi-section, then each of their keys are the headers
            if FieldServices.hasMultipleFieldSections(fields: self.fields!) {
                sectionTitle = self.fields![section-self.sectionsBeforeFieldsSection].key
                
            // If fields are single-section, there's no header
            } else {
                sectionTitle = nil
            }
        }
        
        return sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsInSection: Int
        
        switch section {
            
        // First section has a cell is for adding the template in the user's documents
        case 0:
            rowsInSection = 1
            
        // Other sections show fields and values
        default:
            if FieldServices.hasMultipleFieldSections(fields: self.fields!) {
                // Field keys are headers and their children are cells
                let sectionFields = self.fields![section-self.sectionsBeforeFieldsSection].value as! [Field]
                
                rowsInSection = sectionFields.count
            } else {
                // Every field is a cell
                rowsInSection = self.fields!.count
            }
        }
        
        return rowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        switch indexPath.section {
            
        // First section has a cell is for adding the template in the user's documents
        case 0:
            cell = CellFactory.addTemplateCell(tableView: tableView)
            
        // Other cells show fields and values
        default:
            // Shifting index path to discount sections before fields section
            let fieldIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - self.sectionsBeforeFieldsSection)
            
            // Getting field of cell on calculated index path
            let cellField = FieldServices.getField(fields: self.fields!, cellForRowAt: fieldIndexPath)
            
            // Returning cell
            cell = CellFactory.templateFieldCell(tableView: tableView, field: cellField)
            
        }
        
        return cell
    }
    
}


// MARK: - Table view delegate
extension TemplateFieldTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselecting the selected cell
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
            
        // First section has a cell is for adding the template in the user's documents
        case 0:
            // Adding template to user's documents
            let template = TemplateServices.getTemplate(self)
            TemplateServices.handleAddingTemplateToUserDocuments(template: template, viewController: self)
            return
            
        // Other sections will display the fields of the document
        default:
            // Shifting index path to discount sections before fields section
            let fieldIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - self.sectionsBeforeFieldsSection)
            
            // Getting field of cell on calculated index path
            let cellField = FieldServices.getField(fields: self.fields!, cellForRowAt: fieldIndexPath)
            
            switch cellField.type {
                
            // .dict: open cell's field view controller
            case .dict:
                self.goToTemplateFieldTableViewController(field: cellField)
                
            // .string: goes to add template button on top of the screen
            case .string:
                self.tableView.scrollToTop()
                
            }
            
        }
    }
    
}


// Handling segues and pushing view controllers
extension TemplateFieldTableViewController {
    
    /// Goes to selected field view controller
    func goToTemplateFieldTableViewController(field: Field) {
        let templateFieldVC = ViewControllerFactory.instantiateViewController(ofType: .templateField) as! TemplateFieldTableViewController
        
        templateFieldVC.fields = (field.value as! [Field])
        templateFieldVC.navigationTitle = field.key
        
        self.navigationController?.pushViewController(templateFieldVC, animated: true)
    }
    
}
