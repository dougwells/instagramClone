//
//  PostViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Doug Wells on 1/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    }
    
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
