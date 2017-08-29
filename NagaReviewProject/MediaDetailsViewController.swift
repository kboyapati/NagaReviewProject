//
//  MediaDetailsViewController.swift
//  NagaReviewProject
//
//  Created by Naga Boyapati on 8/29/17.
//  Copyright © 2017 Naga Boyapati. All rights reserved.
//

import UIKit
import Photos

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

class MediaDetailsViewController: UIViewController {
    var mediaUrlPath: String?
    var authorName: String?

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postedMedia: UIImageView!
    @IBOutlet weak var saveToCameraRoll: UIButton!
    @IBOutlet weak var shareToSocialNetwork: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Post Details"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.setMedia()
        if self.authorName != nil {
        self.authorNameLabel.text = "Posted By : \(String(describing: self.authorName!))"
        }
        else {
            self.authorNameLabel.text = "Posted By : Unknown)"
 
        }
        self.saveToCameraRoll.backgroundColor =  UIColor(red: 0.2, green: 0.3, blue: 0.6, alpha: 1.0)
        self.shareToSocialNetwork.backgroundColor =  UIColor(red: 0.2, green: 0.3, blue: 0.6, alpha: 1.0)

        self.saveToCameraRoll.titleLabel?.tintColor = UIColor.white
        self.shareToSocialNetwork.titleLabel?.tintColor = UIColor.white

    }
    
    func setMediaPath(with url : String){
        
       self.mediaUrlPath = url
        
    }
    func setAuthorName(with name : String){
        
        self.authorName = name
        
    }
    func setMedia() {
        
        NetworkClass.instance.downloadImageTask(self.mediaUrlPath, completionHandler: { [weak self](image, success) in
            if let strongSelf = self{
                if success{
                    // Get hold of main queue
                    DispatchQueue.main.async(execute: {
                        // set image
                        strongSelf.postedMedia.image = image
                        // Animate to get a blend in appearance to increase UX
                        strongSelf.postedMedia.alpha = 0
                        UIView.animate(withDuration: 0.5, animations: {
                            self!.postedMedia.alpha = 1
                        })
                    })
                }
            }
            
        })
    }
    @IBAction func saveToCameraRollPressed(_ sender: AnyObject) {
       
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(string:self.mediaUrlPath!)!)
        }) { success, error in
            if success {
                print(" saved to camera roll")
            }
            else if let error = error {
                
                if Platform.isSimulator {
                    // Simulator
                        let alert = UIAlertController(title: "Failed", message: "You can not save photos to simulator.Please try on real device", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                }
                else{

                print(" failed to save to camera roll. Error: \(error)")
                }

                
            }
            else {
                print(" failed to save to camera roll with no error")
            }
        }

    }
    @IBAction func shareToSocialNetworkPressed(_ sender: AnyObject) {
        
        let shareImage = self.postedMedia.image
        
        if shareImage != nil {
        let objectsToShare = [shareImage!]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: [])
        activityVC.excludedActivityTypes = [UIActivityType.print, UIActivityType.assignToContact, UIActivityType.addToReadingList]
        
        self.present(activityVC, animated: true) { _ in
        }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
