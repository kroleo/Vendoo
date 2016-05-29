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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Initialization code
        self.networks.delegate = self
        self.networks.dataSource = self
        self.networks.backgroundView?.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setListing(pic: UIImage, title: String, description: String, price: String, category: String){
        
        //fatal error: unexpectedly found nil while unwrapping an Optional value <- need to figure this out
        /*
        self.itemPicture.image = pic
        self.itemTitle.text = title
        self.itemDescription.text = description
        self.itemPrice.text = price
        self.itemCategory.text = category
         */
    }
    
    func setDictionary(dictionary:Dictionary<String, Bool>){
        self.networksDictionary = dictionary
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
            break
            
        case 1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("amazon", forIndexPath: indexPath)
            break
        case 2:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("etsy", forIndexPath: indexPath)
            break
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("facebook", forIndexPath: indexPath)
            break
        }
        
        
        return cell
    }
    
}
