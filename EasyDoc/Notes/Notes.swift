//
//  Notes.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

/*
 
 TODO
    - Codar tela que vai mostrar os fields do contrato
        - Mudar o tipo dos fields de Document e Template para [Field]
        - Fazer código parsear corretamente os fields de um contrato recursivamente por profundidade (for pegando todos os fields filhos do root [key, order, type], sendo que se type for "dict", então chama a funcao novamente para ler os fields do value, senao, então retorna field com valor truzao)
    - Incluir fontes: Calibri e Champagne & Limousine
    - Present loading indicator (Documents/Templates VC)
 
 Fontes
    - Incluir fontes: Calibri e Champagne & Limousine
 
 Transição de telas
    * Perform segue da Login para a SignUp screens: ir da esquerda para a direita (nao abrir de baixo para cima)
    * Qual transição de tela utilizar ao abrir a TemplatesVC? (default)
 
 SearchBar
    * Colocar search bar abaixo da Navigation Bar (DocumentsVC e Templates VC)
 
 Input usuário
    * Como o usuário fará os inputs das informações?
        - IDEIA: expandir célula para baixo e abrir um textfield para o usuário editar a informação da célula
        - PROVAVEL: abre alerta de início pra economizar tempo
 
 Banco de dados
 - Criar types: RG, CPF, Estado Civil, Nacionalidade, 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */
