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
        
        // Verifying if templates object is still being loaded
        if AppShared.isLoadingTemplates.value {
            AppShared.isLoadingTemplates.delegate = self
            self.presentLoadingIndicator()
            return
        }
        
        // Loading view controller
        self.loadViewController()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // If self is delegate of isLoadingUser, then make it nil
        if AppShared.isLoadingTemplates.delegate != nil {
            AppShared.isLoadingTemplates.delegate = nil
        }
    }
    

    /// Loads content of the view controller
    func loadViewController() {
        // Getting templates object
        guard let temp = AppShared.templates else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplatesViewController.loadViewController()")
                
            // Reloading templates object completely
            FetchingServices.loadTemplates() {
                (fetchingError) in
                
                // Performing logout in case of error - except if connection lost
                if let error = fetchingError {
                    // TODO: perform logout
                    print(error.errorDescription)
                    return
                }
                
                self.loadViewController()
            }
            
            return
        }
        
        // Getting templates
        self.templates = temp
        
        // Setting table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    
    /// Goes to given document view controller
    func goToTemplateViewController(template: Template) {
        performSegue(withIdentifier: "TemplateSegue", sender: template)
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

extension TemplatesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateCell", for: indexPath) as? TemplateTableViewCell else {
            print(EasyDocOfflineError.castingError.errorDescription)
            return UITableViewCell()
        }
        
        let row = indexPath.row
        cell.titleLabel.text = self.templates[row].type
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // Choose custom row height
        return 80
    }
}

extension TemplatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        self.goToTemplateViewController(template: self.templates[row])
    }
}

extension TemplatesViewController: IsLoadingTemplatesDelegate {
    /// Called when user session loading has ended
    func loadingEnded() {
        self.loadViewController()
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
            self.loadingIndicatorAlert!.dismiss(animated: false, completion: nil)
            self.loadingIndicatorAlert = nil
        }
    }
}
