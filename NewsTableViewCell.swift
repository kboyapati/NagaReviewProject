//
//  NewsTableViewCell.swift
//  NagaReviewProject
//
//  Created by Naga Boyapati on 8/28/17.
//  Copyright © 2017 Naga Boyapati. All rights reserved.
//

import UIKit


class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var descriptionTextlabel: UILabel!

    @IBOutlet weak var thumbnailImageView: UIImageView!

    var cellNews: News?

    var cellMaxSizeImageUrl: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

   

    func configureCell(_ isOdd: Bool){
        
        self.backgroundColor = UIColor.white
        if isOdd{
            self.backgroundColor = UIColor.white
        }
        if let aNewsObj = cellNews{
            self.thumbnailImageView.image = UIImage(named: placeholderImageName)
            let titleText = "\(aNewsObj.title)"
            self.titleLabel.text = titleText
            self.cellMaxSizeImageUrl = aNewsObj.biggerMedia
            
            let now = Date()
            if aNewsObj.createdTime != nil {

            let interval = Int (aNewsObj.createdTime!)
                let date = Date(timeIntervalSince1970: TimeInterval(interval))

            self.descriptionTextlabel.text = "Created: \(now.offsetFrom(date)) \nComments: \(aNewsObj.descriptionTextString!) "
            }
            else{
                self.descriptionTextlabel.text = "Comments : \(aNewsObj.descriptionTextString!) "

            }

            // Submit request to download and apply poster image to the imageView outlet
            NetworkClass.instance.downloadImageTask(aNewsObj.imageURLString, completionHandler: { [weak self](image, success) in
                // Get hold of the cell so that tableView does not reuse it before the image is applied if the cell is not visible
                if let strongSelf = self{
                    if success{
                        // Get hold of main queue
                        DispatchQueue.main.async(execute: {
                            // set image
                            strongSelf.thumbnailImageView.image = image
                            // Animate to get a blend in appearance to increase UX
                            strongSelf.thumbnailImageView.alpha = 0
                            UIView.animate(withDuration: 0.5, animations: {
                                self!.thumbnailImageView.alpha = 1
                            })
                        })
                    }
                }
                
            })
            
        }
    }

    
}

extension Date {
    public func yearsFrom(_ date: Date) -> Int {
        let years = (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year
        return years!
    }
    public func monthsFrom(_ date: Date) -> Int {
        let months = (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month
        return months!
    }
    public func weeksFrom(_ date: Date) -> Int {
        let weeks = (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear
        return weeks!
    }
    public func daysFrom(_ date: Date) -> Int {
        let days = (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day
        return days!
    }
    public func hoursFrom(_ date: Date) -> Int {
        let hours = (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour
        return hours!
    }
    public func minutesFrom(_ date: Date) -> Int {
        let minutes = (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute
        return minutes!
    }
    public func secondsFrom(_ date: Date) -> Int {
        let seconds = (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second
        return seconds!
    }
    
    public func offsetFrom(_ date: Date) -> String {
        
        if yearsFrom(date)   > 1 {
            return "\(yearsFrom(date)) years ago"
        }
        if yearsFrom(date)   > 0 {
            return "\(yearsFrom(date)) year ago"
        }
        if monthsFrom(date)  > 1 {
            return "\(monthsFrom(date)) months ago"
        }
        if monthsFrom(date)  > 0 {
            return "\(monthsFrom(date)) months ago"
        }
        if monthsFrom(date)  > 1 {
            return "\(weeksFrom(date)) weeks ago"
        }
        if monthsFrom(date)  > 0 {
            return "\(weeksFrom(date)) week ago"
        }
        if daysFrom(date)  > 1 {
            return "\(daysFrom(date)) days ago"
        }
        if daysFrom(date)  > 0 {
            return "\(daysFrom(date)) day ago"
        }
        if hoursFrom(date)  > 1 {
            return "\(hoursFrom(date)) hours ago"
        }
        if hoursFrom(date)  > 0 {
            return "\(hoursFrom(date)) hour ago"
        }
        if minutesFrom(date)  > 1 {
            return "\(minutesFrom(date)) minutes ago"
        }
        else {
            return "Just now"
        }
        
        
    }
}
