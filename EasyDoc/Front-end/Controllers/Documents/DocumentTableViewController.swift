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

    override func viewDidLoad() {
        super.viewDidLoad()

        //Verifying if document is not nil
        guard self.document != nil else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentTableViewController.viewDidLoad()")
            self.handlesDocumentNilError()
            return
        }
        
        // Loading view controller
        self.loadViewController()
    }
    
    
    /// Loads content of the view controller
    func loadViewController() {
        self.navigationItem.title = self.document!.title
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        // Creating alert
        let renameAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Creating renaming action
        let renameAction = UIAlertAction(title: "Renomear documento", style: .default) {
            _ in
            
            self.presentRenameAlert()
        }
        
        // Creating cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        renameAlert.addAction(renameAction)
        renameAlert.addAction(cancelAction)
        
        // Presenting alert
        self.present(renameAlert, animated: true, completion: nil)
    }
}


// MARK: - Table view data source
extension DocumentTableViewController {
    
    /// Returns the number of sections the template table view will have. The first is a cell for the visualization of the template; the rest are for the fields of the template.
    func sectionCount() -> Int {
        
        // If all fields are of the type "dict", then they're all sections and the fields nested to each of their values are the cells of that section; else the fields are all cells
        for field in self.document!.template.fields {
            if field.type != "dict" {
                return 2
            }
        }
        
        return self.document!.template.fields.count + 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionCount()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // First section is a cell for the visualization of the document
        if section == 0 {
            return 1
        }
        
        // If number of sections is 2, then all fields of the document are gonna be cells
        if self.sectionCount() == 2 && section == 1 {
            return self.document!.template.fields.count
        }
        
        // If the number of sections is >2, then all fields are sections
        if self.sectionCount() > 2 {
            // Verifying casting error
            guard let sectionFields = self.document!.template.fields[section-1].value as? [Field] else {
                print("-> WARNING: EasyDocOfflineError.castingError @ DocumentTableViewController.tableView(numberOfRowsInSection)")
                return 0
            }
            
            return sectionFields.count
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        // If section is the first one, return DocumentCellWithDisclosure
        if section == 0 {
            let cell = CellFactory.documentCell(tableView: tableView, type: .withDisclosure) as! DocumentDisclosureTableViewCell
            
            cell.titleLabel.text = "Visualizar documento"
            return cell
        }
        
        // If number of sections is 1, then all fields of the document are gonna be cells
        if self.sectionCount() == 2 {
            let cellField = self.document!.template.fields[row]
            
            // Verifying which type of cell we need to cast
            if cellField.type == "dict" {
                let cell = CellFactory.documentCell(tableView: tableView, type: .withDisclosure) as! DocumentDisclosureTableViewCell
                
                cell.titleLabel.text = cellField.key
                
                return cell
                
            } else {
                let cell = CellFactory.documentCell(tableView: tableView, type: .withDetail) as! DocumentDetailTableViewCell
                
                cell.titleLabel.text = cellField.key
                
                if let cellValue = cellField.value as? String, cellValue != "" {
                    cell.detailLabel.text = cellValue
                } else {
                    cell.detailLabel.text = "-"
                }
                
                return cell
            }
        }
        
        // Getting fields of the determined section
        guard let sectionFields = self.document!.template.fields[section-1].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ DocumentTableViewController.tableView(titleForHeaderInSection)")
            return UITableViewCell()
        }
        
        // Getting field of the determined cell
        let cellField = sectionFields[row]
        
        // Verifying which type of cell we need to cast
        if cellField.type == "dict" {
            let cell = CellFactory.documentCell(tableView: tableView, type: .withDisclosure) as! DocumentDisclosureTableViewCell
            
            cell.titleLabel.text = cellField.key
            
            return cell
            
        } else {
            let cell = CellFactory.documentCell(tableView: tableView, type: .withDetail) as! DocumentDetailTableViewCell
            
            cell.titleLabel.text = cellField.key
            
            if let cellValue = cellField.value as? String, cellValue != "" {
                cell.detailLabel.text = cellValue
            } else {
                cell.detailLabel.text = "-"
            }
            
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // First section doesn't have header
        if section == 0 {
            return nil
        }
        
        // If there's only one section for the presentation of the fields, then set their header with a generic string
        if self.sectionCount() == 2 && section == 1 {
            return "Dados do contrato"
        }
        
        // Else, set the headers as the key of the field of the template
        return self.document!.template.fields[section-1].key
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Setting heights of all cells equal to the standard height of the UITableViewCell
        return UITableViewCell().frame.height
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselecting the selected cell
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // Getting section and row values
        let section = indexPath.section
        let row = indexPath.row
        
        // First section must show to the user the template contents
        if section == 0 {
            self.goToDocumentContentsViewController()
            return
        }
        
        // If sectionCount() == 2, then if the selected cell is a dictionary, then show that field's view controller; else open alert to fill it's value
        if self.sectionCount() == 2 {
            if self.document!.template.fields[row].type == "dict" {
                self.goToDocumentFieldTableViewController(field: self.document!.template.fields[row])
            } else {
                self.openFillingFieldAlert(field: self.document!.template.fields[row])
            }
            
            return
        }
        
        // Getting the field list of the determined section
        guard let sectionFields = self.document!.template.fields[section-1].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ DocumentTableViewController.tableView(didSelectRowAt)")
            return
        }
        
        // Getting the field of the selected cell
        let cellField = sectionFields[row]
        
        // If the selected cell is a dictionary, then open this field's view controller
        if cellField.type == "dict" {
            self.goToDocumentFieldTableViewController(field: cellField)
            
        // Else, open alert to fill it's value
        } else {
            self.openFillingFieldAlert(field: cellField)
        }
    }
    
}


