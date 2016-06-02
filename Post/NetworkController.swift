//
//  NetworkController.swift
//  Post
//
//  Created by Patrick Pahl on 6/1/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation

class NetworkController{
//The NetworkController will be responsible for building URLs and executing HTTP requests.

    
enum HTTPMethod: String {
    case Post = "POST"
    case Get = "GET"
    case Put = "PUT"
    case Patch = "PATCH"
    case Delete = "DELETE"
    }
    

//    This function takes a base URL, URL parameters, and returns a completed URL with the parameters in place.
//    example: To perform a Google Search, you use the URL https://google.com/search?q=test. 'q' and 'test' 
//    are URL parameters, with 'q' being the name, and 'test' beging the value. This function will take the
//    base URL https://google.com/search and a [String: String] dictionary ["q":"test"], and return 
//    the URL https://google.com/search?q=test
    
    static func urlFromURLParameters(url: NSURL, urlParameters: [String: String]?) -> NSURL {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        components?.queryItems = urlParameters?.flatMap({NSURLQueryItem(name: $0.0, value: $0.1)})
        
        if let url = components?.URL {
            return url
        } else {
            fatalError("URL optional is nil")
        }
    }
    
    
    
//FUNC PURPOSE: FETCH WHATEVER DATA IS AT THE URL AND BRING IT DOWN.
//Set up request, create session we can retrieve things from,
//Data task is created from session and will actually go to the URL and get that information.
//let data task: dont respond until you have data, response or an error
//guard and make sure that data is there- use 'if let completion'
//dataTask.resume -starting this data task for the first time

    static func performRequestWithURL(url: NSURL, httpMethod: HTTPMethod, urlParameters: [String: String]? = nil, body: NSData? = nil, completion: ((data: NSData?, error: NSError?) -> Void)?) {
        
        let requestURL = urlFromURLParameters(url, urlParameters: urlParameters)
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = httpMethod.rawValue
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithRequest(request) {(data, reponse, error) in
            
            if let completion = completion {
                completion(data: data, error: error)
            }
        }
        dataTask.resume()
    }
}



//***Don't forget PLIST INFO!!!
//Open your Info.plist file and add a key-value pair to your Info.plist.
//This key-value pair should be: App Transport Security Settings : [Allow Arbitrary Loads : YES].




