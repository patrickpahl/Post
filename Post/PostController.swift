//
//  PostController.swift
//  Post
//
//  Created by Patrick Pahl on 6/6/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation               //the API returns a Dictionary with UUID Strings as the keys, and the [String: AnyObject] representation as the value for each key.

class PostController {
    
    static let endpoint = NSURL(string: "https://devmtn-post.firebaseio.com/posts.json")                //Static URL available to other classes
    
    weak var delegate: PostControllerDelegate?
    
    var posts: [Post] = [] {                                                                            //Creating an array of posts
        didSet {                                                                                        //did set only called if value changes
            delegate?.postsUpdated(posts)
        }
    }
    
    
    init(){                                                                                             //soon as class is loaded, posts loaded
        fetchPosts()
    }
    
    //MARK: - Request
    
    func fetchPosts(completion: ((newPosts: [Post]) -> Void)? = nil) {                                //Fetch posts with completion, nil= maybe no posts
        
        guard let requestURL = PostController.endpoint else {fatalError("Post endpoint failed")}      //unwrap URL, else we want it to fail
        
        NetworkController.performRequestForURL(requestURL, httpMethod: .Get, urlParameters: nil) { (data, error) in   //Actually ask NC to get URL on background thread
            
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
                self.posts = sortedPosts
                
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











