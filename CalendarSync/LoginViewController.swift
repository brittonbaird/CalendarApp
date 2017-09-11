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

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        if email != "" && password != "" {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if user != nil {
                    DispatchQueue.main.async {
                        guard let userID = user?.uid else { return }
                        UserController.shared.fetchUser(withID: userID, completion: {} )
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

    @IBAction func newAccountButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            password != "" else { return }
        
        if name != "" && email != "" && password != "" {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if user != nil{
                    DispatchQueue.main.async {
                        guard let userID = user?.uid else { return }
                        UserController.shared.updateUser(WithName: name, email: email, userID: userID)
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
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "toNewAccount" || ident == "toLogin" {
                if !canSegue {
                    return false
                }
            }
        }
        return true
    }
    
}
