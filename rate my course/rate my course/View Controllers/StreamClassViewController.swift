//
//  StreamClassViewController.swift
//  rate my course
//
//  Created by chris on 3/27/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import Lottie

class StreamClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet weak var classTableView: UITableView!
    
    var major: [String:Any]!
    var classes = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        classTableView.estimatedRowHeight = 60
        classTableView.rowHeight = UITableView.automaticDimension
        
        classTableView.delegate = self
        classTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        let majorAbrreviation = major["Abbreviation"] as! String
        //JSON parsing
        let url = URL(string: "http://api.purdue.io/odata/Courses?$filter=Subject/Abbreviation%20eq%20%27\(majorAbrreviation)%27&$orderby=Number%20asc")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.classes = dataDictionary["value"] as! [[String:Any]]
                self.classTableView.reloadData()
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell") as! ClassCell
        
        let majorAbrreviation       = major["Abbreviation"] as! String
        let classInfo               = classes[indexPath.row]
        let number                  = classInfo["Number"] as! String
        let name                    = classInfo["Title"] as! String
        
        cell.classLabel.text        = "\(majorAbrreviation) \(number)"
        cell.className.text         = name
        
        cell.classLabel.textColor   = .white
        cell.className.textColor    = .white
        
        return cell
    }

}

