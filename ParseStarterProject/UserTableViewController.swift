//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Doug Wells on 1/6/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var usernames = [""]
    var userIDs = ["1234"]
    var isFollowing = ["1234" : false]

    @IBAction func logout(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                print("Error logging user out")
            } else {
                print("Existing user logged out")
                self.performSegue(withIdentifier: "logoutSegue", sender: self)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //query the User Parse DB
        print("viewDidLoad")
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            print("findObjectsInBackround returned")
            if error != nil {
                
                print("Error getting users", error)
                
            } else if let users = objects {
                
                self.usernames.removeAll()
                self.userIDs.removeAll()
                self.isFollowing.removeAll()
                print("Arrays start empty")
                
                //build array of all users stored in Parse
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        let usernameArr = user.username!.components(separatedBy: "@")
                        
                        self.usernames.append(usernameArr[0])
                        self.userIDs.append(user.objectId!)
                     
                    //Pre-identify if logged in users is following any listed users
                        let query = PFQuery(className: "Followers")
                        query.whereKey("follower", equalTo: PFUser.current()?.objectId!)
                        query.whereKey("following", equalTo: user.objectId!)
                        
                        query.findObjectsInBackground(block: { (objects, error) in
                            
                            if let objects = objects {
                                if objects.count > 0 {
                                    self.isFollowing[user.objectId!] = true
                                } else {
                                    self.isFollowing[user.objectId!] = false
                                }
                                
                                if self.isFollowing.count == self.usernames.count {
                                   self.tableView.reloadData()
                                }
                                
                            }
                            
                        })
                    
                    }
                }
            }
            
        })
        
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
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = usernames[indexPath.row]
        print("cell for row at running. UserID =", userIDs[indexPath.row])
        print("isFollowing= \(isFollowing[userIDs[indexPath.row]]!)")
        
        if isFollowing[userIDs[indexPath.row]]! {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        //create nice checkmark next to members that user wants to follow
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        //write & save to Parse DB
        let followersDB = PFObject(className: "Followers")
        followersDB["follower"] = PFUser.current()?.objectId
        followersDB["following"] = userIDs[indexPath.row]
        followersDB.saveInBackground()

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
