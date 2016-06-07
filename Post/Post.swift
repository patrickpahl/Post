//
//  Post.swift
//  Post
//
//  Created by Patrick Pahl on 6/6/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation

class Post {
    
    private let usernameKey = "username"
    private let textKey = "text"
    private let timestampKey = "timestamp"
    private let identifierKey = "identifier"
    
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    init(username: String, text: String, identifier: NSUUID = NSUUID() ){
    
        self.username = username
        self.text = text
        self.timestamp = NSDate().timeIntervalSince1970
        self.identifier = identifier
    }
    
    init?(json: [String: AnyObject], identifier: String){           // failable init? 
        
        guard let username = json[usernameKey] as? String,
        let text = json[textKey] as? String,
        let timestamp = json[timestampKey] as? Double,
        let identifier = NSUUID(UUIDString: identifier)             //takes the key (id) and makes it a model object
        else {return nil}
        
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
}




