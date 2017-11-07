//
//  LoginViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/28/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var canSegue: Bool = false
    let digits = CharacterSet.decimalDigits
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 22
        loginButton.clipsToBounds = true
        
        newAccountButton.layer.cornerRadius = 20
        newAccountButton.clipsToBounds = true
    }
    
    func createNewAccountAlert() {
        var nameTextField = UITextField()
        var emailTextField = UITextField()
        var phoneNumberTextField = UITextField()
        var passwordTextField = UITextField()
        
        let alert = UIAlertController(title: "New Account", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            nameTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            emailTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Phone Number (10 digits)"
            phoneNumberTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            passwordTextField = textField
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { (sender) in
            guard let name = nameTextField.text,
                let email = emailTextField.text,
                let phoneNumber = phoneNumberTextField.text,
                let password = passwordTextField.text
                else { return }
            
            if name != "" && email != "" && phoneNumber != "" && password != "" && phoneNumber.characters.count == 10 {
                for char in phoneNumber.unicodeScalars {
                    if !self.digits.contains(char) {
                        self.presentAlert(withName: "Only numbers can be used when entering a phone number")
                        return
                    }
                }
                
                UserController.shared.fetchNumber(withID: phoneNumber, completion: { (success) in
                    if success {
                        self.presentAlert(withName: "Number already in use")
                        return
                    } else {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if user != nil{
                                DispatchQueue.main.async {
                                    UserController.shared.saveToUserDefaults(value: phoneNumber)
                                    UserController.shared.updateUser(WithName: name, email: email, userID: phoneNumber)
                                    UserController.shared.updateFirebaseUser(completion: {})
                                    self.canSegue = true
                                    self.performSegue(withIdentifier: "toNewAccount", sender: sender)
                                }
                            } else  {
                                if let error = error {
                                    self.presentAlert(withName: error.localizedDescription)
                                }
                            }
                        })
                    }
                })
                
            } else {
                if phoneNumber.characters.count != 10 {
                    self.presentAlert(withName: "Please make sure the phone number is 10 digits and no puncutation is used")
                } else {
                    self.presentAlert(withName: "Please make sure all fields are filled out correctly")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func createLoginAlert() {
        var emailTextField = UITextField()
        var passwordTextField = UITextField()
        var phoneNumberTextField = UITextField()
        
        let alert = UIAlertController(title: "Login", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            emailTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            passwordTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Phone Number (10 digits)"
            phoneNumberTextField = textField
        }
        
        let createAction = UIAlertAction(title: "Login", style: .default) { (sender) in
            guard let email = emailTextField.text,
                let password = passwordTextField.text,
                let phoneNumber = phoneNumberTextField.text
                else { return }
            
            if email != "" && password != "" && phoneNumber != "" && phoneNumber.characters.count == 10 {
                for char in phoneNumber.unicodeScalars {
                    if !self.digits.contains(char) {
                        self.presentAlert(withName: "Only numbers can be used when entering a phone number")
                        return
                    }
                }
                
                UserController.shared.fetchNumber(withID: phoneNumber, completion: { (success) in
                    if UserController.shared.mockUser.email != email {
                        self.presentAlert(withName: "Incorrect email or phone number")
                        return
                    } else {
                        if success {
                            UserController.shared.fetchUser(withID: phoneNumber, completion: {
                                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                    if user != nil {
                                        DispatchQueue.main.async {
                                            UserController.shared.saveToUserDefaults(value: phoneNumber)
                                            UserController.shared.fetchUser(withID: phoneNumber, completion: {} )
                                            self.canSegue = true
                                            self.performSegue(withIdentifier: "toLogin", sender: sender)
                                        }
                                    } else {
                                        if let error = error {
                                            self.presentAlert(withName: error.localizedDescription)
                                        }
                                    }
                                })
                            })
                        } 
                    }
                })
                
            } else {
                if phoneNumber.characters.count != 10 {
                    self.presentAlert(withName: "Please make sure the phone number is 10 digits and no puncutation is used")
                } else {
                    self.presentAlert(withName: "Please make sure all fields are filled out correctly")
                }
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        createLoginAlert()
    }

    @IBAction func newAccountButtonPressed(_ sender: Any) {
        createNewAccountAlert()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let identifier = identifier {
            if identifier == "toNewAccount" || identifier == "toLogin" {
                if !canSegue {
                    return false
                }
            }
        }
        return true
    }
    
    func presentAlert(withName name: String) {
        
        let alert = UIAlertController(title: name, message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
}
