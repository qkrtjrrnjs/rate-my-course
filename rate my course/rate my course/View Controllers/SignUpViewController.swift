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
import ElasticTransition

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var emailField:             SkyFloatingLabelTextField!
    var passwordField:          SkyFloatingLabelTextField!
    var verifyPasswordField:    SkyFloatingLabelTextField!

    var transition              = ElasticTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize button
        customizeButton(button: signUpButton, cornerRadius: 5, color: UIColor(hexString: "#30323d"), yValue: 1.3)
        customizeButton(button: cancelButton, cornerRadius: 5, color: UIColor(hexString: "#30323d"), yValue: 1.5)
        
        //custom textfields
        emailField = SkyFloatingLabelTextField(frame: CGRect.zero)
        customizeTextField(
            textField           : emailField,
            x                   : self.view.center.x,
            y                   : self.view.center.y / 1.8,
            width               : self.view.frame.size.width / 1.7,
            height              : 50,
            placeholder         : "Email",
            title               : "Email",
            titleColor          : .black,
            selectedTitleColor  : .black,
            errorColor          : .red,
            isSecureTextEntry   : false,
            functionName        : "emailFieldDidChange:"
        )
        
        passwordField = SkyFloatingLabelTextField(frame: CGRect.zero)
        customizeTextField(
            textField: passwordField,
            x                   : self.view.center.x,
            y                   : self.view.center.y / 1.3,
            width               : self.view.frame.size.width / 1.7,
            height              : 50,
            placeholder         : "Password",
            title               : "Password",
            titleColor          : .black,
            selectedTitleColor  : .black,
            errorColor          : .red,
            isSecureTextEntry   : true,
            functionName        : "passwordFieldDidChange:"
        )
        
        verifyPasswordField = SkyFloatingLabelTextField(frame: CGRect.zero)
        customizeTextField(
            textField: verifyPasswordField,
            x                   : self.view.center.x,
            y                   : self.view.center.y,
            width               : self.view.frame.size.width / 1.7,
            height              : 50,
            placeholder         : "Verify Password",
            title               : "Verify Password",
            titleColor          : .black,
            selectedTitleColor  : .black,
            errorColor          : .red,
            isSecureTextEntry   : true,
            functionName        : "verifyPasswordFieldDidChange:"
        )
        
        self.view.backgroundColor = .white
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func customizeTextField(textField: SkyFloatingLabelTextField, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, placeholder: String, title: String, titleColor: UIColor, selectedTitleColor: UIColor, errorColor: UIColor, isSecureTextEntry: Bool, functionName: String){
        
        textField.delegate              = self
        textField.frame.size.height     = height
        textField.frame.size.width      = width
        textField.center.x              = x
        textField.center.y              = y
        textField.placeholder           = placeholder
        textField.title                 = title
        textField.titleColor            = titleColor
        textField.selectedTitleColor    = selectedTitleColor
        textField.errorColor            = errorColor
        textField.isSecureTextEntry     = isSecureTextEntry
        textField.addTarget(self, action: Selector(functionName), for: .editingChanged)
        self.view.addSubview(textField)
    }
    
    func customizeButton(button: UIButton, cornerRadius: Int, color: UIColor, yValue: CGFloat){
        button.layer.cornerRadius       = CGFloat(cornerRadius)
        button.backgroundColor          = color
        button.tintColor                = .white
        button.frame.size.width         = self.view.frame.size.width / 1.6
        button.frame.size.height        = 50
        button.center.x                 = self.view.center.x
        button.center.y                 = self.view.center.y * yValue
    }
    
    func signUpVerification(){
        emailField.errorMessage             = ""
        passwordField.errorMessage          = ""
        verifyPasswordField.errorMessage    = ""
        
        if passwordField.text! == verifyPasswordField.text!{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                if error == nil && authResult != nil{
                    Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { [weak self] user, error in
                        if error == nil && user != nil{
                            UserDefaults.standard.set(true, forKey: "userlogin")
                            //this needs change
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
            passwordField.errorMessage          = "Passwords do not match!"
            verifyPasswordField.errorMessage    = "Passwords do not match!"
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        signUpVerification()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        signUpVerification()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpToInitial"{
            //transition customization
            transition.edge     = .left
        }
        else{
            //transition customization
            transition.edge     = .right
        }
        
        transition.sticky                           = false
        segue.destination.transitioningDelegate     = transition
        segue.destination.modalPresentationStyle    = .custom
    }

}
