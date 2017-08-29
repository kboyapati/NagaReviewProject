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
            self.thumbnailImageView.image = UIImage(named: "newsplaceholderColor")
            let titleText = "\(aNewsObj.title)"
            self.titleLabel.text = titleText
            self.descriptionTextlabel.text = aNewsObj.descriptionTextString
            self.cellMaxSizeImageUrl = aNewsObj.biggerMedia
            
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
