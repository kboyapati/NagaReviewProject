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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.backgroundColor = UIColor.lightGray
        self.newsTableView.addSubview(refreshControl)

        
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        
        var tempNews:News? = nil
        tempNews?.title = "Test"
        tempNews?.descriptionTextString = "Test Test"
        newsArray?.append(tempNews!)

        
    }

   

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for:indexPath) as! NewsTableViewCell

        cell.titleLabel.text = "Test"
        cell.titleLabel.textColor = UIColor.red
        return cell

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

