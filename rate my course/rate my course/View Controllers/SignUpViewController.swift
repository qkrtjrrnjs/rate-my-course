//
//  SignUpViewController.swift
//  rate my course
//
//  Created by chris on 3/25/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var verifyPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
            if error == nil && authResult != nil{
                self.performSegue(withIdentifier: "SignUPToStream", sender: self)
            }else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    

}
