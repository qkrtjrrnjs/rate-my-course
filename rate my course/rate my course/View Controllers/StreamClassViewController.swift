//
//  StreamClassViewController.swift
//  rate my course
//
//  Created by chris on 3/27/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import Lottie
import ElasticTransition
import MBProgressHUD

class StreamClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
   
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var classSearchBar: UISearchBar!
    
    var classes                 = [[String:Any]]()
    var classNumbers            = [String]()
    var filteredClassNumbers    = [String]()
    let transition              = ElasticTransition()
    
    var majorAbbreviation: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //transition customization
        transition.edge     = .right
        transition.sticky   = false
        
        self.hideKeyboardWhenTappedAround()
        
        classTableView.estimatedRowHeight   = 60
        classTableView.rowHeight            = UITableView.automaticDimension
        
        classTableView.delegate             = self
        classTableView.dataSource           = self
        classSearchBar.delegate             = self
        loadData()
    }
    
    func loadData() {
        //JSON parsing
        let url     = URL(string: "http://api.purdue.io/odata/Courses?$filter=Subject/Abbreviation%20eq%20%27\(majorAbbreviation!)%27&$orderby=Number%20asc")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task    = session.dataTask(with: request) { (data, response, error) in
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.classes = dataDictionary["value"] as! [[String:Any]]
                
                //remove repeating courses
                if self.classes.count != 0{
                    var removeCount = 0
                    for i in 0..<self.classes.count - 1{
                        let currClass = self.classes[i - removeCount]
                        let nextClass = self.classes[i + 1 - removeCount]

                        if currClass["Number"] as! String == nextClass["Number"] as! String{
                            self.classes.remove(at: i - removeCount)
                            removeCount += 1
                        }
                    }
                }
                
                for cls in self.classes{
                    self.classNumbers.append("\(self.majorAbbreviation!) \(cls["Number"] as! String)")
                }
                
                self.filteredClassNumbers = self.classNumbers
                
                self.classTableView.reloadData()
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredClassNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell") as! ClassCell
        
        //find name w/ cs #
        var name = String()
        for cls in self.classes{
            if cls["Number"] as! String == filteredClassNumbers[indexPath.row].components(separatedBy:CharacterSet.decimalDigits.inverted).joined(separator: ""){
                name = cls["Title"] as! String
                break
            }
        }
        
        cell.classLabel.text        = "\(filteredClassNumbers[indexPath.row])"
        cell.className.text         = name
        
        cell.classLabel.textColor   = .white
        cell.className.textColor    = .white
        
        return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredClassNumbers = searchText.isEmpty ? classNumbers: classNumbers.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        classTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate     = transition
        segue.destination.modalPresentationStyle    = .custom
        
        let cell        = sender as! UITableViewCell
        let indexPath   = classTableView.indexPath(for: cell)!
        
        let detailViewController                 = segue.destination as! DetailViewController
        detailViewController.classNumber         = filteredClassNumbers[indexPath.row]
        
        classTableView.deselectRow(at: indexPath, animated: true)
    }
}

