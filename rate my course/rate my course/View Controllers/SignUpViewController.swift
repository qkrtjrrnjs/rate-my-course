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

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifyPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize UITextField
        emailField.textColor                        = UIColor.white
        emailField.backgroundColor                  = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        emailField.attributedPlaceholder            = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordField.textColor                     = UIColor.white
        passwordField.backgroundColor               = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        passwordField.attributedPlaceholder         = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        verifyPasswordField.textColor               = UIColor.white
        verifyPasswordField.backgroundColor         = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        verifyPasswordField.attributedPlaceholder   = NSAttributedString(string: "Verify Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if passwordField.text! == verifyPasswordField.text!{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                if error == nil && authResult != nil{
                    self.performSegue(withIdentifier: "SignUPToStream", sender: self)
                }else{
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                }
            }
        }
        else{
            displayAlert(title: "Error", message: "Passwords do not match!")
        }
    }
    
    func displayAlert(title: String, message: String){
        //create alert controller
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        //add cancel btn
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        
        self.present(alert, animated: true, completion: nil)
    }
    

}
