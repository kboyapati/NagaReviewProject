//
//  NetworkClass.swift
//  NagaReviewProject
//
//  Created by Naga Boyapati on 8/28/17.
//  Copyright © 2017 Naga Boyapati. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class NetworkClass{
   
    static let instance = NetworkClass()
    fileprivate let baseURLString = "http://www.reddit.com/r/all/top.json"

    fileprivate init(){}
    let session = URLSession.shared
    var numberOfComments:Int? = 0
    
    func getArticles(page: Int,nextPageOffset:String, completionHandler: @escaping (_ recentArticles: Array<News>?,_ nextPagePath:String,_ success: Bool) -> Void){
        
        // Form the URL from Components
        let components = NSURLComponents(string: baseURLString)
        var queryItems = [NSURLQueryItem]()
        
        queryItems.append(NSURLQueryItem(name: "after", value: nextPageOffset))

        components?.queryItems = queryItems as [URLQueryItem]
        
        let request = NSMutableURLRequest(url: (components?.url!)!)
        request.httpMethod = "GET"
        
        
        
        let manager = AFHTTPSessionManager()
        
        manager.get((request.url?.absoluteString)!, parameters: nil, progress: { (NSProgress) in
            
        }, success: {
            (operation, responseObject) in
            
            if let dic = responseObject as? [String: Any]{
                let dataDic = dic["data"] as? [String: Any]
                let results = dataDic?["children"] as? [[String:Any]]
                let nextPage = dataDic?["after"] as? String

                if  responseObject != nil{
//                    print("RESULTS - \(String(describing: results))")
                    
                    var newsArray = [News]()
                    
                    for news in results!{
                        
//                        print(news)
                        
                        let appDict = news["data"] as? [String:Any]
                        let previewDict = appDict?["preview"] as? [String:Any]
                        let imagesDict = previewDict?["images"] as? [Any]
                        let imageSource = imagesDict?[0] as? [String:Any]
                        let source = imageSource?["source"] as? [String:Any]
                        let imageSourceUrl = source?["url"] as? String

                        let title = appDict?["title"] as? String
                        let imageURLString = appDict?["thumbnail"] as? String
                        self.numberOfComments = appDict?["num_comments"] as? Int

                        let authorName = appDict?["author"] as? String

                        // TODO Implement CommentsPath
                        //   let commentsPath = appDict?["permalink"] as? String
                        //   let commentsCompleteurl = "\("https://www.reddit.com")\(commentsPath!)\(".json")"
                        
                        //   let aNews = News(title: (title)!, imageURLString: imageURLString, datePosted: "01/01/2017", descriptionTextString: (numberOfComments!), commentsPath:commentsCompleteurl )
                        
                        
                        let aNews = News(title: (title)!, imageURLString: imageURLString, numberOfComments: (self.numberOfComments!), biggerMediaURL:imageSourceUrl, authorName: authorName)
                        
                        newsArray.append(aNews)
                    }
                    completionHandler(newsArray, nextPage!, true)
                }
                
            }
        },
           failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
                completionHandler(nil,"", false)

        })

//        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//
//            guard error == nil  && (response as? HTTPURLResponse)!.statusCode == 200 else {
//                completionHandler(nil, false)
//                return
//            }
//
//
//            do{
//                // ****TODO USE AFNetworking instead HTTPSERVICE
//                // Serialize the data downloaded to JSON format
//                
//                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
//                
//                let dataDic = responseJSON?["data"] as? [String:Any]
//                let results = dataDic?["children"] as? [[String:Any]]
//                
//                if  responseJSON != nil{
//                    print("RESULTS - \(String(describing: results))")
//                    
//                    var newsArray = [News]()
//                    
//                    for news in results!{
//                        
//                        print(news)
//                        
//                        let appDict = news["data"] as? [String:Any]
//                        let title = appDict?["title"] as? String
//                        let imageURLString = appDict?["thumbnail"] as? String
//                        let commentsPath = appDict?["permalink"] as? String
//                        let commentsCompleteurl = "\("https://www.reddit.com")\(commentsPath!)\(".json")"
//                        let numberOfComments = String(describing: appDict?["num_comments"])
//
//                        let aNews = News(title: (title)!, imageURLString: imageURLString, datePosted: "01/01/2017", descriptionTextString: numberOfComments, numberOfComments:commentsCompleteurl )
//                        newsArray.append(aNews)
//                    }
//                    
//                    completionHandler(newsArray, true)
//                }else{
//                    completionHandler(nil, false)
//                }
//                
//            }catch{
//                completionHandler(nil, false)
//                
//            }
//            
//            
//        }
//        
//        task.resume()
    }
    
    func downloadImageTask(_ imageRelativePath: String?, completionHandler: @escaping (_ image: UIImage?, _ success: Bool) -> Void){
        // Check if image path exists
        if imageRelativePath == nil{
            completionHandler(nil, false)
            return
        }
        
        // Form the complete URL string
        // let url = "\(imageBaseURLString)\(imageRelativePath!)"
        let url = (imageRelativePath!)
        
        // Form the URL
        guard let imageURL = URL(string: url) else{
            completionHandler(nil, false)
            return
            
        }
        
//        print("Image URL- \(url)")
        
        let dataTask = session.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            guard error == nil && data != nil else {
                completionHandler(nil, false)
                return
            }
            // Pass in the image to the colosure
            if let image = UIImage(data: data!){
                completionHandler(image, true)
            }else{
                completionHandler(nil, false)
            }
        })
        dataTask.resume()
        
    }
    

}
