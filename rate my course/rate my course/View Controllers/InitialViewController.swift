//
//  InitialViewController.swift
//  rate my course
//
//  Created by chris on 3/25/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //button customization
        signUpButton.layer.cornerRadius     = 10
        signUpButton.backgroundColor        = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        signUpButton.tintColor              = UIColor.white
        
        logInButton.layer.cornerRadius      = 10
        logInButton.backgroundColor         = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        logInButton.tintColor               = UIColor.white
        
        //background color
        self.view.backgroundColor           = UIColor.white
    }
    
    
}
