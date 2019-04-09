//
//  DetailViewController.swift
//  rate my course
//
//  Created by chris on 3/29/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var classNumberLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    
    var comments = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableview
        commentTableView.delegate           = self
        commentTableView.dataSource         = self
        commentTableView.separatorColor     = .clear

        //adding comment bar button
        self.navigationItem.rightBarButtonItem      = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(comment))
        
        classNumberLabel.text                       = global.classNumber
        commentTableView.backgroundColor            = UIColor(hexString: "#d5d5d5")
        self.view.backgroundColor                   = UIColor(hexString: "#d5d5d5")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        refs.databaseComments.child("\(global.classNumber as String)").observe(.childAdded, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any]{
                //print(snapshot.key)
                //don't add existing data
                var exists = false
                for comment in self.comments{
                    if comment["id"] as! String == data["id"] as! String{
                        exists = true
                    }
                }
                
                if(!exists){
                    self.comments.append(data)
                }
                self.commentTableView.reloadData()
            }
        })
        
    }

    @objc func comment(){
        self.performSegue(withIdentifier: "detailToComment", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        
        let comment_data     = comments[indexPath.row]
        let text        = comment_data["comment"] as! String
        let username    = comment_data["user"] as! String

        cell.commentLabel.text      = text
        cell.usernameLabel.text     = username
        cell.commentLabel.textColor = .black
        cell.backgroundColor = .clear
        
        return cell
    }

}
