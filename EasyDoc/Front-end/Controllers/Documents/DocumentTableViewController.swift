//
//  DocumentViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class DocumentTableViewController: UITableViewController {
    
    var document: Document?
    let sectionsBeforeFieldsSection = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Verifying if document is not nil
        guard self.document != nil else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentTableViewController.viewDidLoad()")
            self.handlesDocumentNilError()
            return
        }
        
        // Setting view controller title
        self.navigationItem.title = self.document!.title
    }
}


// MARK: - Table view data source
extension DocumentTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Setting heights of all cells equal to the standard height of the UITableViewCell
        return UITableViewCell().frame.height
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        let numberOfSections: Int
        
        // Verifying if fields are multi-section
        if FieldServices.hasMultipleFieldSections(fields: self.document!.template.fields) {
            numberOfSections = self.sectionsBeforeFieldsSection + self.document!.template.fields.count
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
            if FieldServices.hasMultipleFieldSections(fields: self.document!.template.fields) {
                return self.document!.template.fields[section-self.sectionsBeforeFieldsSection].key
            }
            
            // If fields are single-section, then enter with generic string as section title
            sectionTitle = "Dados do contrato"
        }
        
        return sectionTitle
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsInSection: Int
        
        switch section {
            
        // First section has a cell that shows the document's contents
        case 0:
            rowsInSection = 1
            
        // Other sections show fields and values
        default:
            
            if FieldServices.hasMultipleFieldSections(fields: self.document!.template.fields) {
                // Field keys are headers and their children are cells
                let sectionFields = self.document!.template.fields[section-self.sectionsBeforeFieldsSection].value as! [Field]
                
                rowsInSection = sectionFields.count
                
            } else {
                // Every field is a cell
                rowsInSection = self.document!.template.fields.count
            }
        }
        
        return rowsInSection
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        switch indexPath.section {
            
        // First section has a cell that shows the document's contents
        case 0:
            cell = CellFactory.viewDocumentContentsCell(tableView: tableView)
            
        // Other cells show fields and values
        default:
            // Shifting index path to discount sections before fields section
            let fieldIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - self.sectionsBeforeFieldsSection)
            
            // Getting field of cell on calculated index path
            let cellField = FieldServices.getField(fields: self.document!.template.fields, cellForRowAt: fieldIndexPath)
            
            // Returning cell
            cell = CellFactory.documentFieldCell(tableView: tableView, field: cellField)
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselecting the selected cell
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
            
        // First section has a cell that shows the document's contents
        case 0:
            self.goToDocumentContentsViewController()
            
        // Other sections show fields and values
        default:
            
            // Shifting index path to discount sections before fields section
            let fieldIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - self.sectionsBeforeFieldsSection)
            
            // Getting field of cell on calculated index path
            let cellField = FieldServices.getField(fields: self.document!.template.fields, cellForRowAt: fieldIndexPath)
            
            switch cellField.type {
            
            // .dict: open cell's field view controller
            case .dict:
                self.goToDocumentFieldTableViewController(field: cellField)
                
            // .string: open alert to fill field
            case .string:
                self.openFillingFieldAlert(field: cellField)
                
            }
        }
        
        return
    }
    
}


// Handling segues and pushing view controllers
extension DocumentTableViewController {
    
    /// Presents to the user the view of the document's content
    func goToDocumentContentsViewController() {
        
        let documentContentsVC = ViewControllerFactory.instantiateViewController(ofType: .documentContents) as! DocumentContentsViewController
        
        documentContentsVC.document = self.document
        
        self.navigationController?.pushViewController(documentContentsVC, animated: true)
    }
    
    
    /// Goes to selected field's view controller
    func goToDocumentFieldTableViewController(field: Field) {
        
        let documentFieldVC = ViewControllerFactory.instantiateViewController(ofType: .documentField) as! DocumentFieldTableViewController
        
        documentFieldVC.fields = (field.value as! [Field])
        documentFieldVC.navigationTitle = field.key
        
        self.navigationController?.pushViewController(documentFieldVC, animated: true)
    }
    
}


// Handling alerts/textfields
extension DocumentTableViewController {
    
    @IBAction func editButtonPressed(_ sender: Any) {
        // Creating alert
        let editButtonAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Creating renaming action
        let renameAction = UIAlertAction(title: "Renomear documento", style: .default) {
            _ in
            
            self.presentRenameAlert()
        }
        
        // Creating cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        editButtonAlert.addAction(renameAction)
        editButtonAlert.addAction(cancelAction)
        
        // Presenting alert
        self.present(editButtonAlert, animated: true, completion: nil)
    }
    
    
    /// Presents alert for renaming document's title
    func presentRenameAlert() {
        // Creating the alert controller
        let alert = UIAlertController(title: "Insira o novo título do documento", message: nil, preferredStyle: .alert)
        
        // Adding the text field
        alert.addTextField {
            (textField) in
            
            textField.autocapitalizationType = .sentences
            textField.placeholder = "Título do documento"
            textField.text = self.document!.title
        }
        
        // Grabbing the value from the text field when the user clicks OK
        let setValueAction = UIAlertAction(title: "OK", style: .default) {
            _ in
            
            // Force unwrapping because we know it exists
            let textField = alert.textFields![0]
            
            guard let text = textField.text, text != "" else {
                print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentTableViewController.presentRenameAlert()")
                return
            }
            
            // Trying to set title to document
            DocumentServices.setTitleToDocument(document: self.document!, title: text) {
                error in
                
                if error != nil {
                    self.handleSettingFieldError()
                    return
                }
                
                self.tableView.reloadData()
            }
        }
        
        // Creating cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Adding actions
        alert.addAction(cancelAction)
        alert.addAction(setValueAction)
        
        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
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
extension DocumentTableViewController {
    
    /// Handles document nil error and present it to user
    func handlesDocumentNilError() {
        
        // Reloading main user object completely
        UserServices.reloadMainUser() {
            (fetchingError) in
            
            if let error = fetchingError {
                print(error.description)
                return
            }
        }
        
        // Creating and presenting alert
        let alert = UIAlertController(title: "Erro ao carregar documento", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) {
            _ in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// Handles setting field value error and presents it to the user
    func handleSettingFieldError() {
        
        // Displays error from unsuccessfully setting a field with a value
        FieldServices.displaySettingFieldErrorAlert(viewController: self, completionHandler: nil)
    }
}
