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

class FacebookGraphAPIManager: NSObject {

    //API Manager class variables
    //----------------------------------------------//
    static let sharedInstance = FacebookGraphAPIManager()
    
    let graphBaseURL = "graph.facebook.com"
    
    private var apiKey: String!
    private var apiSecret: String!
    var isAuthorized: Bool = NSUserDefaults.standardUserDefaults().boolForKey("fbAuthorized")
    //---------------------------------------------//
    
    override init(){
        if let path = NSBundle.mainBundle().pathForResource("Services", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            // use swift dictionary as normal
            
            self.apiKey = ((dict["Facebook"] as! Dictionary<String, AnyObject>)["consumerKey"] as! String)
            self.apiSecret = ((dict["Facebook"] as! Dictionary<String, AnyObject>)["consumerSecret"] as! String)
        }
    }

    
}


//MARK: - OAuth Methods
extension FacebookGraphAPIManager {

    func authorizeApp(viewcontroller: UIViewController){
        let oauthswift = OAuth2Swift(
            consumerKey:    self.apiKey,
            consumerSecret: self.apiSecret,
            authorizeUrl:   "https://www.facebook.com/dialog/oauth",
            accessTokenUrl: "https://graph.facebook.com/oauth/access_token",
            responseType:   "code"
        )
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/vendoo")!, scope: "public_profile", state: state, success: {
            credential, response, parameters in
            
            }, failure: { error in
                print(error.localizedDescription, terminator: "")
        })
        
        //once everything is authorized save true value to the authorization boolean
        /*
         NSUserDefaults.standardUserDefaults().setBool(true, forKey: "etsyAuthorized")
         self.isAuthorized = NSUserDefaults.standardUserDefaults().boolForKey("fbAuthorized")
         */
    }

}
