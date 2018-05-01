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
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hiding navigation bar
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // SignUpButton will be enabled after all fields are filled
        self.signUpButton.isUserInteractionEnabled = false
        
        // Initializing error label as hidden
        self.errorLabel.isHidden = true
        
        self.setUpTextfields()
        self.setUpKeyboard()
    }
    
    
    /// Sets up textfields
    func setUpTextfields() {
        
        // Adding target to textfields
        self.emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.confirmPasswordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        // Setting this view controller as textfields delegate
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
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
extension SignUpViewController {
    
    /// Tries to sign user up: checks if email/password are not nil and valid to the system. Then will try to sign user in to DB and if user email isn't already signed up, his signing up will be complete and user will be loged in the app.
    @IBAction func attemptToSignUp() {
        
        self.signUpButton.isUserInteractionEnabled = false
        self.signUpButton.isHighlighted = true
        
        // Checks if user is not existent on DB and if adding new user is successful
        AuthServices.attemptToSignUp(email: emailTextField.text!, password: passwordTextField.text!) {
            (signUpError) in
            
            if signUpError != nil {
                self.signUpButton.isUserInteractionEnabled = true
                self.signUpButton.isHighlighted = false
                return
            }
            
            // In case of success, go to main screen
            self.goToMainTabBar()
        }
    }
    
    
    /// Moves to login screen
    @IBAction func goToLoginScreenButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /// Moves to main screen view controller
    func goToMainTabBar() {
        self.navigationController?.removeFromParentViewController()
        self.performSegue(withIdentifier: SegueIds.mainTabBar.rawValue, sender: nil)
    }
}


// Keyboard and textfield related functions
extension SignUpViewController: UITextFieldDelegate {
    
    func checkInputs() -> Bool {
        if let email = emailTextField.text, ErrorHandling.isValidEmail(email),
            let password = passwordTextField.text, ErrorHandling.isValidPassword(password),
            let confirmPassword = confirmPasswordTextField.text,
            password == confirmPassword {
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
        
        return true
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
            if self.confirmPasswordTextField.text != self.passwordTextField.text {
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
        self.signUpButton.isUserInteractionEnabled = self.checkInputs()
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
        
        let signUpButtonFrame = self.signUpButton.superview!.convert(self.signUpButton.frame, to: self.view)
        
        // Scrolling view to make login button visible
        self.scrollView.scrollRectToVisible(signUpButtonFrame, animated: true)
    }
    
    
    /// Method called when keyboard will be hidden
    @objc func keyboardWillHide(notification: NSNotification) {
        
        // Scrolling scroll view to initial position
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        
    }
}
