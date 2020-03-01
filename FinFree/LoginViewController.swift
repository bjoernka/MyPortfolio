//
//  LoginViewController.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 28/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let helpFunc = HelpFunctions()
    var userUID : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    func setupView()  {
        errorLabel.isHidden = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        
        loginButton.setTitle("Login", for: .normal)
        
        emailTextField.backgroundColor = UIColor.blue
        HelpFunctions.styleTextField(emailTextField)
        HelpFunctions.styleTextField(passwordTextField)
        HelpFunctions.styleFilledButton(loginButton)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                self.userUID = result?.user.uid
                self.transitionToHome()
            }
        }
    }
    
    func transitionToHome() {
        let homeVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeNav") as? HomeNavController
        if userUID != nil {
            UserIdent.userUID = userUID!
        }
        self.view.window?.rootViewController = homeVC
        self.view.window?.makeKeyAndVisible()
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
