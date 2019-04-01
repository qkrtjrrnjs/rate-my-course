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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(comment))

    }

    
    @objc func comment(){
        self.performSegue(withIdentifier: "detailToComment", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
