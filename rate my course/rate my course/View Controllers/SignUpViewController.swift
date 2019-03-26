//
//  SignUpViewController.swift
//  rate my course
//
//  Created by chris on 3/25/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController {
    
    var emailField: SkyFloatingLabelTextField!
    var passwordField: SkyFloatingLabelTextField!
    var verifyPasswordField: SkyFloatingLabelTextField!


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
        
        verifyPasswordField = SkyFloatingLabelTextField(frame: CGRect(x: self.view.bounds.size.width / 4.2, y: self.view.bounds.size.height / 2.1, width: self.view.bounds.size.width / 1.8, height: self.view.bounds.size.height / 15))
        verifyPasswordField.placeholder         = "Verfiy Password"
        verifyPasswordField.title               = "Verfiy Password"
        verifyPasswordField.titleColor          = UIColor.black
        verifyPasswordField.selectedTitleColor  = UIColor.black
        verifyPasswordField.errorColor          = UIColor.red
        verifyPasswordField.isSecureTextEntry   = true
        verifyPasswordField.addTarget(self, action: #selector(verifyPasswordFieldDidChange(_:)), for: .editingChanged)
        self.view.addSubview(verifyPasswordField)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUp(_ sender: Any) {
        emailField.errorMessage = ""
        passwordField.errorMessage = ""
        verifyPasswordField.errorMessage = ""
        
        if passwordField.text! == verifyPasswordField.text!{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                if error == nil && authResult != nil{
                    Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { [weak self] user, error in
                        if error == nil && user != nil{
                            self!.performSegue(withIdentifier: "SignUpToStream", sender: self)
                        }
                    }
                }else{
                    if error!.localizedDescription == "The email address is badly formatted."{
                        self.emailField.errorMessage = "Invalid email address"
                    }
                    
                    if error!.localizedDescription == "The password must be 6 characters long or more."{
                        self.passwordField.errorMessage = "Invalid password"
                    }
                }
            }
        }
        else{
            passwordField.errorMessage = "Passwords do not match!"
            verifyPasswordField.errorMessage = "Passwords do not match!"
        }
    }
    
    @objc func emailFieldDidChange(_ textfield: UITextField) {
        emailField.errorMessage = ""
    }
    
    @objc func passwordFieldDidChange(_ textfield: UITextField) {
        passwordField.errorMessage = ""
    }
    
    @objc func verifyPasswordFieldDidChange(_ textfield: UITextField) {
        verifyPasswordField.errorMessage = ""
    }

}
