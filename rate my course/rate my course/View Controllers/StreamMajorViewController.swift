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

class StreamMajorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var majorTableView: UITableView!
    
    let transition  = ElasticTransition()
    
    var majors      = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        majorTableView.dataSource   = self
        majorTableView.delegate     = self
        
        //JSON parsing
        let url = URL(string: "https://api.purdue.io/odata/Subjects")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
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
        return majors.count
    }
    
    //tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MajorCell") as! MajorCell

        let major               = majors[indexPath.row]
        let majorAbbreviation   = major["Abbreviation"] as! String
        let majorName           = major["Name"] as! String
        
        cell.majorLabel.text        = "  \(majorName) (\(majorAbbreviation))"
        cell.majorLabel.textColor   = .white
        
        return cell
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
