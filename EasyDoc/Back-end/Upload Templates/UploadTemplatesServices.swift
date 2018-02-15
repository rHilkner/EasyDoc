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
    static func sendAllTemplatesToDB() {
        
        // Creating dispatch group to notify when all templates are sent to DB
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        // Sending "Contrato de Locação Imobiliária" to database
        self.sendTemplateToDB(id: "Locação Imobiliária", templateDict: self.getLocacaoImobiliariaDict()) {
            error in
            
            if error != nil {
                print("-> BIG WARNING: Uploading templates to database failed.")
                return
            }
            
            dispatchGroup.leave()
        }
        
        // Calling completionHandler after all templates are sent to DB
        dispatchGroup.notify(queue: .main) {
            print("-> BIG SUCCESS: Uploading templates to database succeeded.")
        }
    }
    
    /// Returns the dictionary of Locação Imobiliária
    static func getLocacaoImobiliariaDict() -> [String : Any] {
        /***** TYPE *****/
        
        let type: String = "Locação Imobiliária"
        
        /***** CONTENTS *****/
        
        let contents: String =
            """
            
            CONTRATO DE LOCAÇÃO RESIDENCIAL

            Pelo presente instrumento particular, de um lado [/Partes/Locador/Nome], [/Partes/Locador/Nacionalidade], [/Partes/Locador/Estado Civil], [/Partes/Locador/Profissão], residente na [/Partes/Locador/Endereço/Rua], nº [/Partes/Locador/Endereço/Número], [/Partes/Locador/Endereço/Complemento], CEP [/Partes/Locador/Endereço/CEP], [/Partes/Locador/Endereço/Cidade]/[/Partes/Locador/Endereço/Estado], cédula de identidade RG nº [/Partes/Locador/RG], CPF nº [/Partes/Locador/CPF], email [/Partes/Locador/Email], doravante denominado locador e, de outro lado, [/Partes/Locatário/Nome], [/Partes/Locatário/Nacionalidade], [/Partes/Locatário/Estado Civil], [/Partes/Locatário/Profissão], residente na [/Partes/Locatário/Endereço/Rua], nº [/Partes/Locatário/Endereço/Número], [/Partes/Locatário/Endereço/Complemento], CEP [/Partes/Locatário/Endereço/CEP], [/Partes/Locatário/Endereço/Cidade]/[/Partes/Locatário/Endereço/Estado], cédula de identidade RG nº [/Partes/Locatário/RG], CPF nº [/Partes/Locatário/CPF], email [/Partes/Locatário/Email], doravante designado locatário, têm entre si justo e  acertado o presente contrato de locação residencial, mediante as cláusulas e condições seguintes que, mutuamente aceitam a saber:
            
            1º - O locador se obriga a dar em locação ao locatário o imóvel de sua propriedade, situado na [/Dados do imóvel/Endereço/Rua], nº [/Dados do imóvel/Endereço/Número], [/Dados do imóvel/Endereço/Complemento], CEP [/Dados do imóvel/Endereço/CEP], [/Dados do imóvel/Endereço/Cidade]/[/Dados do imóvel/Endereço/Estado], objeto da Matrícula nº [/Dados do imóvel/Matrícula/Número da matrícula] do [/Dados do imóvel/Matrícula/Número do cartório] Cartório de Registro de Imóveis de [/Dados do imóvel/Matrícula/Cidade do cartório]/[/Dados do imóvel/Matrícula/Estado do cartório], que, desde já, declara ter conhecimento das normas que regem o condomínio.
            

            2º - O prazo do presente contrato de locação é de [/Sobre a locação/Período de locação/Prazo de locação] meses, a iniciar no dia [/Sobre a locação/Período de locação/Data de início] para terminar no dia [/Sobre a locação/Período de locação/Data final], data em que o locatário se obriga a restituir o imóvel locado nas mesmas condições em que o recebeu, salvo as deteriorações de uso normal, inteiramente livre e desocupado.
            
            §1º - Benfeitorias ou modificações no imóvel locado sempre serão do conhecimento prévio do locador, que, contudo, tem a faculdade de conceder ou não a respectiva autorização, sempre incorporando-se ao imóvel, sem direito a indenização ou retenção por parte do locatário.
            

            3º - O aluguel mensal é no valor de R$ [/Sobre a locação/Valores e pagamento/Valor da locação], a ser pago, até o [/Sobre a locação/Valores e pagamento/Dia de vencimento mensal] dia útil de cada mês subsequente ao vencido, devendo ser pago proporcionalmente no primeiro e último mês, devendo ser corrigido anualmente pelo [/Sobre a locação/Valores e pagamento/Índice de correção] ou outro índice que venha substituí-lo.
            
            Parágrafo único: as partes desde já acordam que no curso da locação ora avençada caso venha a ser permitida ou adotada periodicidade menor do que a aqui contratada, as partes contratantes logo a ela aderem.
            
            §2º - Fica desde já estipulado que o não pagamento do aluguel até a data limite  de cada mês, acarretará a imediata incidência de multa de [/Sobre a locação/Valores e pagamento/Percentual de multa moratória]% do valor do aluguel, independente das sanções judiciais cabíveis, em especial liminar para despejo face ausência de garantia locatícia.
            

            4º - O locatário, durante o período de locação, arcará, sob pena de rescisão contratual, com:
            todos os encargos tributários incidentes sobre o imóvel, exceto as contribuições de melhoria;
            todas as despesas de conservação do prédio, de consumo de água, luz, telefone e outras ligas ao uso do imóvel;
            todas as multas pecuniárias provenientes do atraso no pagamento de quantias sob sua responsabilidade.
            

            5º - Havendo incêndio ou acidente, que conduza à reconstrução ou reforma do objeto de locação, rescindir-se-á o contrato, sem prejuízo da responsabilidade do locatário, se o fato ocorreu por sua culpa.


            6º - O todo e qualquer ajuste entre as partes, para integrar o presente contrato, deverá ser feito por escrito.


            7º - A eventual tolerância do locador para com qualquer infração contratual, atraso no pagamento dos aluguéis, taxas ou impostos, não constituirá motivo para que o locatário ou o seu fiador, alegue novação.


            8º - O presente contrato obrigará herdeiros, sucessores ou concessionários de ambas as partes esse renovará por tempo indeterminado – seguindo a concordância de locador e locatário – período em que ficará facultado ao locatário o direito de rescindi-lo, desde que notifique por escrito ao locador, no mínimo 30 dias antes da efetiva entrega das chaves, valendo para o locador as mesmas circunstâncias de prazo.
            

            9º - É vedado ao locatário ceder ou transferir o presente contrato, total ou parcialmente, sem autorização do locador.


            10º - É eleito foro do local do imóvel para dirimir as questões resultantes da execução do presente contrato, obrigando-se a parte vencida para à vencedora.


            Estando assim justas e convencionadas, as partes assinam o presente instrumento particular de contrato de locação residencial, em [/Sobre o contrato/Número de vias a serem assinadas] vias originais, na presença das testemunhas abaixo assinadas.


            [/Sobre o contrato/Local/Cidade]/[/Sobre o contrato/Local/Estado], [/Sobre o contrato/Data em que será assinado].

            _______________________
            [/Partes/Locador/Nome]

            _______________________
            [/Partes/Locatário/Nome]


            Testemunhas:

            _______________________
            [/Sobre o contrato/Testemunhas/Nome Testemunha 1]


            _______________________
            [/Sobre o contrato/Testemunhas/Nome Testemunha 2]


            """
        
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
            "Endereço": ValueTypeOrder(value: UploadTemplatesServices.endereco, type: "dict", order: 0).toDict(),
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
            "Número de vias a serem assinadas": ValueTypeOrder(value: "", type: "string", order: 2).toDict(),
            "Data em que será assinado": ValueTypeOrder(value: "", type: "string", order: 3).toDict()
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
