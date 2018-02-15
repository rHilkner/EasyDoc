//
//  ViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LoginButton will be enabled after all fields are filled
        loginButton.isEnabled = false
        
        // Adding target to textfields
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        // Setting textfields as their own delegates
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    
    /// Called everytime a text field is edited and enables login button to be pressed only after all fields are filled.
    @objc func editingChanged(_ textField: UITextField) {
        if self.checkInputs() {
            self.loginButton.isEnabled = true
            return
        }
        
        self.loginButton.isEnabled = false
    }
    
    func checkInputs() -> Bool {
        if let email = emailTextField.text, !email.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
            return true
        }
        
        return false
    }
    

    /// Moves to sign up view controller
    @IBAction func goToSignUpScreen() {
        // TODO: go to sign up screen sliding right
        performSegue(withIdentifier: "SignUpScreenSegue", sender: nil)
    }
    
    
    /// Moves to main screen view controller
    func goToMainScreen() {
        self.performSegue(withIdentifier: "MainScreenSegue", sender: nil)
    }
    
    
    /// Tries to log user in: checks if email/password are not nil, then fetches user from DB. If user email exists on DB and password matches, then logs user in and perform segue to Mais Screen (Documents Screen).
    @IBAction func attemptToLogin() {
        self.loginButton.isEnabled = false
        
        let userEmail = self.emailTextField.text!
        
        // Attempts to make database and in-app login
        AuthServices.attemptToLogin(email: userEmail, password: passwordTextField.text!) {
            (loginError) in
            
            // If error occurred, present it to the user
            if let error = loginError {
                self.handlesLoginError(error: error)
                self.loginButton.isEnabled = true
                return
            }
            
            FetchingServices.loadMainUser(email: userEmail) {
                (loginError) in
                
                // If error occurred, present it to the user
                if loginError != nil {
                    // TODO: log user out if error
                    // self.handlesLoginError(error: error)
                    // self.loginButton.isEnabled = true
                    return
                }
            }
            
            self.goToMainScreen()
        }
    }
    
    
    /// Handles login error and present it to user.
    func handlesLoginError(error: EasyDocError) {
        switch error {
            
        case EasyDocQueryError.networkError:
            let alert = UIAlertController(title: "Erro de conexão", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        case EasyDocAuthError.userNotFound:
            let alert = UIAlertController(title: "Usuário não encontrado", message: "Não foi possível encontrar nenhum usuário com o email especificado.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        case EasyDocAuthError.wrongPassword:
            let alert = UIAlertController(title: "Senha incorreta", message: "A senha inserida está incorreta. Tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        default:
            let alert = UIAlertController(title: "Usuário não encontrado", message: "Houve um erro ao tentar realizar seu login. Se o problema persistir procure contatar um administrador do sistema.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        passwordTextField.text = ""
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    /// Called when return button is hit on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            
        // If return is tapped when on email text field, goes to password text field
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        
        // If return is tapped when on password text field, dismiss keyboard
        case self.passwordTextField:
            self.passwordTextField.resignFirstResponder()
            
            if let password = passwordTextField.text, !password.isEmpty {
                self.attemptToLogin()
            }
            
        // Prints error otherwise
        default:
            print("-> WARNING: ", EasyDocGeneralError.unexpectedError.localizedDescription)
        }
        
        return false
    }
}
