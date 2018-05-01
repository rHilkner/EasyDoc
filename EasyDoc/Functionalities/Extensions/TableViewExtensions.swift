//
//  TableViewExtensions.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 10/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    // Scrolls to top of the table view
    func scrollToTop() {
        self.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
}

