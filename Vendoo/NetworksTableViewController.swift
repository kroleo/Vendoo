//
//  NetworksTableViewController.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/26/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

/*
 NOTES:
 
 //Make it so u are accessing REST api service managers from TabController
 //to promote more centralized code.
 
 //For now putting rest service managers in this controller file to test OAuth: EtsyRESTServiceManager,
 //FacebookGraphAPIServiceManager, EbayServiceManager, and AmazonServiceManager.
 */

import UIKit

class NetworksTableViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //class variables
    private var networkToggleOrSelect: Bool = false
    private var networksDictionary: Dictionary<String, Bool> = ["ebay":false, "amazon":false,"etsy":false,"facebook":false]
    
    
    //temporary class variables /*TESTING*/
    let etsyManager = EtsyRESTAPIManager()
    let fbGraphManager = FacebookGraphAPIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //set the class boolean in order to choose what toggling each network does
    func setNetworkSelectFunctionality(bool: Bool){
        self.networkToggleOrSelect = bool
    }
    
}


// MARK: - Navigation
extension NetworksTableViewController {
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - TableView Datasource methods
extension NetworksTableViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        //case where class is being used in new item posting workflow to select which network to sell on
        //may hide future networks that don't apply to a listing
        if(self.networkToggleOrSelect){
            
            switch (indexPath.row){
                
            case 0:
                //loads network cell for ebay
                cell = (self.tableView.dequeueReusableCellWithIdentifier("ebay", forIndexPath: indexPath) as! EbayTableViewCell)
                break
            case 1:
                //loads network cell for amazon
                cell = (self.tableView.dequeueReusableCellWithIdentifier("amazon", forIndexPath: indexPath) as! AmazonTableViewCell)
                break
            case 2:
                //loads network cell for etsy
                cell = (self.tableView.dequeueReusableCellWithIdentifier("etsy", forIndexPath: indexPath) as! EtsyTableViewCell)
                break
            default:
                //loads network cell for ebay
                cell = (self.tableView.dequeueReusableCellWithIdentifier("facebook", forIndexPath: indexPath) as! FBTableViewCell)
                break
            }
        
        }
        else{
        
            //case where class is being used to authorize a network for the app to post on
            switch (indexPath.row){
                
            case 0:
                //loads network cell for ebay
                cell = (self.tableView.dequeueReusableCellWithIdentifier("ebay", forIndexPath: indexPath) as! EbayTableViewCell)
                break
            case 1:
                //loads network cell for amazon
                cell = (self.tableView.dequeueReusableCellWithIdentifier("amazon", forIndexPath: indexPath) as! AmazonTableViewCell)
                break
            case 2:
                //loads network cell for etsy
                cell = (self.tableView.dequeueReusableCellWithIdentifier("etsy", forIndexPath: indexPath) as! EtsyTableViewCell)
                break
            default:
                //loads network cell for ebay
                cell = (self.tableView.dequeueReusableCellWithIdentifier("facebook", forIndexPath: indexPath) as! FBTableViewCell)
                break
            }
        }
        
        
        
        
        // Configure the cell (in this case show or hide the cell depending on which network the item is being listed on)
        
        return cell
    }
}



//SET UP TO ADD EACH INTEGRATION AS DEVELOPMENT GETS TO IT

