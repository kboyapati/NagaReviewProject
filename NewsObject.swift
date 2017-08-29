//
//  NewsObject.swift
//  NagaReviewProject
//
//  Created by Naga Boyapati on 8/28/17.
//  Copyright © 2017 Naga Boyapati. All rights reserved.
//

import Foundation

struct News{
    
    fileprivate  var _title: String
    fileprivate  var _imageURLString : String?
    fileprivate  var _datePosted: String?
    fileprivate var _descriptionTextString: String?
    fileprivate var _numberOfComments: Int? = 0
    fileprivate var _commentsPath: String?
    
    
    var title: String{
        return _title
    }
    
    var imageURLString: String?{
        return _imageURLString
    }
    
    
    var descriptionTextString: String?{
        return _descriptionTextString
    }
    
    var commentsPath: String?{
        return _commentsPath
    }
    var numberOfComments: Int?{
        return _numberOfComments
    }

    
//    init(title: String, imageURLString: String?, datePosted: String, descriptionTextString: String?, commentsPath:String?){
//        
//        _title = title
//        
//        if imageURLString != nil{
//            _imageURLString = imageURLString
//        }
//        
//        _datePosted = datePosted
//        
//        if commentsPath != nil{
//            _commentsPath = commentsPath
//        }
//        
//        if descriptionTextString != nil{
//            _descriptionTextString = descriptionTextString
//        }
//        
//        
//    }
    
    init(title: String, imageURLString: String?, numberOfComments: Int){
        
        _title = title
        _datePosted = nil
        _commentsPath = nil
        
        if imageURLString != nil{
            _imageURLString = imageURLString
        }
        
        if numberOfComments != 0 {
            _numberOfComments = numberOfComments
            _descriptionTextString = "\(String(describing: _numberOfComments!))"

        }

    }
    
    
}

