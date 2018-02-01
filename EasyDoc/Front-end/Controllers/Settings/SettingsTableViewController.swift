
//
//  SettingsTableViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 28/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    /// Called when logout button is pressed
    @IBAction func LogoutButtonPressed() {
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
            print("Cancelled")
        }
        
        // Creating alert and adding actions
        let logoutAlert = UIAlertController(title: "Tem certeza que deseja sair?", message: nil, preferredStyle: .actionSheet)
        logoutAlert.addAction(logoutAction)
        logoutAlert.addAction(cancelAction)
        
        // Presenting alert
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    
    func goToLoginScreen() {
        // TODO: check if there is a way to dismiss all the view controllers and leave only the login view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginViewController, animated: true, completion: nil)
    }
    

}
