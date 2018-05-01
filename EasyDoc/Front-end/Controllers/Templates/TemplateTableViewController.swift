//
//  TemplateTableViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 31/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class TemplateTableViewController: UITableViewController {

    var template: Template?
    let sectionsBeforeFieldsSection = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Verifying if template is not nil
        guard self.template != nil else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateTableViewController.viewDidLoad()")
            self.handlesTemplateNilError()
            return
        }
        
        // Setting view controller title
        self.navigationItem.title = template!.type
    }
}


// MARK: - Table view data source
extension TemplateTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Setting heights of all cells equal to the standard height of the UITableViewCell
        return UITableViewCell().frame.height
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        let numberOfSections: Int
        
        // Verifying if fields are multi-section
        if FieldServices.hasMultipleFieldSections(fields: self.template!.fields) {
            numberOfSections = self.sectionsBeforeFieldsSection + self.template!.fields.count
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
            
        // Second section doesn't have a header
        case 1:
            sectionTitle = nil
            
        // Other sections depends on case of multiple field sections
        default:
            
            // If fields are multi-section, then each of their keys are the headers
            if FieldServices.hasMultipleFieldSections(fields: self.template!.fields) {
                sectionTitle = self.template!.fields[section-self.sectionsBeforeFieldsSection].key
            } else {
                // If fields are single-section, then enter with generic string as section title
                sectionTitle = "Dados do contrato"
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
            
        // Second section has a cell that shows the template's contents
        case 1:
            rowsInSection = 1
            
        // Other sections show fields and values
        default:
            if FieldServices.hasMultipleFieldSections(fields: self.template!.fields) {
                // Field keys are headers and their children are cells
                let sectionFields = self.template!.fields[section-self.sectionsBeforeFieldsSection].value as! [Field]
                
                rowsInSection = sectionFields.count
            } else {
                // Every field is a cell
                rowsInSection = self.template!.fields.count
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
            
        // Second section has a cell that shows the template's contents
        case 1:
            cell = CellFactory.viewTemplateContentsCell(tableView: tableView)
            
        // Other cells show fields and values
        default:
            // Shifting index path to discount sections before fields section
            let fieldIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - self.sectionsBeforeFieldsSection)
            
            // Getting field of cell on calculated index path
            let cellField = FieldServices.getField(fields: self.template!.fields, cellForRowAt: fieldIndexPath)
            
            // Returning cell
            cell = CellFactory.templateFieldCell(tableView: tableView, field: cellField)
            
        }
        
        return cell
    }

}


// MARK: - Table view delegate
extension TemplateTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselecting the selected cell
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
            
        // First section has a cell is for adding the template in the user's documents
        case 0:
            TemplateServices.handleAddingTemplateToUserDocuments(template: self.template!, viewController: self)
            return
            
        // Second section has a cell that shows the template's contents
        case 1:
            self.goToTemplateContentsViewController()
            return
            
        // Other sections will display the fields of the document
        default:
            // Shifting index path to discount sections before fields section
            let fieldIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - self.sectionsBeforeFieldsSection)
            
            // Getting field of cell on calculated index path
            let cellField = FieldServices.getField(fields: self.template!.fields, cellForRowAt: fieldIndexPath)
            
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
extension TemplateTableViewController {
    
    /// Presents to the user the view of the template's content
    func goToTemplateContentsViewController() {
        
        let templateContentVC = ViewControllerFactory.instantiateViewController(ofType: .templateContents) as! TemplateContentsViewController
        
        templateContentVC.template = self.template
        
        self.navigationController?.pushViewController(templateContentVC, animated: true)
    }
    
    
    /// Goes to selected field's view controller
    func goToTemplateFieldTableViewController(field: Field) {
        
        let templateFieldVC = ViewControllerFactory.instantiateViewController(ofType: .templateField) as! TemplateFieldTableViewController
        
        templateFieldVC.fields = (field.value as! [Field])
        templateFieldVC.navigationTitle = field.key
        
        self.navigationController?.pushViewController(templateFieldVC, animated: true)
    }
    
}


// Handling errors
extension TemplateTableViewController {
    
    /// Handles template nil error and present it to user
    func handlesTemplateNilError() {
        
        // Reloading templates completely
        AppShared.isLoadingTemplates.value = true
        TemplateServices.loadTemplates() {
            (fetchingError) in
            
            if let error = fetchingError {
                print(error.description)
                return
            }
        }
        
        // Creating and presenting alert
        let alert = UIAlertController(title: "Erro ao carregar template", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            _ in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
