//
//  PostViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Doug Wells on 1/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //declare activityIndicator (needed for functions start/stop spinner)
    var activityIndicator = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 300, width: 100, height: 100))
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBAction func chooseAnImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        //gives ViewController control over imagePickerController
        imagePickerController.delegate = self
        
        //set imagePicker to photo library (.camera if wanted)
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //No need to edit images
        imagePickerController.allowsEditing = false
        
        //present image
        self.present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func postImage(_ sender: Any) {
        self.startSpinner()
        let post = PFObject(className: "Posts")
        post["message"] = messageTextField.text
        post["userid"] = PFUser.current()?.objectId
        
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.5)
        let imageFile = PFFile(name: "image.jpeg", data: imageData!)
        post["imageFile"] = imageFile
        
        post.saveInBackground { (success, error) in
            self.stopSpinner()
            if error != nil {
                self.createAlert(title: "Error Saving Image", message: "Please try again later.  Thanks")
            } else {
                self.createAlert(title: "Successfully Saved Image", message: "Make sure to share this with your friends")
                self.messageTextField.text = ""
                self.imageToPost.image = UIImage(named: "placeHolder.jpg")
            }
        }
    }
    
    
    //Let user choose photo from photo library (existing method)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //function passes us object "info" on user selected image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //update imageView on main.storyboard
            imageToPost.image = image
        
        } else {
            print("Error getting image")
        }
     
        //close this function
        self.dismiss(animated: true, completion: nil)
    }
    
    func createAlert(title: String, message: String ) {
        //creat alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //add button to alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        //present alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func startSpinner(){
        
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func stopSpinner(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
