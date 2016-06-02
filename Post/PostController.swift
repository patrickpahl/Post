//
//  PostController.swift
//  Post
//
//  Created by Patrick Pahl on 6/1/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation

class PostController {
    
    //POSTCONTROLLER CLASS will use the NetworkController to fetch data, and will serialize the results into Post objects.
    //This class will be used by the view controllers to fetch Post objects through completion closures.
    //**Because you will only use one View Controller, there is no reason to make this controller a shared controller.
    
    static let endpoint = NSURL(string: "https://devmtn-post.firebaseio.com/posts.json")
    //add static constant endpoint for the PostController to know where to fetch Post objects from
    
    weak var delegate: PostControllerDelegate?
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    //posts property that will hold the Post objects that you pull and serialize from the API.
    
    init() {
        fetchPosts()
    }
    
    // MARK: - Request
    
    func fetchPosts(completion: ((newPosts: [Post]) -> Void)? = nil) {
        
        guard let requestURL = PostController.endpoint else { fatalError("Post Endpoint url failed") }
        
        
        //performRequestforURL: serializing the JSON using NSJsonSerialization
        
        NetworkController.performRequestForURL(requestURL, httpMethod: .Get, urlParameters: nil) { (data, error) in
            
            let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                                                                                            //Remember to allow fragments
            guard let data = data,
                let postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: [String: AnyObject]] else {
                    
                    print("Unable to serialize JSON. \nResponse: \(responseDataString)")
                    if let completion = completion {
                        completion(newPosts: [])
                    }
                    return
            }
            
            let posts = postDictionaries.flatMap({Post(json: $0.1, identifier: $0.0)})
            let sortedPosts = posts.sort({$0.0.timestamp > $0.1.timestamp})
            //Use the .sort() function to sort the posts by the timestamp property in reverse chronological order.
            
            dispatch_async(dispatch_get_main_queue(), {
                //use Grand Central Dispatch to force the completion closure to run on the main thread. (Hint: dispatch_async)
                
                self.posts = sortedPosts
                
                if let completion = completion {
                    completion(newPosts: sortedPosts)
                }
                
                return
            })
        }
    }
}

protocol PostControllerDelegate: class {
    
    func postsUpdated(posts: [Post])
}