//MARK: - Tableview Delegate Methods
extension NetworksTableViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //case where class is being used in new item posting workflow to select which network to sell on
        if(self.networkToggleOrSelect){
            
            switch (indexPath.row){
            case 0:
                let cell: EbayTableViewCell!
                cell = (self.tableView.dequeueReusableCellWithIdentifier("ebay", forIndexPath: indexPath) as! EbayTableViewCell)
                cell.setSelected(false, animated: false)
                
                //selection code for ebay
                //print(cell.networkToggle.on)
                if(cell.networkToggle.on){
                    
                    
                    cell.networkToggle.setOn(false, animated: true)
                    cell.networkToggle.on = false
                    
                    
                    //code to deselect network
                    self.networksDictionary["ebay"] = false

                }
                else{
                    
                    cell.networkToggle.setOn(true, animated: true)
                    cell.networkToggle.on = true
                    
                    //code to select network
                    self.networksDictionary["ebay"] = true
                }
                
                break
            case 1:
                let cell: AmazonTableViewCell!
                cell = (self.tableView.dequeueReusableCellWithIdentifier("amazon", forIndexPath: indexPath) as! AmazonTableViewCell)
                cell.setSelected(false, animated: false)
                
                
                //selection code for amazon
                if(cell.networkToggle.on == true){
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(false, animated: true)
                    })
                    //code to deselect network
                    self.networksDictionary["amazon"] = false

                    
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(true, animated: true)
                    })
                    //code to select network
                    self.networksDictionary["amazon"] = true

                }
                
                break
                
                
            case 2:
                let cell: EtsyTableViewCell!
                
                cell = (self.tableView.dequeueReusableCellWithIdentifier("etsy", forIndexPath: indexPath) as! EtsyTableViewCell)
                cell.setSelected(false, animated: false)
                
                
                //selection code for etsy
                if(cell.networkToggle.on == true){
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(false, animated: true)
                    })
                    
                    //code to deselect network
                    self.networksDictionary["etsy"] = false
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(true, animated: true)
                    })
                    //code to select network
                    self.networksDictionary["etsy"] = true
                    
                    
                    //this is the type of code desired to access the rest management classes
                    /*
                     let tabBar = self.tabBarController
                     (tabBar as? HomeViewController)?.etsyManager.authorizeApp(self)
                     */
                    
                    
                }
                
                break
                
            default:
                
                let cell: FBTableViewCell!
                
                cell = (self.tableView.dequeueReusableCellWithIdentifier("facebook", forIndexPath: indexPath) as! FBTableViewCell)
                cell.setSelected(false, animated: false)
                
                
                //selection code for facebook
                if(cell.networkToggle.on == true){
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(false, animated: true)
                    })
                    
                    //code to deselect network
                    self.networksDictionary["facebook"] = false
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(true, animated: true)
                    })
                    //code to select network
                    self.networksDictionary["facebook"] = true
                    
                    //this is the type of code desired to access the REST management classes
                    /*
                     let tabBar = self.tabBarController
                     (tabBar as? HomeViewController)?.fbGraphManager.authorizeApp(self)
                     */
                    
                    
                }
                
                
                break
                
            }

            
        }
        else{
            
            //case where class is being used to authorize a network for the app to post on
            switch (indexPath.row){
            case 0:
                let cell: EbayTableViewCell!
                cell = (self.tableView.dequeueReusableCellWithIdentifier("ebay", forIndexPath: indexPath) as! EbayTableViewCell)
                cell.setSelected(false, animated: false)
                
                //OAuthorization code for ebay
                print(cell.networkToggle.on)
                if(cell.networkToggle.on){
                    
                    
                    cell.networkToggle.setOn(false, animated: true)
                    cell.networkToggle.on = false
                    
                    
                    //code to deauthorize network
                }
                else{
                    
                    cell.networkToggle.setOn(true, animated: true)
                    cell.networkToggle.on = true
                    
                    //code to authorize network
                }
                
                break
            case 1:
                let cell: AmazonTableViewCell!
                cell = (self.tableView.dequeueReusableCellWithIdentifier("amazon", forIndexPath: indexPath) as! AmazonTableViewCell)
                cell.setSelected(false, animated: false)
                
                
                //OAuthorization code for amazon
                if(cell.networkToggle.on == true){
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(false, animated: true)
                    })
                    //code to deauthorize network
                    
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(true, animated: true)
                    })
                    //code to authorize network
                }
                
                break
                
                
            case 2:
                let cell: EtsyTableViewCell!
                
                cell = (self.tableView.dequeueReusableCellWithIdentifier("etsy", forIndexPath: indexPath) as! EtsyTableViewCell)
                cell.setSelected(false, animated: false)
                
                
                //OAuthorization code for etsy
                if(cell.networkToggle.on == true){
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(false, animated: true)
                    })
                    
                    //code to deauthorize network
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(true, animated: true)
                    })
                    //code to authorize network
                    
                    
                    //this is the type of code desired to access the rest management classes
                    /*
                     let tabBar = self.tabBarController
                     (tabBar as? HomeViewController)?.etsyManager.authorizeApp(self)
                     */
                    
                    self.etsyManager.authorizeApp(self)
                }
                
                break
                
            default:
                
                let cell: FBTableViewCell!
                
                cell = (self.tableView.dequeueReusableCellWithIdentifier("facebook", forIndexPath: indexPath) as! FBTableViewCell)
                cell.setSelected(false, animated: false)
                
                
                //OAuthorization code for facebook
                if(cell.networkToggle.on == true){
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(false, animated: true)
                    })
                    
                    //code to deauthorize network
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.networkToggle.setOn(true, animated: true)
                    })
                    //code to authorize network
                    
                    //this is the type of code desired to access the rest management classes
                    /*
                     let tabBar = self.tabBarController
                     (tabBar as? HomeViewController)?.fbGraphManager.authorizeApp(self)
                     */
                    
                    self.fbGraphManager.authorizeApp(self)
                }
                
                
                break
                
            }

        }
        
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
