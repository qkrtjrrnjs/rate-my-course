//
//  StreamClassViewController.swift
//  rate my course
//
//  Created by chris on 3/27/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class StreamClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var classTableView: UITableView!
    
    var major: [String:Any]!
    var classes = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classTableView.delegate = self
        classTableView.dataSource = self
        let majorAbrreviation = major["Abbreviation"] as! String

        print(majorAbrreviation)
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
        let className               = classInfo["Title"] as! String
        
        cell.classLabel.text    = "\(majorAbrreviation) \(number) \(className)"

        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
