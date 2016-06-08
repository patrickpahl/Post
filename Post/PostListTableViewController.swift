//
//  PostListTableViewController.swift
//  Post
//
//  Created by Patrick Pahl on 6/6/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    let postController = PostController()                               ////why?
   
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        presentNewPostAlert()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
       postController.fetchPosts(reset: false) { (newPosts) in                            //func willDisplayCell - fetchPosts
        
        if !newPosts.isEmpty{
            self.tableView.reloadData()
        }
    }     ////Check if the indexPath.row of the cell parameter is greater than the number of posts currently loaded on the postController.
}
    
    
    
    func presentNewPostAlert(){
        
    let alertController = UIAlertController(title: "New Post", message: nil, preferredStyle: .Alert)
        
        var usernameTextField: UITextField?                         //Make these optional
        var messageTextField: UITextField?
        
        alertController.addTextFieldWithConfigurationHandler { (usernameField) in
            
            usernameField.placeholder = "display username..."
            usernameTextField = usernameField
        }
        
        alertController.addTextFieldWithConfigurationHandler { (messageField) in
            
            messageField.placeholder = "What's up?"
            messageTextField = messageField
        }
        
        let postAction = UIAlertAction(title: "Post", style: .Default) { (action) in
            
            guard let username = usernameTextField?.text where !username.isEmpty,
            let text = messageTextField?.text where !text.isEmpty else {
            //    self.presentErrorAlert()
                return}
        
        self.postController.addPost(username, text: text)
        }
        
        
        alertController.addAction(postAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
        
    
    
    
    
    @IBAction func refreshControlPulled(sender: UIRefreshControl) {         //TO ADD THIS: ViewController, Attribute Inspector, Refreshing: Enabled
                                                                            //Create action: Must of type UIREFRESHCONTROL!!!
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        postController.fetchPosts { (newPosts) in
        
        sender.endRefreshing()
            
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true            
        
        postController.delegate = self
    }
    
    //The length of the text on each Post is variable. Add support for dynamic resizing cells to your tableview so messages are not truncated.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postController.posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)

        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(indexPath.row) - \(post.username) - \(NSDate(timeIntervalSince1970: post.timestamp))"

        return cell
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostListTableViewController: PostControllerDelegate{
    
    func postsUpdated(post: [Post]) {
        tableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}




