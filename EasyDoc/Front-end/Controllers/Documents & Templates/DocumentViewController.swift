//
//  DocumentViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    
    var document: Document?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Verifying if document is not nil
        guard self.document != nil else {
            print(EasyDocOfflineError.foundNil.localizedDescription)
            self.handlesDocumentNilError()
            return
        }
        
        // Loading view controller
        self.loadViewController()
    }
    
    
    /// Loads content of the view controller
    func loadViewController() {
        self.title = self.document!.title
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
    }
    
    
    /// Handles document nil error and present it to user.
    func handlesDocumentNilError() {
        // Reloading main user object completely
        FetchingServices.reloadMainUser() {
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
}

extension DocumentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mainUser = AppShared.mainUser else {
            print(EasyDocOfflineError.foundNil)
            return 0
        }

        return mainUser.documents.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as? DocumentTableViewCell else {
//            print(EasyDocOfflineError.castingError.localizedDescription)
            return UITableViewCell()
//        }
//
//        let row = indexPath.row
//        cell.titleLabel.text = self.documents[row].title
//        cell.lastModifiedLabel.text = self.documents[row].lastModified.toString()
//
//        return cell
    }
}

extension DocumentViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.tableView.deselectRow(at: indexPath, animated: true)
//
//        let row = indexPath.row
//        self.goToDocumentViewController(document: self.documents[row])
//    }
}
