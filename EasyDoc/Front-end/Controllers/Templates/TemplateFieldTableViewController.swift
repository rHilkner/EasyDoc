//
//  TemplateFieldTableViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 01/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class TemplateFieldTableViewController: UITableViewController {
    
    var field: Field?
    var pathToSave: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.field == nil {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateFieldTableViewController.viewDidLoad()")
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
extension TemplateFieldTableViewController {
    
    func sectionCount() -> Int {
        guard let valueFields = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateFieldTableViewController.viewDidLoad()")
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
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateFieldTableViewController.viewDidLoad()")
            return 0
        }
        
        if self.sectionCount() == 1 {
            return valueFields.count
        }
        
        guard let sectionFields = valueFields[section].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(numberOfRowsInSection)")
            return 0
        }
        
        return sectionFields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        // Getting fields list from self.field.value
        guard let fieldsList = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateFieldTableViewController.viewDidLoad()")
            return UITableViewCell()
        }
        
        // If number of sections is 1, then all fields of the field are gonna be cells
        if self.sectionCount() == 1 {
            let cellField = fieldsList[row]
            
            // Verifying which type of cell we need to cast
            if cellField.type == "dict" {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDisclosure") as? TemplateDisclosureTableViewCell else {
                    print("-> WARNING: EasyDocOfflineError.castingError @ TemplateFieldTableViewController.tableView(cellForRowAt)")
                    return UITableViewCell()
                }
                
                cell.titleLabel.text = cellField.key
                
                return cell
                
            } else {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDetail") as? TemplateDetailTableViewCell else {
                    print("-> WARNING: EasyDocOfflineError.castingError @ TemplateFieldTableViewController.tableView(cellForRowAt)")
                    return UITableViewCell()
                }
                
                cell.titleLabel.text = cellField.key
                cell.detailLabel.text = "-"
                
                return cell
            }
        }
        
        // Getting fields of the determined section
        guard let sectionFields = fieldsList[section].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ TemplateFieldTableViewController.tableView(cellForRowAt)")
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
        if self.sectionCount() == 1 {
            return nil
        }
        
        // Getting fields from self.field.value
        guard let valueFields = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateFieldTableViewController.viewDidLoad()")
            return nil
        }
        
        return valueFields[section].key
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        
        // Getting fields from self.field.value
        guard let valueFields = self.field!.value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateFieldTableViewController.viewDidLoad()")
            return
        }
        
        if self.sectionCount() == 1 {
            if valueFields[row].type == "dict" {
                self.goToTemplateFieldTableViewController(field: valueFields[row])
            }
            
            return
        }
        
        guard let sectionFields = valueFields[section].value as? [Field] else {
            print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.tableView(didSelectRowAt)")
            return
        }
        
        let cellField = sectionFields[row]
        
        if cellField.type == "dict" {
            self.goToTemplateFieldTableViewController(field: cellField)
        }
    }
    
}


extension TemplateFieldTableViewController {
    /// Goes to selected field view controller
    func goToTemplateFieldTableViewController(field: Field) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let templateFieldTableViewController = storyBoard.instantiateViewController(withIdentifier: "TemplateFieldTableViewController") as? TemplateFieldTableViewController else {
            print("-> WARNING: EasyDocOfflineError.castingError @ TemplateTableViewController.goToTemplateContegoToTemplateFieldTableViewControllerntsViewController()")
            return
        }
        
        templateFieldTableViewController.field = field
        templateFieldTableViewController.pathToSave = self.pathToSave! + "/" + field.key
        
        self.present(templateFieldTableViewController, animated: true, completion: nil)
    }
}
