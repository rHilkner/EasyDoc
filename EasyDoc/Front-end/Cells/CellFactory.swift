//
//  CellFactory.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import UIKit

public enum DocumentCellType {
    case withDisclosure
    case withDetail
}

public enum TemplateCellType {
    case withDisclosure
    case withDetail
    case addButton
}

class CellFactory {
    
    /// Returns the correct template cell for the given table view and cell type
    static func templateCell(tableView: UITableView, type: TemplateCellType) -> UITableViewCell {
        switch type {
        case .withDisclosure:
            return tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDisclosure") as! TemplateDisclosureTableViewCell
            
        case .withDetail:
            return tableView.dequeueReusableCell(withIdentifier: "TemplateCellWithDetail") as! TemplateDetailTableViewCell
            
        case .addButton:
            return tableView.dequeueReusableCell(withIdentifier: "AddTemplateCell") as! AddTemplateTableViewCell
            
        }
    }
    
    
    /// Returns the correct document cell for the given table view and cell type
    static func documentCell(tableView: UITableView, type: DocumentCellType) -> UITableViewCell {
        switch type {
        case .withDisclosure:
            return tableView.dequeueReusableCell(withIdentifier: "DocumentCellWithDisclosure") as! DocumentDisclosureTableViewCell
            
        case .withDetail:
            return tableView.dequeueReusableCell(withIdentifier: "DocumentCellWithDetail") as! DocumentDetailTableViewCell
            
        }
    }
    
}
