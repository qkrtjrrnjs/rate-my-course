//
//  StreamViewController.swift
//  rate my course
//
//  Created by chris on 3/25/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import FirebaseAuth
import ElasticTransition

class StreamMajorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var majorTableView: UITableView!
    @IBOutlet weak var majorSearchBar: UISearchBar!
    
    
    let transition      = ElasticTransition()
    var majors          = [[String: Any]]()
    var majorNames      = [String]()
    var filteredMajors  = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        majorTableView.dataSource   = self
        majorTableView.delegate     = self
        majorSearchBar.delegate     = self
        
        //JSON parsing
        let url = URL(string: "https://api.purdue.io/odata/Subjects")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary  = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.majors         = dataDictionary["value"] as! [[String:Any]]
                
                for major in self.majors{
                    self.majorNames.append(major["Name"] as! String)
                }
                self.filteredMajors = self.majorNames
                
                self.majorTableView.reloadData()
            }
        }
        task.resume()
    }
    
    //logout
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "userlogin")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController: InitialViewController = mainStoryboard.instantiateViewController(withIdentifier: "initialViewController") as! InitialViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = initialViewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMajors.count
    }
    
    //tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MajorCell") as! MajorCell

        let major               = majors[indexPath.row]
        let majorAbbreviation   = major["Abbreviation"] as! String
        
        cell.majorLabel.text        = "  \(filteredMajors[indexPath.row]) (\(majorAbbreviation))"
        cell.majorLabel.textColor   = .white
        
        return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredMajors = searchText.isEmpty ? majorNames: majorNames.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        majorTableView.reloadData()
    }
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //custom transition
        transition.edge     = .right
        transition.sticky   = false
        
        segue.destination.transitioningDelegate     = transition
        segue.destination.modalPresentationStyle    = .custom
        
        let cell        = sender as! UITableViewCell
        let indexPath   = majorTableView.indexPath(for: cell)!
        let major       = majors[indexPath.row]
        
        let streamClassViewController      = segue.destination as! StreamClassViewController
        streamClassViewController.major    = major
        
        majorTableView.deselectRow(at: indexPath, animated: true)
    }
    
    

}
