//
//  Post.swift
//  Post
//
//  Created by Patrick Pahl on 6/1/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation

struct Post {
    
//The model object will represent the Post objects that are listed in the feed.
//This model object will be generated locally, but also must be generated from JSON dictionaries.
    
    private let UsernameKey = "username"
    private let TextKey = "text"
    private let TimestampKey = "timestamp"
    private let UUIDKey = "uuid"
    
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    //(3 steps below): Update the Post type with an endpoint and a jsonValue that will be used to send Post objects to the API.
    var endpoint: NSURL? {
        return PostController.baseURL?.URLByAppendingPathExtension(identifier.UUIDString).URLByAppendingPathExtension(".json")
    }
    
    var jsonValue : [String: AnyObject] {
        return [TextKey: text, TimestampKey: timestamp, UsernameKey: username]
    }
    
    var jsonData: NSData? {
        
        return try? NSJSONSerialization.dataWithJSONObject(self.jsonValue, options: NSJSONWritingOptions.PrettyPrinted)
    }
    

//  var jsonData: NSData? {
//    
//    return try? NSJSONSerialization.dataWithJSONObject(self.jsonValue, options: NSJSONWritingOptions.PrettyPrinted)
//}

    init(username: String, text: String, identifier: NSUUID = NSUUID()) {
        
        self.username = username
        self.text = text
        self.timestamp = NSDate().timeIntervalSince1970
        self.identifier = identifier
    }
 
    //This is the method you will use to initialize your Post object from a JSON dictionary.
    
    init?(json: [String: AnyObject], identifier: String){
        guard let username = json[UsernameKey] as? String,
        let text = json[TextKey] as? String,
        let timestamp = json[TimestampKey] as? Double,
        let identifier = NSUUID(UUIDString: identifier) else {return nil}
        
        self.username = username
        self.text = text
        self.timestamp = NSTimeInterval(floatLiteral: timestamp)
        self.identifier = identifier
    }
}


