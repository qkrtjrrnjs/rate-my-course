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
import Lottie

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var classNumberLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    
    var comments = [[String: Any]]()
    var commentIds = [String]()
    
    var emptyAnimation: LOTAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableview
        commentTableView.delegate           = self
        commentTableView.dataSource         = self
        commentTableView.separatorColor     = .clear
        
        //animation customization
        emptyAnimation                     = LOTAnimationView(name: "empty")
        emptyAnimation.animationSpeed      = 0.5
        emptyAnimation.loopAnimation       = true
        emptyAnimation.frame.size.height   = 250
        emptyAnimation.frame.size.width    = 250
        emptyAnimation.center.x            = self.view.center.x
        emptyAnimation.center.y            = self.view.center.y * 1.37

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
                self.commentIds.append(snapshot.key)
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
        self.view.addSubview(emptyAnimation)
        emptyAnimation.play()
        
    }
    
    @objc func comment(){
        self.performSegue(withIdentifier: "detailToComment", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count != 0{
            self.emptyAnimation.removeFromSuperview()
        }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        
        let comment_data        = comments[indexPath.row]
        let text                = comment_data["comment"] as! String
        let username            = comment_data["user"] as! String
        let dislikeCount        = comment_data["dislike"] as! Int
        let likeCount           = comment_data["like"] as! Int
        let date                = comment_data["date"] as! String

        cell.commentLabel.text      = text
        cell.usernameLabel.text     = username
        cell.timeLabel.text         = date
        cell.dislikeLabel.text      = "\(dislikeCount)"
        cell.likeLabel.text         = "\(likeCount)"
        cell.backgroundColor        = .clear
        
        cell.dislikeButton.layer.cornerRadius   = cell.dislikeButton.frame.size.width / 2
        cell.likeButton.layer.cornerRadius      = cell.likeButton.frame.size.width / 2
        cell.dislikeButton.clipsToBounds           = true
        cell.likeButton.clipsToBounds           = true
        
        cell.dislikeButton.tag = indexPath.row
        cell.dislikeButton.addTarget(self, action: #selector(dislike), for: .touchUpInside)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        
        return cell
    }
    
    @objc func like(sender: UIButton){
        refs.databaseComments.child("\(global.classNumber as String)").child(commentIds[sender.tag]).child("like").runTransactionBlock { (currentData: MutableData) -> TransactionResult in
            var currentCount = currentData.value as? Int ?? 0
            currentCount += 1
            currentData.value = currentCount
            
            return TransactionResult.success(withValue: currentData)
        }
        comments[sender.tag]["like"] = comments[sender.tag]["like"] as! Int + 1
        self.commentTableView.reloadData()
    }
    
    @objc func dislike(sender: UIButton){
        refs.databaseComments.child("\(global.classNumber as String)").child(commentIds[sender.tag]).child("dislike").runTransactionBlock { (currentData: MutableData) -> TransactionResult in
            var currentCount = currentData.value as? Int ?? 0
            currentCount += 1
            currentData.value = currentCount
            
            return TransactionResult.success(withValue: currentData)
        }
        
        comments[sender.tag]["dislike"] = comments[sender.tag]["dislike"] as! Int + 1
        self.commentTableView.reloadData()
    }

}
