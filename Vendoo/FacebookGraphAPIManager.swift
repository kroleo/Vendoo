//
//  FacebookGraphAPIManager.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/26/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

import Foundation
import OAuthSwift
import FBSDKCoreKit
import FBSDKLoginKit
import AeroGearHttp
import AeroGearOAuth2
import OAuthSwift
import Locksmith


/*
 NOTES:
 I am able to authorize application for use with facebook and deauthorize it while showing the toggle button switching back and forth, but during the last step of the process, for some reason NSUserDefault key for fbauthorized is not being called, in response handler, may need to run in a different thread
 */
class FacebookGraphAPIManager: NSObject {

    //API Manager class variables
    //----------------------------------------------//
    static let sharedInstance = FacebookGraphAPIManager()
    
    let graphBaseURL = "https://graph.facebook.com/v2.2"
    
    private var apiKey: String!
    private var apiSecret: String!
    private var userEmail:String = (NSUserDefaults.standardUserDefaults().objectForKey("email") as? String)!
    private let login: FBSDKLoginManager = FBSDKLoginManager()
    var isAuthorized: Bool = NSUserDefaults.standardUserDefaults().boolForKey("fbAuthorized")
    //---------------------------------------------//
    
    override init(){
        if let path = NSBundle.mainBundle().pathForResource("Services", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            // use swift dictionary as normal
            
            self.apiKey = ((dict["Facebook"] as! Dictionary<String, AnyObject>)["consumerKey"] as! String)
            self.apiSecret = ((dict["Facebook"] as! Dictionary<String, AnyObject>)["consumerSecret"] as! String)
            
            if(isAuthorized){
                
                let dictionary = Locksmith.loadDataForUserAccount(self.userEmail, inService: "vendoo")
                print("account credentials loaded")
                //print((NSUserDefaults.standardUserDefaults().objectForKey("") as? FBSDKAccessToken!))
            }
            
        }
    }

    
}


//MARK: - OAuth Methods
extension FacebookGraphAPIManager {
    
    func authorizeApp(viewcontroller: UIViewController) -> Bool{
        
        login.loginBehavior = FBSDKLoginBehavior.Web
        if(!self.isAuthorized){
            if(FBSDKAccessToken.currentAccessToken() == nil){
                var boolResult:Bool = false
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.login.logInWithReadPermissions(["user_posts","public_profile"], fromViewController: viewcontroller, handler: {
                        (result, error) -> Void in
                        
                        if (error != nil)  {
                            NSLog("Process error")
                            boolResult = false
                        }
                        else if result.isCancelled {
                            NSLog("Cancelled")
                            boolResult = false
                        }
                        else {
                            
                            NSLog("Logged in with read permissions")
                            
                            print(result.token)
                            print(result.grantedPermissions)
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey:"fbAuthorized")
                            
                            FBSDKAccessToken.setCurrentAccessToken(result.token)
                            
                            print("user logged in through facebook")
                            self.makeGETRequest("me",params: nil)
                            
                        }
                        if(!FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions")){
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                                self.login.logInWithPublishPermissions(["publish_actions"], fromViewController: nil,handler: {
                                    (result, error) -> Void in
                                    
                                    NSLog("Logged in with publish permisions")
                                })
                                
                            })
                            
                        }
                    })
                })
                
                return boolResult
            }
            print("token not valid")
            return false
        }
        else{
            print(FBSDKAccessToken.currentAccessToken())
            print("user already logged in")
            self.makeGETRequest("me",params: nil)
            return true
        }
        
        
    }
    
    func deAuthorizeApp(viewcontroller: UIViewController) -> Bool{
        
        return self.makeDELETIONResquest("me/permissions", params: nil)
        
    }

}

//MARK: - request methods(GET, POST, DELETE)
extension FacebookGraphAPIManager {
    
    //when making request make sure path starts with '/'
    func makeGETRequest(requestPath: String!, params: [NSObject: AnyObject]!) -> Bool{
    
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: requestPath, parameters: params)
        var boolResult: Bool = false
        
        graphRequest.startWithCompletionHandler({
            (id, result, error) -> Void in
            
            print(result)
            
            
            
        
        })
        return boolResult

    }
    
    //used to post to users timeline, path must start with '/'
    func makePOSTResquest(requestPath: String!, params: [NSObject: AnyObject]!){
        
        
        /*if(FBSDKAccessToken.currentAccessToken() != nil && FBSDKAccessToken.currentAccessToken().hasGranted("pubish_actions")){*/
            
            let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: requestPath, parameters: params, HTTPMethod: "POST")
            graphRequest.startWithCompletionHandler({
                (id, result, error) -> Void in
                print(result)
                //save id in firebase so retrieval can be done later
            })
        //}
        /*else{
            print("must reauthenticate facebook")
        }*/
        
    }
    
    //used to delete permissions and listings from users timeline, path must start with '/'
    func makeDELETIONResquest(requestPath: String!, params: [NSObject: AnyObject]!) -> Bool{
        
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: requestPath, parameters: params, HTTPMethod: "DELETE")
        var boolResult: Bool = false
        dispatch_async(dispatch_get_main_queue(), {
            graphRequest.startWithCompletionHandler({
                (id, result, error) -> Void in
                print(result)
                
                if(requestPath == "me/permssions"){
                    if(error == nil){
                        //this part is not getting called but almost have the oauth done
                        boolResult = true
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey:"fbAuthorized")
                    }
                    else{
                        print(error.localizedDescription)
                        boolResult = false
                        
                    }
                }
                
                boolResult = false
            })
        })
        
        
        return boolResult
    }

}
