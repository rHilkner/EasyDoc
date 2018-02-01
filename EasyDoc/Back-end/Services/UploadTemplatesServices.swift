//
//  TemplatesServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 30/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ValueTypeOrder {
    var value: Any
    var type: String
    var order: Int
    
    init(value: Any, type: String, order: Int) {
        self.value = value
        self.type = type
        self.order = order
    }
    
    func toDict() -> [String : Any] {
        let dict: [String : Any] = [
            "value": self.value,
            "type": self.type,
            "order": self.order
        ]
        
        return dict
    }
}

class UploadTemplatesServices {
    
    // Basic personal data dictionary
    static var dadosPessoais: [String : Any] =
    [
        "Nome": ValueTypeOrder(value: "", type: "string", order: 0).toDict(),
        "Nacionalidade": ValueTypeOrder(value: "", type: "string", order: 1).toDict(),
        "Estado Civil": ValueTypeOrder(value: "", type: "string", order: 2).toDict(),
        "Profissão": ValueTypeOrder(value: "", type: "string", order: 3).toDict(),
        "RG": ValueTypeOrder(value: "", type: "string", order: 4).toDict(),
        "CPF": ValueTypeOrder(value: "", type: "string", order: 5).toDict(),
        "Email": ValueTypeOrder(value: "", type: "string", order: 6).toDict(),
        "Endereço": ValueTypeOrder(value: UploadTemplatesServices.endereco, type: "dict", order: 7).toDict()
    ]
    
    // Basic address dictionary
    static var endereco: [String : Any] =
    [
        "Rua": ValueTypeOrder(value: "", type: "string", order: 0).toDict(),
        "Número": ValueTypeOrder(value: "", type: "string", order: 1).toDict(),
        "Complemento": ValueTypeOrder(value: "", type: "string", order: 2).toDict(),
        "CEP": ValueTypeOrder(value: "", type: "string", order: 3).toDict(),
        "Cidade": ValueTypeOrder(value: "", type: "string", order: 4).toDict(),
        "Estado": ValueTypeOrder(value: "", type: "string", order: 5).toDict(),
    ]
    
    
    /// Sends a given template dictioary to the database
    static func sendTemplateToDB(id: String, templateDict: [String : Any], completionHandler: @escaping (EasyDocError?) -> Void) {
        let templatesRef = Database.database().reference().child("templates").child(id)
        
        templatesRef.setValue(templateDict) {
            (error, _) in
            
            if error != nil {
                completionHandler(EasyDocQueryError.setValue)
                return
            }
            
            completionHandler(nil)
        }
        
    }
    
    
    /// Sends all dictionaries in this class to the database
    static func sendAllTemplatesToDB(completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Creating dispatch group to notify when all templates are sent to DB
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        // Sending "Contrato de Locação Imobiliária" to database
        self.sendTemplateToDB(id: "Locação Imobiliária", templateDict: self.getLocacaoImobiliariaDict()) {
            _error in
            
            if let error = _error {
                completionHandler(error)
                return
            }
            
            dispatchGroup.leave()
        }
        
        // Calling completionHandler after all templates are sent to DB
        dispatchGroup.notify(queue: .main) {
            completionHandler(nil)
        }
    }
    
    /// Returns the dictionary of Locação Imobiliária
    static func getLocacaoImobiliariaDict() -> [String : Any] {
        /***** TYPE *****/
        
        let type: String = "Locação Imobiliária"
        
        /***** CONTENTS *****/
        
        let contents: String = ""
        
        /***** FIELDS *****/
        
        // PARTES
        
        let partes: [String : Any] = [
            "Locador": ValueTypeOrder(value: UploadTemplatesServices.dadosPessoais, type: "dict", order: 0).toDict(),
            "Locatário": ValueTypeOrder(value: UploadTemplatesServices.dadosPessoais, type: "dict", order: 1).toDict()
        ]
        
        // DADOS DO IMÓVEL
        
        let matricula: [String : Any] = [
            "Número da matrícula": ValueTypeOrder(value: "", type: "string", order: 0).toDict(),
            "Número do cartório": ValueTypeOrder(value: "", type: "string", order: 1).toDict(),
            "Cidade do cartório": ValueTypeOrder(value: "", type: "string", order: 2).toDict(),
            "Estado do cartório": ValueTypeOrder(value: "", type: "string", order: 3).toDict()
        ]
        
        let dadosDoImovel: [String : Any] = [
            "Endereco": ValueTypeOrder(value: UploadTemplatesServices.endereco, type: "dict", order: 0).toDict(),
            "Matrícula": ValueTypeOrder(value: matricula, type: "dict", order: 1).toDict(),
        ]
        
        // SOBRE A LOCAÇÃO
        
        let periodoDeLocacao: [String : Any] = [
            "Prazo de locação": ValueTypeOrder(value: "", type: "string", order: 0).toDict(),
            "Data de início": ValueTypeOrder(value: "", type: "string", order: 1).toDict(),
            "Data final": ValueTypeOrder(value: "", type: "string", order: 2).toDict(),
        ]
        
        let valoresEPagamento: [String : Any] = [
            "Valor da locação": ValueTypeOrder(value: "", type: "string", order: 0).toDict(),
            "Dia de vencimento mensal": ValueTypeOrder(value: "", type: "string", order: 1).toDict(),
            "Índice de correção": ValueTypeOrder(value: "", type: "string", order: 2).toDict(),
            "Percentual de multa moratória": ValueTypeOrder(value: "", type: "string", order: 3).toDict()
        ]
        
        let sobreALocacao: [String : Any] = [
            "Período de locação": ValueTypeOrder(value: periodoDeLocacao, type: "dict", order: 0).toDict(),
            "Valores e pagamento": ValueTypeOrder(value: valoresEPagamento, type: "dict", order: 1).toDict()
        ]
        
        // SOBRE O CONTRATO
        
        let local = [
            "Cidade": ValueTypeOrder(value: "", type: "string", order: 0).toDict(),
            "Estado": ValueTypeOrder(value: "", type: "string", order: 1).toDict()
        ]
        
        let testemunhas = [
            "Nome Testemunha 1": ValueTypeOrder(value: "", type: "string", order: 0).toDict(),
            "Nome Testemunha 2": ValueTypeOrder(value: "", type: "string", order: 1).toDict()
        ]
        
        let sobreOContrato: [String : Any] = [
            "Local": ValueTypeOrder(value: local, type: "dict", order: 0).toDict(),
            "Testemunhas": ValueTypeOrder(value: testemunhas, type: "dict", order: 1).toDict(),
            "Número de vias a serem assinadas": ValueTypeOrder(value: "", type: "string", order: 2).toDict()
        ]
        
        // FIELDS, FINALLY
        
        let fields: [String : Any] =
        [
            "Partes": ValueTypeOrder(value: partes, type: "dict", order: 0).toDict(),
            "Dados do imóvel": ValueTypeOrder(value: dadosDoImovel, type: "dict", order: 1).toDict(),
            "Sobre a locação": ValueTypeOrder(value: sobreALocacao, type: "dict", order: 2).toDict(),
            "Sobre o contrato": ValueTypeOrder(value: sobreOContrato, type: "dict", order: 3).toDict()
        ]
        
        
        let locacaoImobiliaria: [String : Any] = [
            "type": type,
            "fields": fields,
            "contents": contents
        ]
        
        return locacaoImobiliaria
    }
    
}
