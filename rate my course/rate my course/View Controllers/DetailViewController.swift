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
import Charts

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var overallQualityLabel: UILabel!
    @IBOutlet weak var overallDifficultyLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var funLabel: UILabel!
    @IBOutlet weak var usefulLabel: UILabel!
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var usefulPieChart: PieChartView!
    @IBOutlet weak var funPieChart: PieChartView!
    
    var comments                = [[String: Any]]()
    var commentIds              = [String]()
    var funYesDataEntry         = PieChartDataEntry(value: 0)
    var funNoDataEntry          = PieChartDataEntry(value: 0)
    var usefulYesDataEntry      = PieChartDataEntry(value: 0)
    var usefulNoDataEntry       = PieChartDataEntry(value: 0)
    var numOfDownloadsFun       = [PieChartDataEntry]()
    var numOfDownloadsUseful    = [PieChartDataEntry]()
    var totalDifficulty         = 0.0
    var totalQuality            = 0.0
    var totalCount              = 0.0
    
    var emptyAnimation: LOTAnimationView!
    
    let newUsername    = (Auth.auth().currentUser!.email! as String).replacingOccurrences(of: ".", with: "")

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
        emptyAnimation.center.y            = self.view.center.y * 1.42

        //adding comment bar button
        self.navigationItem.rightBarButtonItem      = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(comment))
        
        commentTableView.backgroundColor            = UIColor(hexString: "#d5d5d5")
        self.view.backgroundColor                   = UIColor(hexString: "#d5d5d5")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.title = global.classNumber as String
        
        //unhide statistic labels
        self.hideOrUnhide(boolean: false)
        
        displayEmptyAnimation()
        
        refs.databaseUsers.child("\(self.newUsername)").child("submitted").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.hasChild("\(global.classNumber as String)") {
                
                refs.databaseStatistics.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if !snapshot.hasChild("\(global.classNumber as String)") {
                        //hide statistic labels
                        self.hideOrUnhide(boolean: true)
                    }
                    else{
                        self.displayStatistics()
                       
                    }
                })
                
                refs.databaseStatistics.child("\(global.classNumber as String)").observe(.childAdded, with: { (snapshot) in
                    if let data = snapshot.value as? [String: Any]{
                        if data["user"] as! String == self.newUsername{                            refs.databaseUsers.child(self.newUsername).child("submitted").child("\(global.classNumber as String)").setValue(["submitted": "submitted"])
                        }
                    }
                })
                
                self.customizePieCharts()
            }
            else{
                self.displayStatistics()
                self.customizePieCharts()
            }
        })
        
    }
    
    func displayEmptyAnimation(){
        //display empty animation if there are no comments
        refs.databaseComments.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChild(global.classNumber as String){
                self.view.addSubview(self.emptyAnimation)
                self.emptyAnimation.play()
            }
            else{
                self.emptyAnimation.removeFromSuperview()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refs.databaseComments.child("\(global.classNumber as String)").observe(.childRemoved, with: {(removedData) in
            self.commentIds.removeAll()
            self.comments.removeAll()
            self.commentTableView.reloadData()
            self.view.addSubview(self.emptyAnimation)
            self.emptyAnimation.play()
        })
     
        //add comments in to dictionary
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
    }
    
    func hideOrUnhide(boolean: Bool){
        self.funLabel.isHidden                  = boolean
        self.usefulLabel.isHidden               = boolean
        self.qualityLabel.isHidden              = boolean
        self.overallQualityLabel.isHidden       = boolean
        self.difficultyLabel.isHidden           = boolean
        self.overallDifficultyLabel.isHidden    = boolean
    }
    
    func displayStatistics(){
        refs.databaseStatistics.child("\(global.classNumber as String)").observe(.childAdded, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any]{
                if data["fun"] as! String == "yes"{
                    self.funYesDataEntry.value = self.funYesDataEntry.value + 1
                    self.updateFunChart()
                }
                else{
                    self.funNoDataEntry.value = self.funNoDataEntry.value + 1
                    self.updateFunChart()
                }
                
                if data["usefulness"] as! String == "yes"{
                    self.usefulYesDataEntry.value = self.usefulYesDataEntry.value + 1
                    self.updateUsefulChart()
                }
                else{
                    self.usefulNoDataEntry.value = self.usefulNoDataEntry.value + 1
                    self.updateUsefulChart()
                }
            }
        })
        
        //add up all the difficulty and quality level
        refs.databaseStatistics.child("\(global.classNumber as String)").observe(.childAdded, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: Any]{
                self.totalQuality += data["quality"] as! Double
                self.totalDifficulty += data["difficulty"] as! Double
                self.totalCount += 1.0
                
                self.qualityLabel.text = "\(Double(round(100 * self.totalQuality/self.totalCount)/100))"
                self.difficultyLabel.text = "\(Double(round(100 * self.totalDifficulty/self.totalCount)/100))"
            }
        })
    }
    
    func customizePieCharts(){
        //fun pie chart
        self.funPieChart.legend.enabled              = false
        self.funPieChart.holeRadiusPercent           = 0.2
        self.funPieChart.transparentCircleColor      = .clear
        self.funYesDataEntry.label                   = "Yes"
        self.funNoDataEntry.label                    = "No"
        self.numOfDownloadsFun                       = [self.funYesDataEntry, self.funNoDataEntry]
        
        
        //useful pie chart
        self.usefulPieChart.legend.enabled           = false
        self.usefulPieChart.holeRadiusPercent        = 0.2
        self.usefulPieChart.transparentCircleColor   = .clear
        self.usefulYesDataEntry.label                = "Yes"
        self.usefulNoDataEntry.label                 = "No"
        self.numOfDownloadsUseful                    = [self.usefulYesDataEntry, self.usefulNoDataEntry]
    }
    
    func updateFunChart(){
        let chartDataSet                = PieChartDataSet(values: numOfDownloadsFun, label: nil)
        let chartData                   = PieChartData(dataSet: chartDataSet)
        
        let colors                      = [UIColor(hexString: "#63acd8"), UIColor(hexString: "#ff715b")]
        chartDataSet.colors             = colors
        
        chartDataSet.entryLabelFont     = UIFont(name: "Noway", size: 13)
        chartDataSet.valueFont          = UIFont(name: "Noway", size: 13)!
        
        let formatter                   = NumberFormatter()
        formatter.minimumFractionDigits = 0
        
        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        funPieChart.data    = chartData
    }
    
    func updateUsefulChart(){
        let chartDataSet                = PieChartDataSet(values: numOfDownloadsUseful, label: nil)
        let chartData                   = PieChartData(dataSet: chartDataSet)
        
        let colors                      = [UIColor(hexString: "#63acd8"), UIColor(hexString: "#ff715b")]
        chartDataSet.colors             = colors
        
        chartDataSet.entryLabelFont     = UIFont(name: "Noway", size: 13)
        chartDataSet.valueFont          = UIFont(name: "Noway", size: 13)!
        
        let formatter                   = NumberFormatter()
        formatter.minimumFractionDigits = 0

        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        usefulPieChart.data    = chartData
    }
    
    //navigation to comment viewController
    @objc func comment(){
        self.performSegue(withIdentifier: "detailToComment", sender: nil)
    }
    
    @objc func like(sender: UIButton){
        
        refs.databaseUsers.child("\(newUsername)").child("dislike").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //if user has not disliked the comment
            if !snapshot.hasChild(self.comments[sender.tag]["id"] as! String){
                refs.databaseUsers.child("\(self.newUsername)").child("like").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //if user has not liked the comment
                    if !snapshot.hasChild(self.comments[sender.tag]["id"] as! String){
                        refs.databaseUsers.child("\(self.newUsername)").child("like").child(self.comments[sender.tag]["id"] as! String).setValue(["rated":"rated"])
                        
                        self.incrementLike(senderTag: sender.tag)
                    }
                    else{
                        refs.databaseUsers.child("\(self.newUsername)").child("like").child(self.comments[sender.tag]["id"] as! String).setValue(nil)
                        
                        self.decrementLike(senderTag: sender.tag)
                    }
                })
            }
            else{
                refs.databaseUsers.child("\(self.newUsername)").child("dislike").child(self.comments[sender.tag]["id"] as! String).setValue(nil)
                
                self.decrementDislike(senderTag: sender.tag)
                
                refs.databaseUsers.child("\(self.newUsername)").child("like").child(self.comments[sender.tag]["id"] as! String).setValue(["rated":"rated"])
                
                self.incrementLike(senderTag: sender.tag)
            }
        })
    }
    
    @objc func dislike(sender: UIButton){
        
        refs.databaseUsers.child("\(newUsername)").child("like").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //if user has not liked the comment
            if !snapshot.hasChild(self.comments[sender.tag]["id"] as! String){
                refs.databaseUsers.child("\(self.newUsername)").child("dislike").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //if user has not disliked the comment
                    if !snapshot.hasChild(self.comments[sender.tag]["id"] as! String){
                        refs.databaseUsers.child("\(self.newUsername)").child("dislike").child(self.comments[sender.tag]["id"] as! String).setValue(["rated":"rated"])
                        
                        self.incrementDislike(senderTag: sender.tag)
                    }
                    else{
                        refs.databaseUsers.child("\(self.newUsername)").child("dislike").child(self.comments[sender.tag]["id"] as! String).setValue(nil)
                        
                        self.decrementDislike(senderTag: sender.tag)
                    }
                })
            }
            else{
                refs.databaseUsers.child("\(self.newUsername)").child("like").child(self.comments[sender.tag]["id"] as! String).setValue(nil)
                
                self.decrementLike(senderTag: sender.tag)
                
                refs.databaseUsers.child("\(self.newUsername)").child("dislike").child(self.comments[sender.tag]["id"] as! String).setValue(["rated":"rated"])
                
                self.incrementDislike(senderTag: sender.tag)
            }
        })
    }
    

    @objc func deleteComment(sender: UIButton){
        
        var username = Auth.auth().currentUser!.email! as String
        if let atRange = username.range(of: "@") {
            username.removeSubrange(atRange.lowerBound..<username.endIndex)
        }
        
        refs.databaseComments.child("\(global.classNumber as String)").child(self.commentIds[sender.tag]).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any]{
                if data["user"] as! String == username{
                    self.deleteRating(id: data["id"] as! String, senderTag: sender.tag)
                    refs.databaseComments.child("\(global.classNumber as String)").child(self.commentIds[sender.tag]).removeValue()
                    self.commentIds.remove(at: sender.tag)
                    self.comments.remove(at: sender.tag)
                    self.commentTableView.reloadData()
                    self.displayEmptyAnimation()
                }
            }
        })
    }
    
    func deleteRating(id: String, senderTag: Int){
        //delete like and dislike status
        refs.databaseUsers.child("\(newUsername)").child("dislike").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(id){
                refs.databaseUsers.child("\(self.newUsername)").child("dislike").child(id).removeValue()
            }
        })
        
        refs.databaseUsers.child("\(newUsername)").child("like").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(id){
                refs.databaseUsers.child("\(self.newUsername)").child("like").child(id).removeValue()
            }
        })
    }
    
    func incrementDislike(senderTag: Int){
        //increment dislike count
        refs.databaseComments.child("\(global.classNumber as String)").child(self.commentIds[senderTag]).child("dislike").runTransactionBlock { (currentData: MutableData) -> TransactionResult in
            var currentCount = currentData.value as? Int ?? 0
            currentCount += 1
            currentData.value = currentCount
            
            return TransactionResult.success(withValue: currentData)
        }
        self.comments[senderTag]["dislike"] = self.comments[senderTag]["dislike"] as! Int + 1
        self.commentTableView.reloadData()
    }
    
    func decrementDislike(senderTag: Int){
        //decrement dislike count
        refs.databaseComments.child("\(global.classNumber as String)").child(self.commentIds[senderTag]).child("dislike").runTransactionBlock { (currentData: MutableData) -> TransactionResult in
            var currentCount = currentData.value as? Int ?? 0
            currentCount -= 1
            currentData.value = currentCount
            
            return TransactionResult.success(withValue: currentData)
        }
        
        self.comments[senderTag]["dislike"] = self.comments[senderTag]["dislike"] as! Int - 1
        self.commentTableView.reloadData()
    }
    
    func incrementLike(senderTag: Int){
        //increment like count
        refs.databaseComments.child("\(global.classNumber as String)").child(self.commentIds[senderTag]).child("like").runTransactionBlock { (currentData: MutableData) -> TransactionResult in
            var currentCount = currentData.value as? Int ?? 0
            currentCount += 1
            currentData.value = currentCount
            
            return TransactionResult.success(withValue: currentData)
        }
        self.comments[senderTag]["like"] = self.comments[senderTag]["like"] as! Int + 1
        self.commentTableView.reloadData()
    }
    
    func decrementLike(senderTag: Int){
        //decrement like count
        refs.databaseComments.child("\(global.classNumber as String)").child(self.commentIds[senderTag]).child("like").runTransactionBlock { (currentData: MutableData) -> TransactionResult in
            var currentCount = currentData.value as? Int ?? 0
            currentCount -= 1
            currentData.value = currentCount
            
            return TransactionResult.success(withValue: currentData)
        }
        self.comments[senderTag]["like"] = self.comments[senderTag]["like"] as! Int - 1
        self.commentTableView.reloadData()
    }
    
    func sortAndPopulate(){
        let combined = zip(comments, commentIds).sorted {($0.0["like"] as! Int) > ($1.0["like"] as! Int)}
        comments = combined.map {$0.0}
        commentIds = combined.map {$0.1}
    }
    
    //tableView stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        
        sortAndPopulate()

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
        cell.dislikeButton.clipsToBounds        = true
        cell.likeButton.clipsToBounds           = true
        
        cell.dislikeButton.tag = indexPath.row
        cell.dislikeButton.addTarget(self, action: #selector(dislike), for: .touchUpInside)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteComment), for: .touchUpInside)
        
        if !comments.isEmpty{
            emptyAnimation.removeFromSuperview()
        }
        
        return cell
    }
}

