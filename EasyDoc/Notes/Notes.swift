//
//  Notes.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

/*
 
 DESCRIPTION
 
 O EasyDoc é uma plataforma para organização e máxima otimização na geração de contratos, acordos e documentos. Na nossa versão beta para iOS o usuário pode adicionar algum dos contratos de nosso acervo aos seus documentos e através do preenchimento de campos de texto específicos sobre os dados do contrato (partes, valores, datas, etc.) nosso sistema apresenta o contrato totalmente preenchido para o usuário.
 
 BUGS
    - Consertar Unwind Segue (popar pro root, depois mudar de view na tab bar)
    - Se logout+login 2x -> DocumentViewController fica sem título O.o
    - Memory leak após logout/login
 
 TODO CHATO
    - Bolar descritivo do fluxo do EasyDoc Web, revisar com o Renato e depois falar com os designers
    - Documentação
    - Acabar com a variável global dos templates e main user (aprender a salvá-los no user defaults)
 
 REDESIGN
    - Falar com a galera do studio
    - Como avisar para um usuário que o app está sem conexão com a internet?
    - Maneira ideal de deixar intuitivo para o usuário sobre como adicionar um template aos seus contratos?
        - Aba para loja de templates
 
 
 EASYDOC v0.2
    - Barras de busca para documentos e templates
    - Formatação do texto (base em html? css? como funciona essas coisaaaaAA)
    - Compartilhamento de arquivos em pdf
 
 
 VERSÃO BETA 1.0 - A volta dos que não foram
    - Salvar documentos localmente (core data) para que o usuário possa interagir com os contratos mesmo offline
        - Ao se conectar de novo com a internet, caso o usuário tenha modificado o documento offline, sobrescrever o banco de dados com o documento mais recente
    - Inserção de mais contratos no nosso banco de dados
        - Pensar em maneiras mais simples de realizar o upload de templates para o banco (criar app só de backend para isso? parece uma boa pra manter toda estrutura de upload lá)
    - Modificar maneira de input do usuário
        - Expandir célula para baixo e abrir um textfield para o usuário editar a informação da célula)
    - Criar
        - field.types: RG, CPF, Estado Civil, Nacionalidade, etc; para melhorar formatação do input do usuário
        - field.placeholder: mensagem pra quando field.value == nil
        - field.comment: comentário sobre a definição do que se espera no field
 
 
 VERSÃO BETA 1.1 - Renegades
    - Compartilhamento de documentos in-app
    - Notificações (in-app e push)
    - OCR
        - Digitalizar documento
        - Identificar e ler campos
 
 VERSÃO BETA 2.0
    - Redesign
    - Monetização
    - 
 
 
 
 */
