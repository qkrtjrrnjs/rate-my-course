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
        
        //add compose bar button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(comment))
        
    }
    
    @objc func comment(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        let commentViewController: CommentViewController = mainStoryboard.instantiateViewController(withIdentifier: "commentViewController") as! CommentViewController
        
        commentViewController.classNumber = classNumber
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = commentViewController
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
