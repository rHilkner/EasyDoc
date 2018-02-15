//
//  TemplateContentsViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 01/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class TemplateContentsViewController: UIViewController {
    
    var template: Template?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if template == nil {
            print("-> WARNING: EasyDocOfflineError.foundNil @ TemplateContentsViewController.viewDidLoad()")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.loadViewController()
    }
    
    
    func loadViewController() {
        self.navigationItem.title = "Visualizar documento"
        
        self.contentsLabel.text = self.template!.readContents()
        
        self.scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: self.contentsLabel.bottomAnchor).isActive = true
    }

}
