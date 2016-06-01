//
//  ListingPreviewViewController.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/28/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

/*
 NOTES:
 
 need to display navigation bar so user can navigate back to previous screens if changes need to be made
 
 */

import UIKit

class ListingPreviewViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var itemPicture: UIImageView!
    @IBOutlet weak var itemTitle: UITextView!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemPrice: UITextView!
    @IBOutlet weak var itemCategory: UITextView!
    @IBOutlet weak var networks: UICollectionView!
    
    //class variables
    private var networksDictionary: Dictionary<String, Bool> = Dictionary<String, Bool>()
    private var graphManager: FacebookGraphAPIManager! = nil
    private var itemListingDictionary: Dictionary<String, AnyObject>! = Dictionary<String, AnyObject>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Initialization code
        self.networks.delegate = self
        self.networks.dataSource = self
        self.networks.backgroundView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setListing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setListing(){
        
        //fatal error: unexpectedly found nil while unwrapping an Optional value <- need to figure this out
        
        self.itemPicture.image = (self.itemListingDictionary["picture"] as? UIImageView)!.image
        self.itemTitle.text = self.itemListingDictionary["title"] as! String
        self.itemDescription.text = self.itemListingDictionary["description"] as! String
        self.itemPrice.text = self.itemListingDictionary["price"] as! String
        self.itemCategory.text = self.itemListingDictionary["category"] as! String
    }
    
    func setDictionary(netdictionary:Dictionary<String, Bool>, itemdictionary: Dictionary<String, AnyObject!>){
        self.networksDictionary = netdictionary
        self.itemListingDictionary = itemdictionary
    }
    
    func setFBManager(fbManager: FacebookGraphAPIManager){
        self.graphManager = fbManager
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - IBActions
extension ListingPreviewViewController {

    
    @IBAction func publishItem(sender: AnyObject) {

        //publish items to facebook if it is selected
        let str = "**"+self.itemTitle.text!+"**"+"\n\n"+"Sellng for: "+self.itemPrice.text!+"\n\n"+self.itemDescription.text!
        let parameters = ["message":str]
        
        self.graphManager.makePOSTResquest("me/feed", params: parameters)
        
    }
    
    @IBAction func draftItem(sender: AnyObject) {
        
    }
    
    
}

extension ListingPreviewViewController: UICollectionViewDelegate {
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}

//Mark: - UICollectionViewDataSource methods
//need to dynamically show, hide, and rearrange the network cells based on users choice of networks
extension ListingPreviewViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell!
        
        switch (indexPath.row){
        case 0:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ebay", forIndexPath: indexPath)
            
            if(self.networksDictionary["ebay"] == false){
                cell.hidden = true
            }
            else{
                cell.hidden = false
            }
            break
            
        case 1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("amazon", forIndexPath: indexPath)
            
            if(self.networksDictionary["amazon"] == false){
                cell.hidden = true
            }
            else{
                cell.hidden = false
            }
            break
        case 2:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("etsy", forIndexPath: indexPath)
            
            if(self.networksDictionary["etsy"] == false){
                cell.hidden = true
            }
            else{
                cell.hidden = false
            }
            break
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("facebook", forIndexPath: indexPath)
            
            if(self.networksDictionary["facebook"] == false){
                cell.hidden = true
            }
            else{
                cell.hidden = false
            }
            break
        }
        
        
        return cell
    }
    
}
