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
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query?.findObjectsInBackground { (objects, error) in
            self.users.removeAll()
            self.messages.removeAll()
            self.usernames.removeAll()
            self.imageFiles.removeAll()
            print("Feed arrays start empty")
        
            
            if let users = objects {    //note: DIFFERENT "users".  Scope (since used let)
                
                print("--- user query returned ---")
                for object in users {
                    print("---for object in users returned ---")
                    
                    if let user = object as? PFUser {
                        print("username =", user.username)
                        
                        self.users[user.objectId! as String] = user.username!  //update dict of usernames
                        print("add to dict of usernames,", self.users[user.objectId!])
                        
                    }
                }
            }
            
            let getFollowedUsersQuery = PFQuery(className: "Followers")
            getFollowedUsersQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let followers = objects {
                    print("--- followers returned ---")
                   
                    for object in followers {
                        
                        if let follower = object as? PFObject {
                            
                            let followedUser = follower["following"] as! String
                            
                            let query = PFQuery(className: "Posts")
                            query.whereKey("userid", equalTo: followedUser)
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let posts = objects {
                                    print("--- posts returned ---")
                                    for object in posts {
                                        if let post = object as? PFObject {
                                            
                                            //now have posts from one followed friend
                                            self.messages.append(post["message"] as! String)
                                            self.imageFiles.append(post["imageFile"] as! PFFile)
                                            
                                            print("userid =", post["userid"])
                                            //self.usernames.append("Linda")
                                            self.usernames.append(self.users[post["userid"] as! String]!)
                                            print("messages", self.messages)
                                            print("usernames", self.usernames)
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            })
            
        }

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
        return imageFiles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell

        // Configure the cell...
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
            if let downloadedImage = UIImage(data: imageData) {
                    cell.postedImage.image = downloadedImage
            }
            }
        }
        
        cell.usernameLabel.text = usernames[indexPath.row]
        cell.messageLabel.text = messages[indexPath.row]


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
