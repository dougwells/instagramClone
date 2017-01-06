/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var changeSignupModeButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    
    let activityIndicator = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
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
    
    @IBAction func signupOrLogin(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter both email and password")
            
        } else {
            startSpinner()
            if signupMode {
                // Save user in Parse
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                user.signUpInBackground { (success, error) -> Void in
                    self.stopSpinner()
                    if success {
                        print("New user \(user.email) saved")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    } else {
                        if error != nil {
                            print("Error saving user", error)
                            var displayErrorMessage = "Please try again later ..."
                            if let errorMessage = error as NSError? {
                                displayErrorMessage = errorMessage.userInfo["error"] as! String
                            }
                            self.createAlert(title: "Signup Error", message: displayErrorMessage)
                        }
                    }
                }
            } else {    //Login mode
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    self.stopSpinner()
                    if (user != nil) {
                        print("Existing user logged in", user)
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        //self.createAlert(title: "Successful", message: "Welcome to Instagram!")
                    }
                    if error != nil {
                        print("Error logging in existing user", error)
                        var displayErrorMessage = "Please try again later ..."
                        if let errorMessage = error as NSError? {
                            displayErrorMessage = errorMessage.userInfo["error"] as! String
                        }
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                    }
                })
            }
            
        }
    }
    
    func createAlert(title: String, message: String ) {
        //creat alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //add button to alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        //present alert
        self.present(alert, animated: true, completion: nil)
    }
 
    @IBAction func changeSignupMode(_ sender: Any) {
        if signupMode {
            //Change layout to login
            
            signupOrLoginButton.setTitle("Log In", for: [])
            messageLabel.text = "Don't have an account?"
            changeSignupModeButton.setTitle("Sign Up", for: [])
            
            
            
            
        } else {
            signupOrLoginButton.setTitle("Sign Up", for: [])
            messageLabel.text = "Already have an account?"
            changeSignupModeButton.setTitle("Log In", for: [])
        }
        signupMode = !signupMode
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
