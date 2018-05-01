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
    var loadingIndicatorAlert: UIAlertController?


    override func viewDidLoad() {

        // Setting table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }


    override func viewDidAppear(_ animated: Bool) {
        // Uncomment lines below to send all templates in UploadTemplatesServices to EasyDoc's Firebase Database
        //        UploadTemplatesServices.sendAllTemplatesToDB()
        //        return

        // Verifying if user object is still being loaded
        if AppShared.isLoadingUser.value {
            AppShared.isLoadingUser.delegate = self
            self.presentLoadingIndicator()
            return
        }

        // Loading table view contents
        self.loadTableViewContents()
        self.tableView.reloadData()
    }


    /// Loads content of the view controller
    func loadTableViewContents() {
        // Verifying if user's documents object exists
        guard let documents = AppShared.mainUser?.documents else {

            // Verifying if user is still being loaded
            if AppShared.isLoadingUser.value {
                return
            }
            
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentsViewController.loadViewController()")

            // Reloading main user object completely
            UserServices.reloadMainUser() {
                (fetchingError) in

                // Showing error if needed
                if let error = fetchingError {
                    print(error.description)
                    // TODO: show "no connection" alert
                    return
                }

                self.loadTableViewContents()
            }

            return
        }

        // Getting user's documents
        self.documents = documents

        if self.documents.count == 0 {
            self.noDocumentsDisclaimer.isHidden = false
        } else {
            self.noDocumentsDisclaimer.isHidden = true
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // If self is delegate of isLoadingUser, then make it nil
        if AppShared.isLoadingUser.delegate != nil {
           AppShared.isLoadingUser.delegate = nil
        }
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {

        if !self.tableView.isEditing {
            self.tableView.setEditing(true, animated: true)
            self.navigationItem.leftBarButtonItem?.title = "OK"
        } else {
            self.tableView.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem?.title = "Editar"
        }
    }
    
}


extension DocumentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
    // Makes all cells editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
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
        
        let row = indexPath.row
        
        let cell = CellFactory.documentCell(tableView: tableView, title: self.documents[row].title, lastModified: self.documents[row].lastModified.toString())
        
        return cell
    }
    
}


// MARK: - Table view delegate
extension DocumentsViewController: UITableViewDelegate {
    
    /// Performs actions when a table view cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        self.goToDocumentViewController(document: self.documents[row])
    }
    
    
    // Handles editing of documents such as "delete"
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            DocumentServices.deleteDocument(self.documents[indexPath.row]) {
                error in
                
                if error != nil {
                    print("-> WARNING: EasyDocQueryError.removeValue @ DocumentsViewController.tableView()")
                    self.handleUnsuccessfullDelete()
                    return
                }
                
                self.loadTableViewContents()
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
            }
        }
    }
    
}


// Editing table view
extension DocumentsViewController {
    
}


// Dealing with segues
extension DocumentsViewController {
    
    /// Goes to given document view controller
    func goToDocumentViewController(document: Document) {
        performSegue(withIdentifier: SegueIds.document.rawValue, sender: document)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case SegueIds.document.rawValue:
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
    
    
    /// Called when a template is added to the user's documents
    @IBAction func unwindFromTemplateTableViewController(_ sender: UIStoryboardSegue) {
        self.tableView.scrollToTop()
    }
    
}


// Handling user loading
extension DocumentsViewController: IsLoadingUserDelegate {
    
    /// Called when user session loading has ended
    func loadingEnded() {
        self.loadTableViewContents()
        self.tableView.reloadData()
        self.dismissLoadingIndicator()
    }
    
    
    /// Presents view with loading indicator
    func presentLoadingIndicator() {
        
        // Creating alert
        self.loadingIndicatorAlert = UIAlertController(title: "Carregando...", message: nil, preferredStyle: .alert)

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


// Handling errors
extension DocumentsViewController {
    
    /// Called when deleting a documents returns an error. Presents an alert to inform the user the deletion was unsuccessful.
    func handleUnsuccessfullDelete() {
        // Creating and presenting alert
        let alert = UIAlertController(title: "Erro ao deletar documento", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
