//
//  InitialViewController.swift
//  rate my course
//
//  Created by chris on 3/25/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import ElasticTransition

class InitialViewController: UIViewController {
    
    @IBOutlet weak var rateMyCourseLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    var transition = ElasticTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //transition customization
        transition.edge     = .right
        transition.sticky   = false

        //Label Customization
        rateMyCourseLabel.textColor = UIColor(hexString: "#30323d")
        
        //button customization
        customizeButton(button: signUpButton, cornerRadius: 10, color: UIColor(hexString: "#30323d"))
        customizeButton(button: logInButton, cornerRadius: 10, color: UIColor(hexString: "#30323d"))
        
        //background color
        self.view.backgroundColor           = .white
    }
    
    func customizeButton(button: UIButton, cornerRadius: Int, color: UIColor){
        button.layer.cornerRadius      = CGFloat(cornerRadius)
        button.backgroundColor         = color
        button.tintColor               = .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate     = transition
        segue.destination.modalPresentationStyle    = .custom
    }
    
}
