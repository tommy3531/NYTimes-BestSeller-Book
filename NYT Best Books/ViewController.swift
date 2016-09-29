//
//  ViewController.swift
//  NYT Best Books
//
//  Created by Vinit Jasoliya on 9/26/16.
//  Copyright © 2016 ViNiT. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    //LOADING INDICATOR
    // View which contains the loading text and the spinner
    let loadingView = UIView()
    // Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    
    //category
    var bookRankArray:[Int] = [Int]()
    var bookWeeksArray:[Int] = [Int]()
    var categorycode = ""
    var categoryName = ""
    
    //sortingVariable
    var rankWeekText = "Rank"
    
    //extras
    var bookJSONobject:JSON = [:]
    var mainJson:JSON!
    var imageLink:[String] = [String]()
    var bookTitleArray:[String] = [String]()
    var bookAuthorArray:[String] = [String]()
    var bookDescriptionArray:[String] = [String]()
    var bookAmazonArray:[String] = [String]()
    var bookReviewArray:[String] = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Times New Roman", size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        if categorycode.isEmpty {
        } else {
            addSortingButton()
        }
        
        ImageCache.default.maxDiskCacheSize = 50 * 1024 * 1024
        
        // Load data based on category
        if categorycode.isEmpty {
            loadAllCategory()
        } else {
            loadByCategory(category: categorycode)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Loading Activity Indicator
    // Set the activity indicator into the main view
    func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x:x,y:y,width: width,height: height)
        
        // Sets loading text
        self.loadingLabel.textColor = UIColor.gray
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Loading..."
        self.loadingLabel.frame = CGRect(x:0,y: 0,width: 140,height: 30)
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.spinner.frame = CGRect(x:0,y: 0,width: 30,height: 30)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    func removeLoadingScreen() {
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
        
    }
    
    //MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MainTableViewCell
        
        cell.bookTitle.text = bookTitleArray[indexPath.row]
        
        if categoryName.isEmpty {
            cell.bookAuthor.text = "by \(bookAuthorArray[indexPath.row])"
        } else {
            cell.bookAuthor.text = "by \(bookAuthorArray[indexPath.row]) \nin \(categoryName)"
        }
        
        //CHANGE HEIGHT OF UILABEL Run-Time
        cell.titleLabelHieght.constant = heightForView(text: "\(bookTitleArray[indexPath.row])", font: UIFont(name: "Times New Roman", size: 17.5)!, width: self.view.bounds.size.width - 166.0)
        cell.authorLabelHeight.constant = heightForView(text: "by \(bookAuthorArray[indexPath.row]) \nin \(categoryName)", font: UIFont(name: "Times New Roman", size: 13.5)!, width: self.view.bounds.size.width - 166.0)
        
        //Load Book Cover Image Async
        cell.bookImage.kf.indicatorType = .activity
        cell.bookImage.kf.setImage(with: URL(string: "\(imageLink[indexPath.row])"), placeholder: UIImage(named:"No_Image_Available"), options: [.transition(.fade(0.2))])
        cell.ranksLabel.text = "\(rankWeekText)"
        
        //Set Rank Variables
        if rankWeekText == "Weeks" {
            cell.ranksValue.text = "\(bookWeeksArray[indexPath.row])"
        } else {
            if bookRankArray[indexPath.row] == 0 {
                cell.ranksValue.isHidden = true
                cell.ranksLabel.isHidden = true
                cell.ranksValue.text = ""
            } else {
                cell.ranksValue.isHidden = false
                cell.ranksLabel.isHidden = false
                cell.ranksValue.text = "\(bookRankArray[indexPath.row])"
            }
        }
        
        self.removeLoadingScreen()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailView:DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        
        detailView.title = "NYT BestSeller"
        detailView.booksTitle = "\(self.bookTitleArray[indexPath.row])"
        detailView.booksAuthor = "\(self.bookAuthorArray[indexPath.row])"
        detailView.booksImage = "\(self.imageLink[indexPath.row])"
        detailView.booksDescription = "\(self.bookDescriptionArray[indexPath.row])"
        detailView.amazonLink = "\(self.bookAmazonArray[indexPath.row])"
        detailView.nytLink = "\(self.bookReviewArray[indexPath.row])"
        detailView.bookCategory = categoryName
        if self.bookRankArray.indices.contains(indexPath.row) {
            detailView.bookRanks = "\(self.bookRankArray[indexPath.row])"
        }
        
        self.navigationController?.pushViewController(detailView, animated: true)
        self.tableView!.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    //Calculates run-time height of a UILabel
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0,y: 0,width: width,height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    //MARK: - Load by Specific Category
    func loadByCategory(category: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: NSDate() as Date)
        
        if hasConnectivity() {
            let parameters: Parameters = ["api-key":"26b92aefbc504d43828b993436bb4f0e"]
            
            Alamofire.request("http://api.nytimes.com/svc/books/v3/lists/\(date)/\(category).json", parameters: parameters).responseJSON { response in
                
                let json = JSON(data: response.data!)
                self.mainJson = json
                UserDefaults.standard.set("\(json)", forKey: "\(category)")
                UserDefaults.standard.synchronize()
                self.parseCategoryData()
                }
                .downloadProgress { progress in
                    self.setLoadingScreen()
            }
        } else {
            
            //CHECK FOR DATA IN CACHE
            if let exists = UserDefaults.standard.string(forKey: "\(category)") {
                if let dataFromString = exists.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    self.mainJson = JSON(data: dataFromString)
                    self.parseCategoryData()
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "Internet Connection Required!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.removeLoadingScreen()
            }
            
        }
        
    }
    
    func parseCategoryData() {
        
        
        //PARSING JSON DATA
        
        let results = self.mainJson["results"]
        let books = results["books"]
        
        if results.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Oops, No books available in this category", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.removeLoadingScreen()
        }
        
        for (_,myResult) in books {
            if let amazonLink = myResult["amazon_product_url"].string {
                self.bookAmazonArray.append(amazonLink)
            } else {
                self.bookAmazonArray.append("blank")
            }
            
            if let bookRank = myResult["rank"].int {
                self.bookRankArray.append(bookRank)
            } else {
                self.bookRankArray.append(0)
            }
            
            if let bookWeeks = myResult["weeks_on_list"].int {
                self.bookWeeksArray.append(bookWeeks)
            } else {
                self.bookWeeksArray.append(0)
            }
            
            if let reviewLink = myResult["book_review_link"].string {
                self.bookReviewArray.append(reviewLink)
            } else {
                self.bookReviewArray.append("blank")
            }
            
            if let title = myResult["title"].string {
                self.bookTitleArray.append(title)
            } else {
                self.bookTitleArray.append("blank")
            }
            
            if let author = myResult["author"].string {
                self.bookAuthorArray.append(author)
            } else {
                self.bookAuthorArray.append("blank")
            }
            
            if let imgURL = myResult["book_image"].string {
                self.imageLink.append(imgURL)
            } else {
                self.imageLink.append("blank")
            }
            
            if let descriptions = myResult["description"].string {
                self.bookDescriptionArray.append(descriptions)
            } else {
                self.bookDescriptionArray.append("blank")
            }
        }
        
        if !UserDefaults.standard.bool(forKey: "RankOrder") {
                self.rankWeekText = "Weeks"
                self.arrangeOnWeeks()
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: - Load All Categories
    func loadAllCategory() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: NSDate() as Date)
        
        if hasConnectivity() {
            let parameters: Parameters = ["published_date": "\(date)",
                "api-key":"26b92aefbc504d43828b993436bb4f0e"]
            
            Alamofire.request("https://api.nytimes.com/svc/books/v3/lists/overview.json", parameters: parameters).responseJSON { response in
                
                let json = JSON(data: response.data!)
                self.mainJson = json
                UserDefaults.standard.set("\(json)", forKey: "All")
                UserDefaults.standard.synchronize()
                self.parseAllCategory()
                }
                .downloadProgress { progress in
                    self.setLoadingScreen()
                }
        } else {
            
            //CHECK FOR DATA IN CACHE
            if let exists = UserDefaults.standard.string(forKey: "All") {
                if let dataFromString = exists.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    self.mainJson = JSON(data: dataFromString)
                    self.parseAllCategory()
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "Internet Connection Required!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.removeLoadingScreen()
            }
            
        }
        

    }
    
    func parseAllCategory() {
        
        //PARSE ALL CATEGORY
        
        let results = self.mainJson["results"]
        let lists = results["lists"]
        
        self.bookJSONobject = JSON(lists[0]["books"].arrayObject! + lists[1]["books"].arrayObject!)
        for i in 2...(lists.count - 1) {
            self.bookJSONobject = JSON(self.bookJSONobject.arrayObject! + lists[i]["books"].arrayObject!)
        }
        
        for (_, subJson) in self.bookJSONobject {
            
            if let title = subJson["title"].string {
                if self.bookTitleArray.contains(title) {
                    continue
                } else {
                    self.bookTitleArray.append(title)
                }
            } else {
                self.bookTitleArray.append("blank")
            }
            
            if let author = subJson["author"].string {
                self.bookAuthorArray.append(author)
            } else {
                self.bookAuthorArray.append("blank")
            }
            
            if let imgURL = subJson["book_image"].string {
                self.imageLink.append(imgURL)
            } else {
                self.imageLink.append("blank")
            }
            
            if let bookRank = subJson["rank_no_use"].int {
                self.bookRankArray.append(bookRank)
            } else {
                self.bookRankArray.append(0)
            }
            
            if let descriptions = subJson["description"].string {
                self.bookDescriptionArray.append(descriptions)
            } else {
                self.bookDescriptionArray.append("blank")
            }
            
            if let amaznLink = subJson["amazon_product_url"].string {
                self.bookAmazonArray.append(amaznLink)
            } else {
                self.bookAmazonArray.append("blank")
            }
            
            if let bookRevLink = subJson["book_review_link"].string {
                self.bookReviewArray.append(bookRevLink)
            } else {
                self.bookReviewArray.append("blank")
            }
            
            if let bookWeeks = subJson["weeks_on_list"].int {
                self.bookWeeksArray.append(bookWeeks)
            } else {
                self.bookWeeksArray.append(0)
            }
            
        }
        self.arrangeOnWeeks()
        self.tableView.reloadData()
    }
    
    //MARK: - Sorting Arrays on Rank/Weeks
    
    func arrangeOnWeeks() {
        self.bookTitleArray = self.sortingArraysDesc(toSort: self.bookTitleArray,sorter: self.bookWeeksArray)
        self.bookAuthorArray = self.sortingArraysDesc(toSort: self.bookAuthorArray,sorter: self.bookWeeksArray)
        self.bookDescriptionArray = self.sortingArraysDesc(toSort: self.bookDescriptionArray,sorter: self.bookWeeksArray)
        self.bookAmazonArray = self.sortingArraysDesc(toSort: self.bookAmazonArray,sorter: self.bookWeeksArray)
        self.bookReviewArray = self.sortingArraysDesc(toSort: self.bookReviewArray,sorter: self.bookWeeksArray)
        self.imageLink = self.sortingArraysDesc(toSort: self.imageLink,sorter: self.bookWeeksArray)
        if self.bookRankArray.isEmpty {
            let combined = zip(self.bookWeeksArray, self.bookWeeksArray).sorted {$0.0 > $1.0}
            let sorted1 = combined.map {$0.0}
            self.bookWeeksArray = sorted1
        } else {
            let combined1 = zip(self.bookWeeksArray, self.bookRankArray).sorted {$0.0 > $1.0}
            let sorted1 = combined1.map {$0.0}
            let sorted3 = combined1.map {$0.1}
            self.bookRankArray = sorted3
            self.bookWeeksArray = sorted1
        }
    }
    
    
    func arrangeOnRank() {
        self.bookTitleArray = self.sortingArraysAsc(toSort: self.bookTitleArray,sorter: self.bookRankArray)
        self.bookAuthorArray = self.sortingArraysAsc(toSort: self.bookAuthorArray,sorter: self.bookRankArray)
        self.bookDescriptionArray = self.sortingArraysAsc(toSort: self.bookDescriptionArray,sorter: self.bookRankArray)
        self.bookAmazonArray = self.sortingArraysAsc(toSort: self.bookAmazonArray,sorter: self.bookRankArray)
        self.bookReviewArray = self.sortingArraysAsc(toSort: self.bookReviewArray,sorter: self.bookRankArray)
        self.imageLink = self.sortingArraysAsc(toSort: self.imageLink,sorter: self.bookRankArray)
        
        let combined = zip(self.bookRankArray, self.bookWeeksArray).sorted {$0.0 < $1.0}
        let sorted1 = combined.map {$0.0}
        let sorted3 = combined.map {$0.1}
        self.bookRankArray = sorted1
        self.bookWeeksArray = sorted3
    }
    
    func sortingArraysDesc(toSort: [String], sorter: [Int]) -> [String] {
        let combined = zip(sorter, toSort).sorted {$0.0 > $1.0}
        let sorted2 = combined.map {$0.1}
        return sorted2
    }
    
    func sortingArraysAsc(toSort: [String], sorter: [Int]) -> [String] {
        let combined = zip(sorter, toSort).sorted {$0.0 < $1.0}
        let sorted2 = combined.map {$0.1}
        return sorted2
    }
    
    //MARK: - Sort by Rank/Weeks
    func addSortingButton() {
        
        let refreshButton = UIBarButtonItem(title: "Sort", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.buttonMethod))
        navigationItem.rightBarButtonItem = refreshButton
        
    }
    
    func buttonMethod() {
        
        var items = [CustomizableActionSheetItem]()
        
        // Rank button
        let rankItem = CustomizableActionSheetItem()
        rankItem.type = .button
        rankItem.label = "by Rank"
        rankItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
            self.rankWeekText = "Rank"
            self.arrangeOnRank()
            self.tableView.reloadData()
            UserDefaults.standard.set(true, forKey: "RankOrder")
            UserDefaults.standard.synchronize()
            actionSheet.dismiss()
        }
        items.append(rankItem)
        
        // Weeks button
        let weekItem = CustomizableActionSheetItem()
        weekItem.type = .button
        weekItem.label = "by Weeks on List"
        weekItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
            self.rankWeekText = "Weeks"
            self.arrangeOnWeeks()
            self.tableView.reloadData()
            UserDefaults.standard.set(false, forKey: "RankOrder")
            UserDefaults.standard.synchronize()
            actionSheet.dismiss()
        }
        items.append(weekItem)
        
        // Cancel button
        let cancelItem = CustomizableActionSheetItem()
        cancelItem.type = .button
        cancelItem.label = "Cancel"
        cancelItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
            actionSheet.dismiss()
        }
        items.append(cancelItem)
        
        // Show
        let actionSheet = CustomizableActionSheet()
        actionSheet.showInView(self.view, items: items)
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
