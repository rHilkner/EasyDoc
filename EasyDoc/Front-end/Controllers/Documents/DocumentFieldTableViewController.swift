//
//  DocumentFieldTableViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 01/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class DocumentFieldTableViewController: UITableViewController {
    
    var field: Field?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.field == nil {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentFieldTableViewController.viewDidLoad()")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.loadViewController()
    }
    
    func loadViewController() {
        self.navigationItem.title = self.field!.key
    }
}


// MARK: - Table view data source
extension DocumentFieldTableViewController {
    
    func sectionCount() -> Int {
        guard let valueFields = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentFieldTableViewController.viewDidLoad()")
            return 0
        }
        
        for field in valueFields {
            if field.type != "dict" {
                return 1
            }
        }
        
        return valueFields.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionCount()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let valueFields = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentFieldTableViewController.viewDidLoad()")
            return 0
        }
        
        if self.sectionCount() == 1 {
            return valueFields.count
        }
        
        guard let sectionFields = valueFields[section].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ DocumentTableViewController.tableView(numberOfRowsInSection)")
            return 0
        }
        
        return sectionFields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        // Getting fields list from self.field.value
        guard let fieldsList = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentFieldTableViewController.viewDidLoad()")
            return UITableViewCell()
        }
        
        // If number of sections is 1, then all fields of the field are gonna be cells
        if self.sectionCount() == 1 {
            let cellField = fieldsList[row]
            
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
        guard let sectionFields = fieldsList[section].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ DocumentFieldTableViewController.tableView(cellForRowAt)")
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
        
        // If there's only one section for the presentation of the fields, then there's no section header
        if self.sectionCount() == 1 {
            return nil
        }
        
        // Else, set the headers as the key of the field of that index
        guard let valueFields = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentFieldTableViewController.viewDidLoad()")
            return nil
        }
        
        return valueFields[section].key
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
        
        // Getting fields from self.field.value
        guard let valueFields = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentFieldTableViewController.viewDidLoad()")
            return
        }
        
        // If there's only one section, the selected cell is self.fields[row]
        if self.sectionCount() == 1 {
            if valueFields[row].type == "dict" {
                self.goToDocumentFieldTableViewController(field: valueFields[row])
            } else {
                self.openFillingFieldAlert(field: valueFields[row])
            }
            
            return
        }
        
        // If there's more than one section, the selected cell is a field child of self.fields[section].value[row]
        guard let sectionFields = valueFields[section].value as? [Field] else {
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


extension DocumentFieldTableViewController {
    
    /// Goes to selected field view controller
    func goToDocumentFieldTableViewController(field: Field) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let documentFieldTableViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentFieldTableViewController") as? DocumentFieldTableViewController else {
            print("-> WARNING: EasyDocOfflineError.castingError @ DocumentTableViewController.goToDocumentFieldTableViewController()")
            return
        }
        
        documentFieldTableViewController.field = field
        
        self.navigationController?.pushViewController(documentFieldTableViewController, animated: true)
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
        
        alert.addAction(settingValueAction)
        
        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }
}


extension DocumentFieldTableViewController {
    
    /// Handles setting value error and presents it to the user
    func handleSettingValueError() {
        
        // Creating and presenting alert
        let alert = UIAlertController(title: "Erro ao definir valor", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
