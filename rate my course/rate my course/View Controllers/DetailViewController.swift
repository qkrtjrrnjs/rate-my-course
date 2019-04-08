//
//  DetailViewController.swift
//  rate my course
//
//  Created by chris on 3/29/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var classNumberLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableview
        commentTableView.delegate           = self
        commentTableView.dataSource         = self
        commentTableView.separatorColor     = .clear

        //adding comment bar button
        self.navigationItem.rightBarButtonItem      = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(comment))
        
        classNumberLabel.text                       = global.classNumber
        
        self.view.backgroundColor                   = UIColor(hexString: "#d5d5d5")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    @objc func comment(){
        self.performSegue(withIdentifier: "detailToComment", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        
        return cell
    }

}
