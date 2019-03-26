//
//  ViewController.swift
//  rate my course
//
//  Created by chris on 3/20/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField

class LogInViewController: UIViewController {
    
    
    var emailField: SkyFloatingLabelTextField!
    var passwordField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //custom textfields
        emailField = SkyFloatingLabelTextField(frame: CGRect(x: self.view.bounds.size.width / 4.2, y: self.view.bounds.size.height / 4, width: self.view.bounds.size.width / 1.8, height: self.view.bounds.size.height / 15))
        emailField.placeholder          = "Email"
        emailField.title                = "Email"
        emailField.titleColor           = UIColor.black
        emailField.selectedTitleColor   = UIColor.black
        emailField.errorColor           = UIColor.red
        emailField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: .editingChanged)
        self.view.addSubview(emailField)
        
        passwordField = SkyFloatingLabelTextField(frame: CGRect(x: self.view.bounds.size.width / 4.2, y: self.view.bounds.size.height / 2.8, width: self.view.bounds.size.width / 1.8, height: self.view.bounds.size.height / 15))
        passwordField.placeholder           = "Password"
        passwordField.title                 = "Password"
        passwordField.titleColor            = UIColor.black
        passwordField.selectedTitleColor    = UIColor.black
        passwordField.errorColor            = UIColor.red
        passwordField.isSecureTextEntry     = true
        passwordField.addTarget(self, action: #selector(passwordFieldDidChange(_:)), for: .editingChanged)
        self.view.addSubview(passwordField)
        
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func emailFieldDidChange(_ textfield: UITextField) {
        emailField.errorMessage = ""
    }
    
    @objc func passwordFieldDidChange(_ textfield: UITextField) {
        passwordField.errorMessage = ""
    }
    
    @IBAction func logIn(_ sender: Any) {
        emailField.errorMessage = ""
        passwordField.errorMessage = ""
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] user, error in
            if error == nil && user != nil{
                self?.performSegue(withIdentifier: "LogInToStream", sender: self)
            }else{
                if error!.localizedDescription == "The email address is badly formatted."{
                    self!.emailField.errorMessage = "Invalid email address"
                }
                
                if error!.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    self!.emailField.errorMessage = "Non-existent account"
                    self!.passwordField.errorMessage = "Password"
                }
                
                if error!.localizedDescription == "The password is invalid or the user does not have a password."{
                    self!.passwordField.errorMessage = "Password"
                    self!.emailField.errorMessage = "Email"
                }
                
                if error!.localizedDescription == "Too many unsuccessful login attempts.  Please include reCaptcha verification or try again later"{
                    self!.passwordField.errorMessage = "Wrong Password"
                }
                print(error!.localizedDescription)
            }
        }
    }
    
    
}

