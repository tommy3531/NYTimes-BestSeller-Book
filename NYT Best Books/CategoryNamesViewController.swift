//
//  CategoryNamesViewController.swift
//  NYT Best Books
//
//  Created by Vinit Jasoliya on 9/27/16.
//  Copyright © 2016 ViNiT. All rights reserved.
//

import UIKit
import Alamofire

class CategoryNamesViewController: UIViewController {
    
    //categoryList Names
    var categoryListName:[String] = [String]()
    var categoryListCode:[String] = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Times New Roman", size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //CHECK APP LAUNCH FIRST TIME AND HANDLE
        if UserDefaults.standard.bool(forKey: "launchedBefore") {
            loadData() //not first launch
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore") // first launch
            UserDefaults.standard.synchronize()
            if hasConnectivity() {
                loadData()
            } else {
                let alert = UIAlertController(title: "Alert", message: "Internet Connection Required!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //load category list data from local json
    func loadData() {
        
        //empty the string arrays
        self.categoryListCode = [String]()
        self.categoryListName = [String]()
        
        self.categoryListName.append("All")
        self.categoryListCode.append("")
        
        let fileLocation = Bundle.main.path(forResource: "names", ofType: "json")!
        let text : String
        do {
            text = try String(contentsOfFile: fileLocation)
        }
        catch {
            text = ""
        }
        
        if let dataFromString = text.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            let results = json["results"]
            for (_,myResult) in results {
                if let list = myResult["display_name"].string {
                    self.categoryListName.append(list)
                }
                if let listCode = myResult["list_name_encoded"].string {
                    self.categoryListCode.append(listCode)
                }
            }
        }
        self.tableView.reloadData()
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryListName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CategoryTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryTableViewCell
        cell.categoryName.text = "\(categoryListName[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if categoryListCode.isEmpty {
        } else {
            
            let detailView:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! ViewController
            
            detailView.title = "\(categoryListName[indexPath.row])"
            if indexPath.row == 0 {
                detailView.categoryName = ""
            } else {
                detailView.categoryName = "\(categoryListName[indexPath.row])"
            }
            detailView.categorycode = "\(categoryListCode[indexPath.row])"
            
            self.navigationController?.pushViewController(detailView, animated: true)
        }
        self.tableView!.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    //MARK: - Check Internet Connection
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = Reachability.init()!
            let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
            
            return (networkStatus != 0)
        }
    }
    
}
