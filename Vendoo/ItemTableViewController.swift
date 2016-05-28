//
//  ItemTableViewController.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/26/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

/*
 This class will be used to retrieve and manipulate data seen by the end user for he/she's item listings
 */
import UIKit

class ItemTableViewController: UIViewController {

    //tableview outlet
    @IBOutlet weak var itemTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //set delegates
        self.itemTable.dataSource = self
        self.itemTable.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

   

    /*
    
    */

}


// MARK: - Navigation
extension ItemTableViewController {
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - TableView Datasource methods
extension ItemTableViewController: UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ItemCell! = (tableView.dequeueReusableCellWithIdentifier("Item Cell", forIndexPath: indexPath) as! ItemCell)
        
        // Configure the cell...
        //for each listing cell generated need to find the marketplaces it belongs to, the listing price, the name of the item, the status of the item, and the item image.
        //Once these objects are retrieved, access the ItemCell properties and manipulate as needed
        
        return cell
    }
}


//MARK: - Tableview Delegate Methods
extension ItemTableViewController: UITableViewDelegate {
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
