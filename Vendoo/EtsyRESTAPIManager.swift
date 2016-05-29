//
//  EtsyRESTConnectionManager.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/25/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

//NOT ABLE TO CAPTURE NEEDED DATA FROM RESPONSE IN OAUTH PROCESS FOR ETSY

import Foundation
import SwiftyJSON
import OAuthSwift

typealias ServiceResponse = (JSON, NSError?) -> Void

class EtsyRESTAPIManager: NSObject {
    
    //API Manager class variables
    //----------------------------------------------//
    static let sharedInstance = EtsyRESTAPIManager()
    
    let baseURL = "https://openapi.etsy.com/v2"

    private var apiKey: String!
    private var apiSecret: String!
    var isAuthorized: Bool = NSUserDefaults.standardUserDefaults().boolForKey("etsyAuthorized")
    //---------------------------------------------//
    
    //User specific class variables
    private var etsyUser: String!
    //private let oauthswift = OAuth1Swift(parameters: ["consumerKey":"snbs78qkfy3yqq6yhe6yv49b","consumerSecret":"4sbva4oqb6", "requestTokenUrl": "https://openapi.etsy.com/v2/oauth/request_token?scope=listings_w%20listings_r%20listings_d%20transactions_r%20transactions_w%20"])
    
    override init(){
        if let path = NSBundle.mainBundle().pathForResource("Services", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            // use swift dictionary as normal
            
            self.apiKey = ((dict["Etsy"] as! Dictionary<String, AnyObject>)["consumerKey"] as! String)
            self.apiSecret = ((dict["Etsy"] as! Dictionary<String, AnyObject>)["consumerSecret"] as! String)
        }
        
        
    }
    
    
}

//Mark: - OAuth Methods
extension EtsyRESTAPIManager {
    
    //makes application ready for use with users ebay account
    func authorizeApp(viewcontroller: UIViewController){
        
                
       /*
    
         let oauthswift = OAuth1Swift(parameters: ["consumerKey":"snbs78qkfy3yqq6yhe6yv49b","consumerSecret":"4sbva4oqb6", "requestTokenUrl" : "https://openapi.etsy.com/v2/oauth/request_token?scope=listings_w%20listings_r%20listings_d%20transactions_r%20transactions_w",
         "authorizeUrl":    "",
         "accessTokenUrl":  ""])
        
        //oauthswift.authorize_url_handler = SafariURLHandler(viewController: viewcontroller)
        
        oauthswift!.client.get("https://openapi.etsy.com/v2/oauth/request_token?scope=listings_w%20listings_r%20listings_d%20transactions_r%20transactions_w",
                              success: {
                                data, response in
                                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                                print(dataString!)
                                
                                
        
                                
                                //getting error here when trying to retrieve the login url from the response
                                //var dataDictionary = self.convertStringToDictionary(dataString! as String)
                                //print(dataDictionary!["login_url"])
            }
            , failure: { error in
                print(error)
            }
        )
        
        oauthswift!.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/etsy")!, success: {
            credential, response, parameters in
            
            }, failure: { error in
                print(error.localizedDescription)
        })
 
 */
        
        //once everything is authorized save true value to the authorization boolean
        /*
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "etsyAuthorized")
        self.isAuthorized = NSUserDefaults.standardUserDefaults().boolForKey("etsyAuthorized")
         */
    }
    
    
    
    
}

//MARK: - Request Methods
extension EtsyRESTAPIManager {
    func generateUserRequest(etsyName: String!, etsyOptions: [String]!) -> String {
        
        //starting url for user request to api
        var userRequest: String!
        
        if(etsyName == nil || etsyName == ""){
            userRequest = (baseURL + "/users/etsystore?")
        }
        else{
            userRequest = (baseURL + "/users/" + etsyName + "?")
        }
        
        //final api request
        return userRequest + "api_key=" + self.apiKey
    }
    
    func generateListingRequest(etsyListing: String!){
        
        //starting url for listing request
    }
    
    //sends the pregenerated url as a request to api service
    func sendGETRequest(request: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: request)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
    //sends the pregenerated url as a request to api service
    func sendPOSTRequest(request: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: request)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        do {
            // Set the POST body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            request.HTTPBody = jsonBody
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(nil, error)
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(nil, nil)
        }
    }
    
}

//MARK: - JSON Methods
extension EtsyRESTAPIManager {
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
