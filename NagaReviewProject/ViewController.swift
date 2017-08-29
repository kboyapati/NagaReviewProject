//
//  ViewController.swift
//  NagaReviewProject
//
//  Created by Naga Boyapati on 8/28/17.
//  Copyright © 2017 Naga Boyapati. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newsTableView: UITableView!


    var newsArray: [News]?

    var refreshControl: UIRefreshControl!
    var pageNunm = 1
    var isDownloadingData: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.backgroundColor = UIColor.lightGray
        self.newsTableView.addSubview(refreshControl)

        
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        self.loadData(pageNunm)

        
    }

   

    func numberOfSections(in tableView: UITableView) -> Int {
        if newsArray != nil{
            newsTableView.separatorStyle = .singleLine
            
            return 1
        }
        
        // If thers is no data in the data source array, display the empty table message.
        let somethingWrongLabel = UILabel()
        somethingWrongLabel.text = "Oops... Something is Not Right. Pull to Refresh"
        somethingWrongLabel.numberOfLines = 0;
        somethingWrongLabel.textAlignment = .center
        
        tableView.backgroundView = somethingWrongLabel
        newsTableView.separatorStyle = .none
        
        // Hide scroll to top button when no results are being shown
        
        // Unhide the backgroundView
        tableView.backgroundView?.isHidden = false
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsArray != nil{
            return (newsArray?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell") as? NewsTableViewCell{
            if newsArray != nil{
                cell.cellNews = newsArray![indexPath.row]
                
                // To display alternating cell background colors
                let isOddCell = indexPath.row % 2 == 0 ? false : true
                cell.configureCell(isOddCell)
                
                // While reaching the end of the tableview, show activity indicator and 
                // get next page results from API
                if indexPath.row == (newsArray?.count)! - 2{
                    pageNunm += 1
                    loadData(pageNunm)
                }
                return cell
            }else{
                // Just making sure. Cell should not reach here
                return UITableViewCell()
            }
        }else{
            // Never reaches here, just fail proof
            return UITableViewCell()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadData(_ pageNum: Int) {
        
        // Mark that data fetching is under progress.
        self.isDownloadingData = true
        
        // get page results
        NetworkClass.instance.getArticles(page: pageNum) {[unowned self] (recentNews, success) in
            if success{
                
                // If initial data is being fetched then initialize newsArray
                if pageNum == 1{
                    self.newsArray?.removeAll()
                    if self.newsArray == nil{
                        self.newsArray = [News]()
                    }
                }
                // append news
                self.newsArray?.append(contentsOf: recentNews!)
                DispatchQueue.main.async(execute: {
                    // Reload table view
                    self.newsTableView.reloadData()
                    // End refreshing the refreshControl
                    self.refreshControl.endRefreshing()
                })
            }else{
                print("API Call failed")
            }
            // Mark that data download is finished
            self.isDownloadingData = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // When scrolling stopped, check if the refresh control is active and if there is already data fetch under progress
        // If so, then reset the page number of the required results and submit data fetch request.
        if refreshControl.isRefreshing {
            if !isDownloadingData {
                pageNunm = 1
                loadData(pageNunm)
            }
        }
    }


}

