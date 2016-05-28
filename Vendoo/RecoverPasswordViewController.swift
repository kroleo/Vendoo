
//  RecoverPasswordViewController.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/25/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

//NEED TO MAKE ALERT NAVIGATE BACK TO LOGIN ONCE RECOVERY IS SENT

import UIKit
import FirebaseAuth

class RecoverPasswordViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet var recoveryEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //set delegates
        self.recoveryEmail.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//IBActions
extension RecoverPasswordViewController {
    
    @IBAction func recoverySubmit(sender: AnyObject){
        //sets up alert view for case where recovery email given is not valid or not in firebase
        let prompt = UIAlertController.init(title: "Invalid Email", message: "The email given was either not valid or not registered, please try again with a valid email.", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { (action) in }
        
        
        if(isValidEmail(recoveryEmail.text!)){
            
            //sends recovery email to user if email supply is a valid email regex
            FIRAuth.auth()?.sendPasswordResetWithEmail(recoveryEmail.text!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    prompt.addAction(okAction)
                    self.presentViewController(prompt, animated: true, completion: nil);
                    return
                }
                else{
                    //prompt user that recovery email was sent correctly
                    let success = UIAlertController.init(title: "Recovery Sent", message: "A Recovery email has been sent with instructions on how to recover your account.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAct = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default)
                    { (action) in
                        //self.parentViewController?.parentViewController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    success.addAction(okAct)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(success, animated: true, completion: nil)
                    })
                    
                }
            }
        }else{
            
            prompt.addAction(okAction)
            self.presentViewController(prompt, animated: true, completion: nil);
            
            
        }
        
    }
    
}

//MARK: - UITextField Delegates
extension RecoverPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //dismissKeyboard()
        self.view.endEditing(true)
        return false
    }
    
}

//MARK: - Navigation Methods
extension RecoverPasswordViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
}

//Class Helper Functions
extension RecoverPasswordViewController {
    
    //Validate Email/Username
    func isValidEmail(testStr:String) -> Bool {
        
        print("Validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }
}
