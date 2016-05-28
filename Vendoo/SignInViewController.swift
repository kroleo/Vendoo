//
//  FirstViewController.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/22/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

//NEED TO FIX AUTO LOGIN USING KEYCHAIN AND SECURITY FRAMEWORKS, WILL WORK ON LATER

import UIKit
import FirebaseAuth
import Locksmith


class SignInViewController: UIViewController {
    //class variables
    var isValidated: Bool! = false

    //IBOutlets
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //set up delegates
        self.email.delegate = self
        self.password.delegate = self
        
        if NSUserDefaults.standardUserDefaults().boolForKey("signedIn"){
            
            //load user account from keychain
            self.email.text = NSUserDefaults.standardUserDefaults().objectForKey("email") as? String
            
            let dictionary = Locksmith.loadDataForUserAccount(self.email.text!, inService: "vendoo")
            self.password.text = dictionary!["pass"] as? String
            signInUser(self)
        }else{
            print("user not found")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//IBActions
extension SignInViewController {
    @IBAction func signInUser(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(email.text!, password: password.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    /*If the user has not already signed in then save their log in info*/
                    if !(NSUserDefaults.standardUserDefaults().boolForKey("signedIn")){
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "signedIn")
                        NSUserDefaults.standardUserDefaults().setObject(self.email.text, forKey: "email")
                        //KeychainWrapper.setObject(self.password.text!, forKey: "password")
                        
                        //save data to keychain
                        do{
                            try Locksmith.saveData(["pass": self.password.text!], forUserAccount: self.email.text!, inService: "vendoo")
                            print("account credentials saved")
                        }
                        catch{
                            //could not save data to keychain
                            print("account credentials could not be saved")
                            
                        }
                        print("User saved")
                    }
                    
                    //will remove this line of code once
                    //removes saved user until autologin and security keychain operational
                    //NSUserDefaults.standardUserDefaults().setBool(false, forKey: "signedIn")
                    self.performSegueWithIdentifier("HomeScreenSegue", sender:nil)
                    
                })
            }
        }
        
    }
    
}



//Mark: - TextField Delegate Methods
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //dismissKeyboard()
        self.view.endEditing(true)
        return false
    }
    
}

//MARK: - Navigation Methods
extension SignInViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
            
        case "HomeScreenSegue":
            //logic to prepare user for application use after firebase login
            //Testing OAuth
            
            break
        default:
            //default logic for any other segues
            break
            
        }
    }
}


//Private Class Helper Methods
extension SignInViewController {
    
}



