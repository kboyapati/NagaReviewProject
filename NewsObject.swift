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
    fileprivate  var _authorName: String?
    fileprivate  var _imageURLString : String?
    fileprivate  var _datePosted: String?
    fileprivate var _descriptionTextString: String?
    fileprivate var _numberOfComments: Int? = 0
    fileprivate var _commentsPath: String?
    fileprivate var _biggerMedia: String?
    fileprivate var _createdTime: Int?

    
    var title: String{
        return _title
    }
    
    var authorName: String{
        return _authorName!
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

    var biggerMedia: String?{
        return _biggerMedia
    }

    var createdTime: Int?{
        return _createdTime
    }
    
    init(title: String, imageURLString: String?, numberOfComments: Int, biggerMediaURL: String?, authorName: String?, createdTime:Int?){
        
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
        
        if biggerMediaURL != nil{
            _biggerMedia = biggerMediaURL

        }

        if authorName != nil{
            _authorName = authorName!
        }
        
        if createdTime != nil {
            _createdTime = createdTime
        }
    }
    
    
}

