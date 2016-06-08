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
    
    
    var endpoint: NSURL? {
        return PostController.baseURL?.URLByAppendingPathComponent(self.identifier.UUIDString).URLByAppendingPathExtension("json")
    }
    
    //Add a jsonValue computed property that returns a [String: AnyObject] representation of the Post object.
    
    var jsonValue: [String: AnyObject] {
        
        let json: [String: AnyObject] = [
        
            usernameKey: self.username,
            textKey: self.text,
            timestampKey: self.timestamp
        ]
        return json
    }
    
    //Add a jsonData computed property as a convenient accessor that uses NSJSONSerialization to get an NSData? representation of the jsonValue dictionary.
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self.jsonValue, options: NSJSONWritingOptions.PrettyPrinted)
    }
    
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    init(username: String, text: String ){
                                                                    //FIRST INIT: for user when he is creating.
        self.username = username
        self.text = text
        self.timestamp = NSDate().timeIntervalSince1970            //NSDate means right NOW, timeIntervalSince1970 shows seconds since 1/1/1970.
        self.identifier = NSUUID()                                 //NOW the NSTimeInterval above correlates with this time interval.
    }
    
    init?(json: [String: AnyObject], identifier: String){
        
        guard let username = json[usernameKey] as? String,          //SECOND INIT: When converting to a model object- pulling from the API.
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









