//
//  TemplatesViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class TemplatesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var templates: [Template] = []
    var loadingIndicatorAlert: UIAlertController?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting table view
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Loading templates from database into AppShared.templates
        AppShared.isLoadingTemplates.value = true
        TemplateServices.loadTemplates() {
            loadingError in

            if let error = loadingError {
                // TODO: retry or show "no connection" alert
                print(error.localizedDescription)
            }
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        // Verifying if templates aren't still loading
        if AppShared.isLoadingTemplates.value {
            AppShared.isLoadingTemplates.delegate = self
            self.presentLoadingIndicator()
            return
        }

        // Loading table view contents
        self.loadTableViewContents()
        self.tableView.reloadData()
    }


    /// Loads content of the view controller
    func loadTableViewContents() {

        // Verifying if templates object exists
        guard let templates = AppShared.templates else {

            // Verifying if templates aren't still loading
            if AppShared.isLoadingTemplates.value {
                return
            }

            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplatesViewController.loadTableViewContents()")

            // Loading templates from database into AppShared.templates
            AppShared.isLoadingTemplates.value = true
            TemplateServices.loadTemplates() {
                loadingError in

                if let error = loadingError {
                    // TODO: retry or show "no connection" alert
                    print(error.localizedDescription)
                }
            }
            return
        }

        self.templates = templates
    }


    override func viewWillDisappear(_ animated: Bool) {
        // If self is delegate of isLoadingUser, then make it nil
        if AppShared.isLoadingTemplates.delegate != nil {
            AppShared.isLoadingTemplates.delegate = nil
        }
    }

}


extension TemplatesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creating table view cell
        return CellFactory.templateCell(tableView: tableView, title: self.templates[indexPath.row].type)
        
    }
    
}


// MARK: - Table view delegate
extension TemplatesViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        self.goToTemplateViewController(template: self.templates[row])
    }
    
}


// Handling segues and pushing view controllers
extension TemplatesViewController {
    
    /// Goes to given document view controller
    func goToTemplateViewController(template: Template) {
        performSegue(withIdentifier: SegueIds.template.rawValue, sender: template)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "TemplateSegue":
                guard let template = sender as? Template else {
                    print("-> WARNING: EasyDocOfflineError.castingError @ TemplatesViewController.prepare(for segue) -1")
                    return
                }
                
                guard let segueDestination = segue.destination as? TemplateTableViewController else {
                    print("-> WARNING: EasyDocOfflineError.castingError @ TemplatesViewController.prepare(for segue) -2")
                    return
                }
                
                // Setting template of next view controller
                segueDestination.template = template
                
            default:
                break
            }
            
        }
    }
    
}


// Handling loading indicator
extension TemplatesViewController: IsLoadingTemplatesDelegate {
    /// Called when user session loading has ended
    func loadingEnded() {
        self.loadTableViewContents()
        self.tableView.reloadData()
        self.dismissLoadingIndicator()
    }
    
    
    /// Presents view with loading indicator
    func presentLoadingIndicator() {
        // Creating alert
        self.loadingIndicatorAlert = UIAlertController(title: nil, message: "Carregando...", preferredStyle: .alert)
        
        // Adding loading indicator
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        
        self.loadingIndicatorAlert!.view.addSubview(loadingIndicator)
        
        // Presenting the alert
        present(self.loadingIndicatorAlert!, animated: true, completion: nil)
    }
    
    
    /// Dismisses view with loading indicator
    func dismissLoadingIndicator() {
        
        // Dismissing loading indicator
        if self.loadingIndicatorAlert != nil {
            self.loadingIndicatorAlert!.dismiss(animated: true, completion: nil)
            self.loadingIndicatorAlert = nil
        }
    }
    
}
