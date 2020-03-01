//
//  StartViewController.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 28/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarTransparent()
        setupView()
    }
    
    func setupView() {
        loginButton.setTitle("Login", for: .normal)
        registerButton.setTitle("Sign up", for: .normal)
        
        HelpFunctions.styleFilledButton(registerButton)
        HelpFunctions.styleHollowButton(loginButton)
    }
    
    // Make navigationbar transparent
       func navigationBarTransparent() {
           self.navigationController?.navigationBar.isTranslucent = true
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           self.navigationItem.title = ""
           self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
       }

}
