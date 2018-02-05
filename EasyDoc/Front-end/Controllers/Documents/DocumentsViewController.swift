//
//  DocumentsTableViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {

    // Label that may show user that he/she doesn't have any documents yet
    @IBOutlet weak var noDocumentsDisclaimer: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var documents: [Document] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Uncomment lines below to send all templates in UploadTemplatesServices to EasyDoc's Firebase Database
        //        UploadTemplatesServices.sendAllTemplatesToDB()
        //        return
        
        
        // Verifying if user object is still being loaded
        if AppShared.isLoadingUser.value {
            AppShared.isLoadingUser.delegate = self
            self.presentLoadingIndicator()
            return
        }
        
        // Loading view controller
        self.loadViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // If self is delegate of isLoadingUser, then make it nil
        if AppShared.isLoadingUser.delegate != nil {
           AppShared.isLoadingUser.delegate = nil
        }
    }
    
    
    /// Loads content of the view controller
    func loadViewController() {
        // Getting user object
        guard let mainUser = AppShared.mainUser else {
            print(EasyDocOfflineError.foundNil.errorDescription)
            
            // Reloading main user object completely
            FetchingServices.reloadMainUser() {
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
        
        // Getting user's documents
        if mainUser.documents.count == 0 {
            self.noDocumentsDisclaimer.isHidden = false
            return
        }
        
        self.documents = mainUser.documents
        
        self.noDocumentsDisclaimer.isHidden = true
        
        // Setting table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    
    /// Goes to given document view controller
    func goToDocumentViewController(document: Document) {
        performSegue(withIdentifier: "DocumentSegue", sender: document)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "DocumentSegue":
                guard let document = sender as? Document else {
                    print("-> WARNING: EasyDocOfflineError.castingError @ DocumentsViewController.prepare(for segue)")
                    return
                }
                
                guard let segueDestination = segue.destination as? DocumentTableViewController else {
                    print("-> WARNING: EasyDocOfflineError.castingError @ DocumentsViewController.prepare(for segue)")
                    return
                }
                
                // Setting document of next view controller
                segueDestination.document = document
                
            default:
                break
            }
        }
    }
}

extension DocumentsViewController: UITableViewDataSource {
    
    /// Returns number os sections of the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /// Returns number of cells in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documents.count
    }
    
    
    /// Populates table view with cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating cell with identifier
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as? DocumentTableViewCell else {
            print(EasyDocOfflineError.castingError.errorDescription)
            return UITableViewCell()
        }
        
        // Populating cell
        let row = indexPath.row
        cell.titleLabel.text = self.documents[row].title
        cell.lastModifiedLabel.text = self.documents[row].lastModified.toString()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Choose custom row height
        return 80
    }
}
    
extension DocumentsViewController: UITableViewDelegate {
    
    /// Performs actions when a table view cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        self.goToDocumentViewController(document: self.documents[row])
    }
}


extension DocumentsViewController: IsLoadingUserDelegate {
    /// Called when user session loading has ended
    func loadingEnded() {
        self.loadViewController()
        self.dismissLoadingIndicator()
    }
    
    
    /// Presents view with loading indicator
    func presentLoadingIndicator() {
        print("User object loading.")
    }
    
    
    /// Dismisses view with loading indicator
    func dismissLoadingIndicator() {
        print("User object loading ended.")
    }
}
