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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 25
        loginButton.clipsToBounds = true
        
        newAccountButton.layer.cornerRadius = 25
        newAccountButton.clipsToBounds = true
    }
    
    func createNewAccountAlert() {
        var nameTextField = UITextField()
        var emailTextField = UITextField()
        var phoneNumberTextField = UITextField()
        var passwordTextField = UITextField()
        
        let alert = UIAlertController(title: "New Account", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
            nameTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Email"
            emailTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Phone Number"
            phoneNumberTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Password"
            textField.isSecureTextEntry = true
            passwordTextField = textField
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { (sender) in
            guard let name = nameTextField.text,
                let email = emailTextField.text,
                let phoneNumber = phoneNumberTextField.text,
                let password = passwordTextField.text
                else { return }
            
            if name != "" && email != "" && phoneNumber != "" && password != "" {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil{
                        DispatchQueue.main.async {
                            //guard let userID = user?.uid else { return }
                            UserController.shared.updateUser(WithName: name, email: email, userID: phoneNumber)
                            UserController.shared.updateFirebaseUser(completion: {})
                            self.canSegue = true
                            self.performSegue(withIdentifier: "toNewAccount", sender: sender)
                        }
                    } else  {
                        if let error = error {
                            // Alert with message describing error
                            print("error creating account: \(error)")
                        }
                    }
                })
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
        
        let alert = UIAlertController(title: "Login", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Email"
            emailTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Password"
            textField.isSecureTextEntry = true
            passwordTextField = textField
        }
        
        let createAction = UIAlertAction(title: "Login", style: .default) { (sender) in
            guard let email = emailTextField.text,
                let password = passwordTextField.text
                else { return }
            
            if email != "" && password != "" {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil {
                        DispatchQueue.main.async {
                            //guard let userID = user?.uid else { return }
                            UserController.shared.fetchUser(withID: (user?.phoneNumber)!, completion: {} )
                            self.canSegue = true
                            self.performSegue(withIdentifier: "toLogin", sender: sender)
                        }
                    } else  {
                        if let error = error {
                            // Alert with message describing error
                            print("error logging in: \(error)")
                        }
                    }
                })
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
    
}
