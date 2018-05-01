//
//  LoginViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hiding navigation bar
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // LoginButton will be enabled after all fields are filled
        self.loginButton.isUserInteractionEnabled = false
        
        self.setUpTextfields()
        self.setUpKeyboard()
    }
    
    
    /// Sets up textfields
    func setUpTextfields() {
        
        // Adding target to textfields
        self.emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        // Setting this view controller as textfields delegate
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    
    /// Sets up the events of keyboard showing and hiding
    func setUpKeyboard() {
        
        // Adding notification that will call selector methods when keyboard appears and disappears
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Hiding keyboard when tapping outside it
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
}
    

// Dealing with buttons and segues
extension LoginViewController {
    
    /// Tries to log user in: checks if email/password are not nil, then fetches user from DB. If user email exists on DB and password matches, then logs user in and perform segue to Mais Screen (Documents Screen).
    @IBAction func attemptToLogin() {
        self.loginButton.isUserInteractionEnabled = false
        self.loginButton.isHighlighted = true
        
        let userEmail = self.emailTextField.text!
        
        // Attempts to make database and in-app login
        AuthServices.attemptToLogin(email: userEmail, password: passwordTextField.text!) {
            (loginError) in
            
            // If error occurred, present it to the user
            if let error = loginError {
                self.handlesLoginError(error: error)
                self.loginButton.isUserInteractionEnabled = true
                self.loginButton.isHighlighted = false
                return
            }
            
            // Loading main user object
            AppShared.isLoadingUser.value = true
            UserServices.loadMainUser(email: userEmail) {
                (loginError) in
                
                // If error occurred, present it to the user
                if loginError != nil {
                    // TODO: log user out if error
                    print("-> WARNING: EasyDocQueryError.observeValue @ LoginViewController.attemptToLogin()")
                    return
                }
            }
            
            // After login successful, go to main tab bar
            self.goToMainTabBar()
        }
    }
    
    
    /// Moves to sign up view controller
    @IBAction func goToSignUpScreen() {
        self.performSegue(withIdentifier: SegueIds.signUp.rawValue, sender: nil)
    }
    
    
    /// Moves to main screen view controller
    func goToMainTabBar() {
        // TODO: comment lul
        self.navigationController?.removeFromParentViewController()
        self.performSegue(withIdentifier: SegueIds.mainTabBar.rawValue, sender: nil)
    }
    
}


// Keyboard and textfield related functions
extension LoginViewController: UITextFieldDelegate {
    
    /// Checks if email and password fields are not empty
    func checkInputs() -> Bool {
        if let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            return true
        }
        
        return false
    }
    
    
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
        
        return true
    }
    
    
    /// Called everytime a text field is edited and enables login button to be pressed only after all fields are filled
    @objc func editingChanged(_ textField: UITextField) {
        self.loginButton.isUserInteractionEnabled = self.checkInputs()
        return
    }
    
    
    /// Method called when keyboard will be showed
    @objc func keyboardWillShow(notification: NSNotification) {
        
        // Getting keyboard size
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        // Setting scrollview's content inset with bottom respecting keyboard's height
        let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
        
        let loginButtonFrame = self.loginButton.superview!.convert(self.loginButton.frame, to: self.view)
        
        // Scrolling view to make login button visible
        self.scrollView.scrollRectToVisible(loginButtonFrame, animated: true)
    }
    
    
    /// Method called when keyboard will be hidden
    @objc func keyboardWillHide(notification: NSNotification) {
        
        // Scrolling scroll view to initial position
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        
    }
    
}


// Handling errors
extension LoginViewController {
    
    /// Handles login error and present it to user
    func handlesLoginError(error: EasyDocError) {
        
        var alert: UIAlertController
        
        switch error {
            
            case EasyDocQueryError.networkError:
                alert = UIAlertController(title: "Erro de conexão", message: "Verifique sua conexão com a internet e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
            
            case EasyDocAuthError.userNotFound:
                alert = UIAlertController(title: "Usuário não encontrado", message: "Não foi possível encontrar nenhum usuário com o email especificado.", preferredStyle: UIAlertControllerStyle.alert)
            
            case EasyDocAuthError.wrongPassword:
                alert = UIAlertController(title: "Senha incorreta", message: "A senha inserida está incorreta. Tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
            
            default:
                alert = UIAlertController(title: "Usuário não encontrado", message: "Houve um erro ao tentar realizar seu login. Se o problema persistir procure contatar um administrador do sistema.", preferredStyle: UIAlertControllerStyle.alert)
            
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        // Erasing previous password
        passwordTextField.text = ""
        self.loginButton.isUserInteractionEnabled = self.checkInputs()
    }
    
}
