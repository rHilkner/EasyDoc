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
    var pathToSave: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Verifying if template is not nil
        guard self.template != nil else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateTableViewController.viewDidLoad()")
            self.handlesTemplateNilError()
            return
        }
        
        // Loading view controller
        self.loadViewController()
    }
    
    
    /// Loads content of the view controller
    func loadViewController() {
        self.navigationItem.title = template!.type
    }
}


// MARK: - Table view data source
extension TemplateTableViewController {
    
    /// Returns the number of sections the template table view will have. The first is a cell for the visualization of the template; the last is a cell for adding the template to the user's documents; the rest are for the fields of the template.
    func sectionCount() -> Int {
        
        // If all fields are of the type "dict", then they're all sections and the fields nested to each of their values are the cells of that section; else the fields are all cells
        for field in self.template!.fields {
            if field.type != "dict" {
                return 3
            }
        }
        
        return self.template!.fields.count + 2
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionCount()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // First section is a cell for the visualization of the document
        if section == 0 {
            return 1
        }
        
        // Last section is a cell for adding the template to the user's documents
        if section == sectionCount()-1 {
            return 1
        }
        
        
        // If the number of sections is 3, then all fields of the template are gonna be cells
        if self.sectionCount() == 3 && section == 1 {
            return self.template!.fields.count
        }
        
        // If the number of sections is >3, then all fields are sections
        if self.sectionCount() > 3 {
            // Verifying casting error
            guard let sectionFields = self.template!.fields[section-1].value as? [Field] else {
                print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(numberOfRowsInSection)")
                return 0
            }
            
            // The number of cells of each section will be the number of fields of this section
            return sectionFields.count
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        // If section is the first one, return TemplateCellWithDisclosure
        if section == 0 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDisclosure") as? TemplateDisclosureTableViewCell else {
                print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(cellForRowAt)")
                return UITableViewCell()
            }
            
            cell.titleLabel.text = "Visualizar documento"
            return cell
        }
        
        // If section if the last one, return AddTemplateCell
        if section == self.sectionCount()-1 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddTemplateCell") as? AddTemplateTableViewCell else {
                print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(cellForRowAt)")
                return UITableViewCell()
            }
            
            return cell
        }
        
        // If number of sections is 1, then all fields of the document are gonna be cells
        if self.sectionCount() == 3 {
            let cellField = self.template!.fields[row]
            
            // Verifying which type of cell we need to cast
            if cellField.type == "dict" {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDisclosure") as? TemplateDisclosureTableViewCell else {
                    print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(cellForRowAt)")
                    return UITableViewCell()
                }
                
                cell.titleLabel.text = cellField.key
                
                return cell
                
            } else {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDetail") as? TemplateDetailTableViewCell else {
                    print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(cellForRowAt)")
                    return UITableViewCell()
                }
                
                cell.titleLabel.text = cellField.key
                cell.detailLabel.text = "-"
                
                return cell
            }
        }
        
        // Getting fields of the determined section
        guard let sectionFields = self.template!.fields[section-1].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(titleForHeaderInSection)")
            return UITableViewCell()
        }
        
        // Getting field of the determined cell
        let cellField = sectionFields[row]
        
        // Verifying which type of cell we need to cast
        if cellField.type == "dict" {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDisclosure") as? TemplateDisclosureTableViewCell else {
                print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(cellForRowAt)")
                return UITableViewCell()
            }
            
            cell.titleLabel.text = cellField.key
            
            return cell
            
        } else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDetail") as? TemplateDetailTableViewCell else {
                print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(cellForRowAt)")
                return UITableViewCell()
            }
            
            cell.titleLabel.text = cellField.key
            cell.detailLabel.text = "-"
            
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // First and last sections don't have header
        if section == 0 || section == self.sectionCount()-1 {
            return nil
        }
        
        // If there's only one section for the presentation of the fields, then set their header with a generic string
        if self.sectionCount() == 3 && section == 1 {
            return "Dados do contrato"
        }
        
        // Else, set the headers as the key of the field of the template
        return self.template!.fields[section-1].key
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
            self.goToTemplateContentsViewController()
            return
        }
        
        // Last section must add the template to the user's documents
        if section == self.sectionCount()-1 {
            self.addTemplateToUserDocuments()
            return
        }
        
        // If sectionCount() == 3, then if the selected cell is a dictionary, then show that field's view controller; else nothing happens
        if self.sectionCount() == 3 {
            if self.template!.fields[row].type == "dict" {
                self.goToTemplateFieldTableViewController(field: self.template!.fields[row])
            }
            
            return
        }
        
        // Getting the field list of the determined section
        guard let sectionFields = self.template!.fields[section-1].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(didSelectRowAt)")
            return
        }
        
        // Getting the field of the selected cell
        let cellField = sectionFields[row]
        
        // If the selected cell is a dictionary, then open this field's view controller
        if cellField.type == "dict" {
            self.goToTemplateFieldTableViewController(field: cellField)
        }
    }

}


extension TemplateTableViewController {
    
    /// Presents to the user the view of the template's content
    func goToTemplateContentsViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let templateContentViewController = storyBoard.instantiateViewController(withIdentifier: "TemplateContentsViewController") as? TemplateContentsViewController else {
            print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.goToTemplateContentsViewController()")
            return
        }
        
        templateContentViewController.template = self.template
        self.navigationController?.pushViewController(templateContentViewController, animated: true)
    }
    
    
    /// Presents to the user the view controller of a field
    func goToTemplateFieldTableViewController(field: Field) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let templateFieldTableViewController = storyBoard.instantiateViewController(withIdentifier: "TemplateFieldTableViewController") as? TemplateFieldTableViewController else {
            print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.goToTemplateFieldTableViewController()")
            return
        }
        
        templateFieldTableViewController.field = field
        templateFieldTableViewController.pathToSave = field.key
        
        self.navigationController?.pushViewController(templateFieldTableViewController, animated: true)
    }
    
    
    /// Adds template to user documents (in-app and database).
    func addTemplateToUserDocuments() {
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
            
            let text = alert.textFields![0].text // Force unwrapping because we know it exists
            
            guard let documentTitle = text, documentTitle != "" else {
                print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentTableViewController.openFillingFieldAlert()")
                return
            }
            
            // Trying to add the template to the main user's documents
            DocumentServices.addTemplateToUserDocuments(self.template!, title: documentTitle) {
                addingError in
                
                if addingError != nil {
                    self.handlesAddingDocumentError()
                    return
                }
                
                self.handlesAddingDocumentSuccess()
            }
        }
        
        alert.addAction(addDocumentAction)

        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }
}


extension TemplateTableViewController {
    
    /// Handles template nil error and present it to user.
    func handlesTemplateNilError() {
        
        // Reloading templates completely
        FetchingServices.loadTemplates() {
            (fetchingError) in
            
            if let error = fetchingError {
                print(error.errorDescription)
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

    
    /// Handles error when trying to add a template to the main user's database.
    func handlesAddingDocumentError() {
        // Creating and presenting alert
        let alert = UIAlertController(title: "Erro ao adicionar template", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// Handles success when trying to add a template to the main user's database.
    func handlesAddingDocumentSuccess() {
        
        // Creating and presenting alert
        let alert = UIAlertController(title: "O template foi adicionado com sucesso aos seus documentos!", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            _ in
            
            // Move to new document screen according to documentTitle
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
