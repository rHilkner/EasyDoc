
//
//  SettingsTableViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 28/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // Table view and logout functions on extensions below
}


// MARK: - Table view data source
extension SettingsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Setting only 1 row for the logout cell
        let numberOfRows = 1
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CellFactory.logoutCell(tableView: tableView)
        return cell
    }
    
}


// MARK: - Table view delegate
extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselecting the selected cell
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.logoutButtonPressed()
    }
}
    

// MARK: - Performing actions
extension SettingsTableViewController {
    
    /// Called when logout button is pressed
    func logoutButtonPressed() {
        
        // Creating alert and adding actions
        let logoutAlert = UIAlertController(title: "Tem certeza que deseja sair?", message: nil, preferredStyle: .actionSheet)
        
        // Creating logout action to present alert on screen
        let logoutAction = UIAlertAction(title: "Sair", style: .destructive) {
            _ in
            // Attempting to logout
            AuthServices.attemptToLogout() {
                (logoutError) in
                
                if let error = logoutError {
                    print(error.localizedDescription)
                }
                
                self.goToLoginScreen()
            }
        }
        
        // Creating cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            _ in
            print("Logout cancelled")
        }
        
        logoutAlert.addAction(logoutAction)
        logoutAlert.addAction(cancelAction)
        
        // Presenting alert
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    
    /// Presents Login Screen
    func goToLoginScreen() {
        let loginNavigationController = ViewControllerFactory.instantiateViewController(ofType: .authNavigationController)
        
        self.tabBarController?.removeFromParentViewController()
        self.present(loginNavigationController, animated: true, completion: nil)
    }
    
}
