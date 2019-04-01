//
//  DetailViewController.swift
//  rate my course
//
//  Created by chris on 3/29/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var classNumber = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(classNumber)")
        
        /*let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        view.addSubview(navBar)
        //add bar buttons
        let navItem = UINavigationItem(title: "SomeTitle")
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(comment))
        let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(comment))
        
        navItem.rightBarButtonItems = [add, play]
        
        navBar.setItems([navItem], animated: false)*/
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(comment))

    }

    
    @objc func comment(){
        //self.performSegue(withIdentifier: "detailToComment", sender: nil)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Stream", bundle: nil)
        let streamClassViewController: StreamClassViewController = mainStoryboard.instantiateViewController(withIdentifier: "streamClassViewController") as! StreamClassViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = streamClassViewController
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
