//
//  DetailViewController.swift
//  rate my course
//
//  Created by chris on 3/29/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var classNumberLabel: UILabel!


    var classNumber = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        classNumberLabel.text = classNumber
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(comment))
        
        self.view.backgroundColor = UIColor(hexString: "#d5d5d5")
    }

    
    @objc func comment(){
        self.performSegue(withIdentifier: "detailToComment", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
