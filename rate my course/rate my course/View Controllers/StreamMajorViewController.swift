//
//  StreamViewController.swift
//  rate my course
//
//  Created by chris on 3/25/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class StreamMajorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var majorTableView: UITableView!
    
    
    var majors = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        majorTableView.dataSource   = self
        majorTableView.delegate     = self
        
        //JSON parsing
        let url = URL(string: "https://api.purdue.io/odata/Subjects")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.majors = dataDictionary["value"] as! [[String:Any]]
                self.majorTableView.reloadData()
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return majors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MajorCell") as! MajorCell

        let major               = majors[indexPath.row]
        let majorAbbreviation   = major["Abbreviation"] as! String
        let majorName           = major["Name"] as! String
        
        cell.majorLabel.text    = "\(majorName) (\(majorAbbreviation))"
        
        return cell
    }

}
