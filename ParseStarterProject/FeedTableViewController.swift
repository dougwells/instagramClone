//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Doug Wells on 1/11/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
/* Steps to get feed of members the logged in user is following
     1) pass in userIDs array from ViewController
            userIDs = ["1234"]
     
     2) perform query on Parse each query id
     
     3) append results
        - ideally to an object w/properties
        - could keep simple and merely have arrays for each
            a) userID
            b) username
            c) array of images
            d) string array of messages
     
*/
    
    var users = [String: String]()
    var messages = [""]
    var usernames = [String]()
    var imageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery()
        query.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {    //note: DIFFERENT "users".  Scope (since used let)
                
                print("--- user query returned ---")
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!  //update dict of usernames
                        
                    }
                }
            }
            
            let getFollowedUsersQuery = PFQuery(className: "Followers")
            getFollowedUsersQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let followers = objects {
                   
                    for object in followers {
                        
                        if let follower = object as? PFObject {
                            
                            let followedUser = follower["following"] as! String
                            
                            let query = PFQuery(className: "Posts")
                            query.whereKey("userid", equalTo: followedUser)
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let posts = objects {
                                    for object in posts {
                                        if let post = object as? PFObject {
                                            //now have posts from one followed friend
                                            self.messages.append(post["message"] as! String)
                                            self.imageFiles.append(post["imageFile"] as! PFFile)
                                            self.usernames.append(self.users[post["userid"] as! String] as! String!)
                                        }
                                    }
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            })
            
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell

        // Configure the cell...
        cell.postedImage.image = UIImage(named: "peopleIcon.png")
        cell.usernameLabel.text = "Doug"
        cell.messageLabel.text = "Nice photo ..."


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
