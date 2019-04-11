//
//  SplashViewController.swift
//  rate my course
//
//  Created by chris on 3/27/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import Lottie
import ElasticTransition

class SplashViewController: UIViewController {
    
    var splashAnimation: LOTAnimationView!
    
    let transition = ElasticTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //transition customization
        transition.edge     = .right
        transition.sticky   = false
        
        splashAnimation                     = LOTAnimationView(name: "splash")
        splashAnimation.animationSpeed      = 1.5
        splashAnimation.frame.size.height   = 350
        splashAnimation.frame.size.width    = 250
        splashAnimation.center.x            = self.view.center.x
        splashAnimation.center.y            = self.view.center.y
        
        self.view.addSubview(splashAnimation)
        
        //navigate to the intial viewController after animation finishes
        splashAnimation.play(completion: { (finished) in
            if finished{
                self.splashAnimation.removeFromSuperview()
                self.performSegue(withIdentifier: "splashToInitial", sender: self)
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate     = transition
        segue.destination.modalPresentationStyle    = .custom
    }
}

