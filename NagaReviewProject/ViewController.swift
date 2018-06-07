//
//  ViewController.swift
//  NagaReviewProject
//
//  Created by Naga Boyapati on 8/28/17.
//  Copyright © 2017 Naga Boyapati. All rights reserved.
//

import UIKit

//make UI respond to handle error states from API.
public enum EmptyErrorEnum: Int {
    case none
    case empty
    case error
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var scrollToTopButton: CustomGraphicButton!


    var newsArray: [News]?

    var refreshControl: UIRefreshControl!
    var pageNunm = 1
    var isDownloadingData: Bool = false
    var nextPageOffset: String? = nil
    var emptyErrorState = EmptyErrorEnum.none

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: refreshControlLabelString)
        self.refreshControl.backgroundColor = UIColor.white
        self.newsTableView.addSubview(refreshControl)

        
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        if nextPageOffset != nil {
            self.loadData(pageNunm, nextPageOffset: nextPageOffset)
           }
        else{
            self.loadData(pageNunm, nextPageOffset: "")

        }

        
    }

   

    func numberOfSections(in tableView: UITableView) -> Int {
        if newsArray != nil{
            newsTableView.separatorStyle = .singleLine
            scrollToTopButton.isHidden = false
            self.emptyErrorState = .none

            return 1
        }
        
        // If thers is no data in the data source array, display the empty table message.
        let somethingWrongLabel = UILabel()
        if self.emptyErrorState == .empty {
            somethingWrongLabel.text = emptyTableMessage
        }

        if self.emptyErrorState == .empty {

        somethingWrongLabel.text = emptyTableErrorMessage
            
        }
        
        somethingWrongLabel.numberOfLines = 0;
        somethingWrongLabel.textAlignment = .center
        scrollToTopButton.isHidden = true

        tableView.backgroundView = somethingWrongLabel
        newsTableView.separatorStyle = .none
        
        // Hide scroll to top button when no results are being shown
        
        // Unhide the backgroundView
        tableView.backgroundView?.isHidden = false
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if newsArray != nil{
            emptyErrorState = .none
            if let newsCt = newsArray?.count { return newsCt }
        }
        emptyErrorState = .empty
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaDetailsViewCtlr = MediaDetailsViewController()
        
        guard let newsAr = newsArray else { return }
        if let mediaPath = newsAr[indexPath.row].biggerMedia {
            let authorName = newsAr[indexPath.row].authorName
            mediaDetailsViewCtlr.setMediaPath(with: mediaPath)
            mediaDetailsViewCtlr.setAuthorName(with: authorName)
        }
        self.navigationController?.pushViewController(mediaDetailsViewCtlr, animated: true)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCellIdentifier) as? NewsTableViewCell{
            if let newsAr = newsArray {
                cell.cellNews = newsAr[indexPath.row]
                
                // To display alternating cell background colors
                let isOddCell = indexPath.row % 2 == 0 ? false : true
                cell.configureCell(isOddCell)
                
                // While reaching the end of the tableview, show activity indicator and 
                // get next page results from API
                if indexPath.row == newsAr.count - 2{
                    pageNunm += 1
                    loadData(pageNunm, nextPageOffset: nextPageOffset)
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
    
    
    func loadData(_ pageNum: Int, nextPageOffset:String?) {
        
        // Mark that data fetching is under progress.
        self.isDownloadingData = true
        
        // get page results
        NetworkClass.instance.getArticles(page: pageNum, nextPageOffset:nextPageOffset ?? "") {[unowned self] (recentNews, apiNextPageOffset, success) in
            if success{
                
                // If initial data is being fetched then initialize newsArray
                if pageNum == 1{
                    self.newsArray?.removeAll()
                    if self.newsArray == nil{
                        self.newsArray = [News]()
                    }
                }
                // append news
                self.nextPageOffset = apiNextPageOffset
                if let recentNewsAr = recentNews {
                self.newsArray?.append(contentsOf: recentNewsAr)
                }
                self.emptyErrorState = .none

                DispatchQueue.main.async(execute: {
                    // Reload table view
                    self.newsTableView.reloadData()
                    // End refreshing the refreshControl
                    self.refreshControl.endRefreshing()
                })
            }else{
                self.emptyErrorState = .error

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
                nextPageOffset = ""
                loadData(pageNunm, nextPageOffset: nextPageOffset)
            }
        }
    }

    @IBAction func scrollToTopTapped(sender: UIButton) {
        
        // Get the indexpath for the first cell
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.newsTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)

    }
    



}

