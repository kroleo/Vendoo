//
//  ItemCell.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/26/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

/*
 This class will hold references to all ui elements of a particular item listing. These ui outlets will be manipulated through the ItemTableViewController Delegate and datasource methods, and the data will come from calls to the REST and WSDL api's
 */

import UIKit

class ItemCell: UITableViewCell, UICollectionViewDelegate {
    
    //@IBOutlets
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemStatus: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var networks: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.networks.delegate = self
        self.networks.dataSource = self
        self.networks.backgroundView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}



// MARK: UICollectionViewDataSource
extension ItemCell: UICollectionViewDataSource{
    
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
        
        
        // Configure the cell (in this case show or hide the cell depending on which network the item is being listed on)
        
        return cell
    }
    
    
}


// MARK: UICollectionViewDelegate
extension ItemCell {
    
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
