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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = template!.type
        
        //Verifying if document is not nil
        guard self.template != nil else {
            print(EasyDocOfflineError.foundNil.errorDescription)
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
    
    /// Handles document nil error and present it to user.
    func handlesTemplateNilError() {
        // Reloading main user object completely
        FetchingServices.loadTemplates() {
            (fetchingError) in
            
            if let error = fetchingError {
                print(error.localizedDescription)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}


// MARK: - Table view data source
extension TemplateTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateFieldCell", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

}
