//
//  SignUpViewController.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var centralView: UIView!
    var deltaY: CGFloat? = nil
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SignUpButton will be enabled after all fields are filled
        self.signUpButton.isEnabled = false
        
        // Initializing error label as hidden
        self.errorLabel.isHidden = true
        
        // Adding target to textfields
        self.emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.confirmPasswordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        // Setting textfields as their own delegates
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        // Adding notification that will call selector methods when keyboard appears and disappears
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    
    /// Moves to login screen
    @IBAction func goToLoginScreenButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Tries to sign user up: checks if email/password are not nil and valid to the system. Then will try to sign user in to DB and if user email isn't already signed up, his signing up will be complete and user will be loged in the app.
    @IBAction func attemptToSignUp() {
        self.signUpButton.isEnabled = false
        
        // Checks if user is not existent on DB and if adding new user is successful
        AuthServices.attemptToSignUp(email: emailTextField.text!, password: passwordTextField.text!) {
            (signUpError) in
            
            if signUpError != nil {
                self.signUpButton.isEnabled = true
                return
            }
            
            // In case of success, go to main screen
            self.performSegue(withIdentifier: "MainScreenSegue", sender: nil)
        }
    }
    
    
    func checkInputs() -> Bool {
        if let email = emailTextField.text, ErrorHandling.isValidEmail(email),
           let password = passwordTextField.text, ErrorHandling.isValidPassword(password),
           let confirmPassword = confirmPasswordTextField.text,
            password == confirmPassword {
            return true
        }
        
        return false
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    /// Called when return button is hit on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            
        // If return is tapped when on email text field, goes to password text field
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
            
        // If return is tapped when on password text field, goes to confirm password text field
        case self.passwordTextField:
            self.confirmPasswordTextField.becomeFirstResponder()
            
        // If return is tapped when on confirm password text field, dismiss keyboard
        case self.confirmPasswordTextField:
            self.confirmPasswordTextField.resignFirstResponder()
            
            if self.checkInputs() {
                self.attemptToSignUp()
            }
            
        // Prints error otherwise
        default:
            print("-> WARNING: ", EasyDocGeneralError.unexpectedError.localizedDescription)
        }
        
        return false
    }
    
    /// Called everytime a text field ends editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
            
        // Verifying if email input is valid
        case self.emailTextField:
            if Int(self.emailTextField.text!.count) > 0 {
                if  !ErrorHandling.isValidEmail(textField.text!) {
                    self.errorLabel.text = "O email está em formato inválido."
                    self.errorLabel.isHidden = false
                } else {
                    self.errorLabel.isHidden = true
                }
            }
            
        // Verifying if password input is valid
        case self.passwordTextField:
            if Int(self.passwordTextField.text!.count) > 0 {
                if !ErrorHandling.isValidPassword(self.passwordTextField.text!) {
                    self.errorLabel.text = "A senha deve conter entre 6 e 20 caracteres."
                    self.errorLabel.isHidden = false
                } else {
                    self.errorLabel.isHidden = true
                }
            }
            
        // Verifying if confirmed password input is valid
        case self.confirmPasswordTextField:
            if self.confirmPasswordTextField.text == self.passwordTextField.text {
                self.errorLabel.text = "Os campos de senha estão diferentes."
                self.errorLabel.isHidden = false
            } else {
                self.errorLabel.isHidden = true
            }
            
        // Prints error otherwise
        default:
            print("-> WARNING: ", EasyDocGeneralError.unexpectedError.localizedDescription)
            
        }
    }
    
    
    /// Called everytime a text field is edited and enables login button to be pressed only after all fields are filled.
    @objc func editingChanged(_ textField: UITextField) {
        if self.checkInputs() {
                self.signUpButton.isEnabled = true
                return
        }
        
        self.signUpButton.isEnabled = false
    }
    
    
    /// Method called when keyboard will be showed
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                let signUpButtonY = centralView.convert(signUpButton.frame.origin, to: self.view).y
                let signUpButtonHeight = signUpButton.frame.size.height
                let signUpButtonBottom = signUpButtonY + signUpButtonHeight
                let superviewHeight = self.view.frame.maxY
                let distanceToBottomScreen = superviewHeight - signUpButtonBottom
                
                self.deltaY = keyboardSize.height - distanceToBottomScreen + 18
                
                self.view.frame.origin.y -= self.deltaY!
            }
        }
    }
    
    
    /// Method called when keyboard will be hidden
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += self.deltaY!
        }
    }
}
