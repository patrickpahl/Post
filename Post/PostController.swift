//
//  PostController.swift
//  Post
//
//  Created by Patrick Pahl on 6/6/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation
        //the API returns a Dictionary with UUID Strings as the keys, and the [String: AnyObject] representation as the value for each key.

class PostController {
    
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com/posts/")                 //Static URL available to other classes
    
    static let endpoint = baseURL?.URLByAppendingPathExtension("json")          //This pathextension is for Reading. the json extension in the
                                                                                //post.swift file is for uploading. 
    weak var delegate: PostControllerDelegate?
    
    var posts: [Post] = [] {                                                                            //Creating an array of posts
        didSet {                                                                                        //did set: only called if value changes
            delegate?.postsUpdated(posts)
        }
    }
    
    
    init(){                                                                                             //soon as class is loaded, posts loaded
        fetchPosts()
    }
    
    
    //MARK: - ADD POST
    
    func addPost(username: String, text: String){                                                                       //add function
        
        let post = Post(username: username, text: text)                                                                 //init the class
        
        guard let requestURL = post.endpoint else {fatalError("fatal error")}                                           //guard requestURL (post.endpoint)
        
        NetworkController.performRequestForURL(requestURL, httpMethod: .Put, body: post.jsonData) { (data, error) in    //NetworkController -> Put
            
            let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding) ?? ""                        //for errors, not req
            
            if error != nil{
                print("Error: \(error)")                                //BC of quirks from this specific API, check errors
            } else if responseDataString.containsString("error") {
                print("Error: \(responseDataString)")
            } else {
                print("Successfully saved data to endpoint. \nResponse: \(responseDataString)")
            }
            self.fetchPosts()                                                                                           //Right after we post, fetch all posts
            }
        }
    
    
    //PAGING: Only loading some of the data in a feed, rather than all of it to be more efficient. 'Reset',
    
    //MARK: - Request
    
    func fetchPosts(reset reset: Bool = true, completion: ((newPosts: [Post]) -> Void)? = nil) {                                //Fetch posts with completion, nil= maybe no posts
                                                                                                      //completion: Fetch posts, tell me when done
        guard let requestURL = PostController.endpoint else {fatalError("Post endpoint failed")}      //unwrap URL, else we want it to fail
        
        
        let queryEndInterval = reset ? NSDate().timeIntervalSince1970 : posts.last?.queryTimestamp ?? NSDate().timeIntervalSince1970
        
        let urlParameters = [
            "orderBy" : "\"timestamp\"",
            "endAt":    "\(queryEndInterval)",
            "limitTolast":  "15",
        ]
        
        
       NetworkController.performRequestForURL(requestURL, httpMethod: .Get, urlParameters: urlParameters) { (data, error) in
        
        let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding)                  //will only run if theres an error, (optional)
            
        guard let data = data,                                                                          //unwrap data first
        let postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: [String: AnyObject]] else {
                print("Unable to serialize JSON")                                              //Here creating postDictionary to serialize data
            
                if let completion = completion {
                completion(newPosts: [])                                                        //unwrap completion, so we can work with it.
                }                                                                               //Need to say its an empty array
                return                                                                          //If gas station is empty then just empty gas can
            }
            
            let posts = postDictionaries.flatMap({Post(json: $0.1, identifier: $0.0)})          //
            let sortedPosts = posts.sort({$0.0.timestamp > $0.1.timestamp})                     //sort newer posts first
    
            
            dispatch_async(dispatch_get_main_queue(), {                                         //init model objects for completion
                
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.appendContentsOf(sortedPosts)
                }
                
                
                if let completion = completion{                                                 //This completion is saying task complete, so we can continue
                    completion(newPosts: sortedPosts)
                }
                return
            })
        }
    }
}


protocol PostControllerDelegate: class {                                                        //protocol needs to be bound to a class type
                                                                                                //allows a delegate to be weak, which helps memory
    func postsUpdated(post: [Post])
}











