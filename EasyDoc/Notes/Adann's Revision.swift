//
//  Addan's Revision.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 16/04/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

/*
 
 ----- MATERIAL DE APOIO -----
 * Principais tags pra documentação em swift: https://www.appcoda.com/swift-markdown/
 
 
 ----- ARQUIVOS INSPECIONADOS -----
 
 Front-end/Controllers/Settings/SettingsTableViewController.swift [98 linhas]
 Back-end/Upload Templates/UploadTemplatesServices.swift [266 linhas]
 Front-end/Controllers/Templates/TemplateFieldTableViewController.swift [171 linhas]
 Front-end/Controllers/Documents/DocumentsViewController.swift [267]
 Front-end/Controllers/Login & SignUp/LoginViewController.swift [229 linhas]
 
 
 ----- LEGENDA -----
 1 - Documentação
 2 - Boas maneiras
 3 - Typo/Misplace/Excesso de código
 4 - Centralizar alertas
 5 - Tratamento de erros
 6 - Erro de código
 * - Wrong finding
 
 
 ----- DÚVIDAS -----
 - Definir constantes da tableview (height for row at, sections) no header?
 - É ruim dar return com valor atribuído diretamente na resposta?
 - Forçar logout direito: AuthServices.attemptToLogout() deve continuar devolvendo erro caso usuário não consiga logoutar apropriadamente ou deve apenas realizar logout in-app de qualquer forma e mandar o usuário para a loginScreen?
 - Todas as classes view controllers têm o método viewdidload, mas a classe das settings não o usa... é melhor manter pelo padrão ou tirar pelo excesso de código desnecessário?
 - Da mesma maneira: manter numberOfSections() retornando 1 ou excluir a função? Adiciona clareza ao código ou causa excesso de código?
 - Como verificar se AppShared.mainUser != nil? O ideal seria ver no viewdidload e guardar instância do usuário, fazendo com que a função sobreviva mesmo se a variável global for modificada? Passar usuário sempre por parâmetro pra dentro de cada classe (tirar variável global)?
 - Ver **
 
 
 ----- FINDINGS -----
 
 ########## SettingsTableViewController ##########
 1 - (21): detalhar parâmetros no comentário
 **2 - (26): evitar dar return com valor atribuído diretamente na resposta. Sugiro trabalhar com a tableView estática ou definir esses valores como constantes nos atributos da classe. Ajuda na manutenção e legibilidade do código
 2 - (31): evitar dar return com valor atribuído diretamente na resposta...
 3 - (40): o método didSelectRowAt é do protocolo delegate e na descrição MARK da extension diz que você está inserindo protocolos data source. É interessante separar tanto o data source como o delegate em extensions quando estamos trabalhando com tableView, collectionView, etc.
 ** - (40): por que foi feito um deselect no método didSelect? Também tem o didDeselectRowAt
 1 - (51): detalhar parâmetros no comentário
 4 - (58): usar informação a partir de um arquivo com as strings de Alert, isso pode facilitar nas traduções do localized
 4 - (61): usar informação a partir de um arquivo com as strings de Alert, isso pode facilitar nas traduções do localized
 **5 - (68): o erro (logout) é printado, se ocorrer, mas não é tratado ou dado algum feedback para o usuário
 4 - (76): usar informação a partir de um arquivo com as strings de Alert, isso pode facilitar nas traduções do localized
 
 ########## TemplateFieldTableViewController ##########
 1 - (11): sugestão - usar // MARK: na classe também, explicando o propósito dela e definindo os parâmetros
 4,5 - (20): sugestão - fazer um alert pra avisar o usuário que não foram carregados os campos, mostrando o problema
 3 - (35): o método heightForRowAt é delegate e não data source como diz no comentário da extension. É interessante separar tanto o data source como o delegate em extensions quando estamos trabalhando com tableView, collectionView, etc.
 * - (51): sua solução para definir as sections usando switch ficou muito boa [easter egg]!
 3 - (117): o método didSelectRowAt é delegate e não data source como diz no comentário da extension . É interessante separar tanto o data source como o delegate em extensions quando estamos trabalhando com tableView, collectionView, etc.
 
 ########## DocumentsViewController ##########
 1 - (11): sugestão - usar // MARK: na classe também, explicando o propósito dela e definindo os parâmetros
 3 - (21): o método viewDidLoad não está sendo usado, da pra economizar algumas linhas de código se você tirar
 5 - (73): o erro é printado, se ocorrer, mas não é tratado ou dado algum feedback para o usuário
 **6 - (86): se a instância de mainUser devolver nil o código não vai travar nessa linha e no if da 88?
        -> "Não acho que isso é possível (mainUser = nil), porém ver com o Guga"
 1 - (104): é interessante separar tanto o data source como o delegate em duas extensions diferentes quando estamos trabalhando com tableView, collectionView, etc.
 1 - (104): padronizar os comentários das funções/métodos dessa extension
 2 - (108): evitar dar return com valor atribuído diretamente na resposta. Sugiro definir o valor como constante nos atributos da classe.
 3 - (120): por padrão o método numberOfSections tem como default 1, então não precisa instanciá-lo ou, no caso, definir o valor como constante nos atributos da classe.
 4 - (225): usar informação a partir de um arquivo com as strings de Alert, isso pode facilitar nas traduções do localized
 4 - (259): usar informação a partir de um arquivo com as strings de Alert, isso pode facilitar nas traduções do localized
 4 - (261): usar informação a partir de um arquivo com as strings de Alert, isso pode facilitar nas traduções do localized
 
 ########## LoginViewController ##########
 1 - (11): sugestão - usar // MARK: na classe também, explicando o propósito dela e definindo os parâmetros
 **6 - (71): no lugar do force unwrap pra trabalhar com os textos do textField, da pra instanciar userEmail com guard let
        -> [tirar dúvida sobre erro especifico]
 **6 - (74): pensar no guard let no lugar do force unwrap também
 **5 - (90): o erro (logout) é printado, se ocorrer, mas não é tratado ou dado algum feedback para o usuário
 4 - (204): usar informação a partir de um arquivo com as strings de Alert, isso pode facilitar nas traduções do localized
 4 - (220): usar informação a partir de um arquivo com as strings de Alert, isso pode facilitar nas traduções do localized
 1 - (?): sugestão - padronizar os comentários nas funções e na classe
 
 ########## UploadTemplatesServices ##########
 (23): sugestão - usar map ou reduce pra transformar os dados de entrada em um dictionary, mas por questão de performance pode ser interessante iterar num for já que é O(n) e tem poucas iterações
 (107): rever comentário
 (37): idioma - considerando que a maioria do código está em inglês; traduzir do português
 (38): subir colchete
 (50): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (51): subir colchete
 (61): detalhar parâmetros no comentário
 (79): detalhar parâmetros no comentário
 (88): ajustar indentação
 (91): validar o retorno de erro, por que não foi pro EasyDocQueryError?
 (105): detalhar parâmetros no comentário
 (106): Guga Lima diz: get é padrão do java. Swift não usa set/get. Saudades gerador de get/set :(
 (107): rever comentário
 (111): rever comentário
 (113): sugestão - usar um arquivo helper e instanciar o "Contrato de Locação Residencial" nesse arquivo, assim você economiza muitas linhas de código por arquivo e facilita a manutenção. Outra opção é criar um JSON com o conteúdo dos documentos, que também vai te ajudar na manutenção e legibilidade, no entanto o contrato vai ficar mockado no projeto, se isso não for interessante por causa de business, da pra fazer uma API pra consumir um JSON externo pelo próprio Fire Base.
 (192): rever comentário
 (194): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (201): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (206): rever comentário
 (208): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (214): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (221): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (226): rever comentário
 (228): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (233): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (233): pode ser mais interessante ter um indicador da quantidade de testemunhas, então construir um array de tamanho variável
 (238): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (245): rever comentário (mas eu entendo muito a sensação)
 (248): subir colchete
 (256): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (262): idioma - considerando que a maioria do código está em inglês, traduzir do português
 (?): os dicionários são instanciados com as strings em português, sugiro montar um arquivo helper e deixar tudo em inglês, isso pode facilitar nas traduções do localized. Pensar em usar um idioma que não tenha acentos, já que está usando Fire Base.
 (?): faltou comentar as classes e algumas funções, mas os comentários estão claros e concisos. Sugiro usar // MARK: nas extensions e nas classes.
 
 

 
 
 
 
 
 
 
 
 */
