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
import ElasticTransition

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var emailField: SkyFloatingLabelTextField!
    var passwordField: SkyFloatingLabelTextField!
    
    var transition = ElasticTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize button
        customizeButton(button: logInButton, cornerRadius: 5, color: UIColor(hexString: "#30323d"), yValue: 1.3)
        customizeButton(button: createButton, cornerRadius: 5, color: UIColor(hexString: "#30323d"), yValue: 1.5)
        
        //custom textfields
        emailField = SkyFloatingLabelTextField(frame: CGRect.zero)
        customizeTextField(
            textField           : emailField,
            x                   : self.view.center.x,
            y                   : self.view.center.y / 1.5,
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
            textField           : passwordField,
            x                   : self.view.center.x,
            y                   : self.view.center.y / 1.1,
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
    
    @objc func emailFieldDidChange(_ textfield: UITextField) {
        emailField.errorMessage = ""
    }
    
    @objc func passwordFieldDidChange(_ textfield: UITextField) {
        passwordField.errorMessage = ""
    }
    
    @IBAction func logIn(_ sender: Any) {
        logInValidation()
    }
    
    func logInValidation(){
        emailField.errorMessage     = ""
        passwordField.errorMessage  = ""
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] user, error in
            if error == nil && user != nil{
                UserDefaults.standard.set(true, forKey: "userlogin")
                //this needs change
                self?.performSegue(withIdentifier: "LogInToStream", sender: self)
            }else{
                if error!.localizedDescription == "The email address is badly formatted."{
                    self!.emailField.errorMessage = "Invalid email address"
                }
                
                if error!.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    self!.emailField.errorMessage       = "Non-existent account"
                    self!.passwordField.errorMessage    = "Password"
                }
                
                if error!.localizedDescription == "The password is invalid or the user does not have a password."{
                    self!.passwordField.errorMessage    = "Password"
                    self!.emailField.errorMessage       = "Email"
                }
                
                if error!.localizedDescription == "Too many unsuccessful login attempts.  Please include reCaptcha verification or try again later"{
                    self!.passwordField.errorMessage = "Wrong Password"
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        logInValidation()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInToSignUp"{
            transition.edge     = .top
        }
        else{
            transition.edge     = .right
        }
        transition.sticky                           = false
        segue.destination.transitioningDelegate     = transition
        segue.destination.modalPresentationStyle    = .custom
    }
    
}

