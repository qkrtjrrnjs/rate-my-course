//
//  ViewController.swift
//  rate my course
//
//  Created by chris on 3/20/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize UITextField
        emailField.textColor                        = UIColor.white
        emailField.backgroundColor                  = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        emailField.attributedPlaceholder            = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        passwordField.textColor                     = UIColor.white
        passwordField.backgroundColor               = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        passwordField.attributedPlaceholder         = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func logIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] user, error in
            if error == nil && user != nil{
                self?.performSegue(withIdentifier: "LogInToStream", sender: self)
            }else{
                //create alert controller
                let alert = UIAlertController(
                    title: "Error",
                    message: error?.localizedDescription,
                    preferredStyle: .alert
                )
                //add cancel btn
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                ))
                
                self!.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}

