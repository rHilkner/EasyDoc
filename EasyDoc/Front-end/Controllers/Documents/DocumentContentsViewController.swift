//
//  DocumentContentsViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 01/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class DocumentContentsViewController: UIViewController {

    var document: Document?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if document == nil {
            print("-> WARNING: EasyDocOfflineError.foundNil @ DocumentContentsViewController.viewDidLoad()")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.loadViewController()
    }
    
    
    func loadViewController() {
        self.navigationItem.title = "Visualizar documento"
        
        self.contentsLabel.text = DocumentServices.readContentsWithValues(document: document!)
        
        self.scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: self.contentsLabel.bottomAnchor).isActive = true
    }
    
}