extension DocumentTableViewController {
    
    /// Presents to the user the view of the template's content
    func goToDocumentContentsViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let documentContentsViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentContentsViewController") as? DocumentContentsViewController else {
            print("-> WARNING: EasyDocOfflineError.castingError @ DocumentTableViewController.goToDocumentContentsViewController()")
            return
        }
        
        documentContentsViewController.document = self.document
        self.navigationController?.pushViewController(documentContentsViewController, animated: true)
    }
    
    
    /// Presents to the user the view controller of a field
    func goToDocumentFieldTableViewController(field: Field) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let documentFieldTableViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentFieldTableViewController") as? DocumentFieldTableViewController else {
            print("-> WARNING: EasyDocOfflineError.castingError @ DocumentTableViewController.goToDocumentFieldTableViewController()")
            return
        }
        
        documentFieldTableViewController.field = field
            
        self.navigationController?.pushViewController(documentFieldTableViewController, animated: true)
    }
    
    
    /// Presents alert for renaming document's title
    func presentRenameAlert() {
        // Creating the alert controller
        let alert = UIAlertController(title: "Insira o novo título do documento.", message: nil, preferredStyle: .alert)
        
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
            
            let textField = alert.textFields![0] // Force unwrapping because we know it exists
            
            guard let text = textField.text, text != "" else {
                print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentTableViewController.presentRenameAlert()")
                return
            }
            
            DocumentServices.setTitleToDocument(document: self.document!, title: text) {                error in
                
                if error != nil {
                    self.handleSettingValueError()
                    return
                }
                
                self.loadViewController()
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
            
            let textField = alert.textFields![0] // Force unwrapping because we know it exists
            
            guard let text = textField.text, text != "" else {
                print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentTableViewController.openFillingFieldAlert()")
                return
            }
            
            DocumentServices.setValueToField(field: field, value: text) {
                error in
                
                if error != nil {
                    self.handleSettingValueError()
                    return
                }
                
                self.tableView.reloadData()
            }
        }
        
        // Creating cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Adding actions
        alert.addAction(cancelAction)
        alert.addAction(settingValueAction)
        
        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }
}


extension DocumentTableViewController {
    
    /// Handles document nil error and present it to user.
    func handlesDocumentNilError() {
        
        // Reloading main user object completely
        FetchingServices.reloadMainUser() {
            (fetchingError) in
            
            if let error = fetchingError {
                print(error.errorDescription)
                return
            }
        }
        
        // Creating and presenting alert
        let alert = UIAlertController(title: "Erro ao carregar documento", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            _ in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// Handles setting value error and presents it to the user
    func handleSettingValueError() {
        
        // Creating and presenting alert
        let alert = UIAlertController(title: "Erro ao definir valor", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
