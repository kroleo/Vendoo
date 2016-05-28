//
//  ItemImagePickerViewController.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/27/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

import UIKit

class ItemImagePickerViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var possibleItemImage: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    //class variables
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Connect data:
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Category 1", "Category 2", "Category 3", "Category 4", "Category 5", "Category 6"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "SelectNetworkSegue"){
            (segue.destinationViewController as! NetworksTableViewController).setNetworkSelectFunctionality(true)
        }
     
     
    }
    

}

//MARK: - Camera session methods
extension ItemImagePickerViewController: UIImagePickerControllerDelegate {

}

//MARK: - UIPickerViewDelegate
extension ItemImagePickerViewController: UIPickerViewDelegate {

    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
}

//MARK: - UIPickerViewDatasource
extension ItemImagePickerViewController: UIPickerViewDataSource {
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    
}

//Mark: - IBActions
extension ItemImagePickerViewController {

    @IBAction func chooseSellerNetworks(sender: AnyObject) {
        
        //segue to networks selection
        self.performSegueWithIdentifier("SelectNetworkSegue", sender: self)
    }
    
    
}
