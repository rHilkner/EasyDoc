//
//  CellFactory.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import UIKit

// TableViewCellIds

public enum DocumentCellType: String {
    case document = "DocumentCell"
    case fieldWithDisclosure = "DocumentFieldCellWithDisclosure"
    case fieldWithDetail = "DocumentFieldCellWithDetail"
}

public enum TemplateCellType: String {
    case template = "TemplateCell"
    case fieldWithDisclosure = "TemplateFieldCellWithDisclosure"
    case fieldWithDetail = "TemplateFieldCellWithDetail"
    case addTemplate = "AddTemplateCell"
}

public enum SettingsCellType: String {
    case logout = "LogoutCell"
}


/// Cell factory
class CellFactory {
    
}


// Documents cells
extension CellFactory {
    
    /// Returns document cell with given title and date of last modification
    static func documentCell(tableView: UITableView, title: String, lastModified: String) -> DocumentTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCellType.document.rawValue) as! DocumentTableViewCell
        
        cell.titleLabel.text = title
        cell.lastModifiedLabel.text = lastModified
        
        return cell
    }
    
    
    /// Returns "view document contents" cell
    static func viewDocumentContentsCell(tableView: UITableView) -> DocumentFieldTableViewCellWithDisclosure {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCellType.fieldWithDisclosure.rawValue) as! DocumentFieldTableViewCellWithDisclosure
        
        cell.titleLabel.text = "Visualizar documento"
        
        return cell
    }
    
    
    /// Returns document field cell
    static func documentFieldCell(tableView: UITableView, field: Field) -> UITableViewCell {
        
        switch field.type {
        case .dict:
            return self.documentFieldDictCell(tableView: tableView, title: field.key)
            
        case .string:
            return self.documentFieldStringCell(tableView: tableView, title: field.key, detail: field.value as? String)
            
        }
        
    }
    
    
    /// Returns document field cell with disclosure
    static func documentFieldDictCell(tableView: UITableView, title: String) -> DocumentFieldTableViewCellWithDisclosure {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCellType.fieldWithDisclosure.rawValue) as! DocumentFieldTableViewCellWithDisclosure
        
        cell.titleLabel.text = title
        
        return cell
    }
    
    
    /// Returns document field cell with detail
    static func documentFieldStringCell(tableView: UITableView, title: String, detail: String?) -> DocumentFieldTableViewCellWithDetail {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCellType.fieldWithDetail.rawValue) as! DocumentFieldTableViewCellWithDetail
        
        cell.titleLabel.text = title
        
        if let detailText = detail, detailText != "" {
            cell.detailLabel.text = detailText
        } else {
            cell.detailLabel.text = "-"
        }
        
        return cell
    }
    
}


// Template cells
extension CellFactory {
    
    /// Returns template cell
    static func templateCell(tableView: UITableView, title: String) -> TemplateTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TemplateCellType.template.rawValue) as! TemplateTableViewCell
        
        cell.titleLabel.text = title
        
        return cell
    }
    
    
    /// Returns add template cell
    static func addTemplateCell(tableView: UITableView) -> AddTemplateTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TemplateCellType.addTemplate.rawValue) as! AddTemplateTableViewCell
        
        return cell
    }
    
    
    /// Returns "view template contents" cell
    static func viewTemplateContentsCell(tableView: UITableView) -> TemplateFieldTableViewCellWithDisclosure {
        let cell = tableView.dequeueReusableCell(withIdentifier: TemplateCellType.fieldWithDisclosure.rawValue) as! TemplateFieldTableViewCellWithDisclosure
        
        cell.titleLabel.text = "Visualizar documento"
        
        return cell
    }
    
    
    /// Returns template field cell
    static func templateFieldCell(tableView: UITableView, field: Field) -> UITableViewCell {
        
        switch field.type {
        case .dict:
            return self.templateFieldDictCell(tableView: tableView, title: field.key)
            
        case .string:
            return self.templateFieldStringCell(tableView: tableView, title: field.key)
            
        }
        
    }
    
    
    /// Returns template field cell with disclosure
    static func templateFieldDictCell(tableView: UITableView, title: String) -> TemplateFieldTableViewCellWithDisclosure {
        let cell = tableView.dequeueReusableCell(withIdentifier: TemplateCellType.fieldWithDisclosure.rawValue) as! TemplateFieldTableViewCellWithDisclosure
        
        cell.titleLabel.text = title
        
        return cell
    }
    
    
    /// Returns template field cell with detail
    static func templateFieldStringCell(tableView: UITableView, title: String) -> TemplateFieldTableViewCellWithDetail {
        let cell = tableView.dequeueReusableCell(withIdentifier: TemplateCellType.fieldWithDetail.rawValue) as! TemplateFieldTableViewCellWithDetail
        
        cell.titleLabel.text = title
        cell.detailLabel.text = "-"
        
        return cell
    }
    
}


// Settings cells
extension CellFactory {
    
    /// Returns logout cell
    static func logoutCell(tableView: UITableView) -> LogoutTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCellType.logout.rawValue) as! LogoutTableViewCell
        
        return cell
    }
    
}
