//
//  ItemImagePickerViewController.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/27/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

/*
 need to make this class display a top navigation bar so user may cancel the new item posting if need be
 */

import UIKit

class ItemImagePickerViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var possibleItemImage: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemDescription: UITextView!
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
        self.itemDescription.delegate = self
        self.itemName.delegate = self
        self.itemPrice.delegate = self
        
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
            print(self.itemName.text!)
            print(self.itemDescription.text!)
            //print(self.possibleItemImage.image!)
            print(self.itemPrice.text!)
            
            let dict: Dictionary<String, AnyObject> = ["title":self.itemName.text!, "description":self.itemDescription.text!, "picture": UIImage() /*"picture":self.possibleItemImage.image!*/ , "price":self.itemPrice.text!, "category":self.pickerData[self.categoryPicker.selectedRowInComponent(0)]]
            
            (segue.destinationViewController as! NetworksTableViewController).setListingDictionary(dict)
            
            print(self.categoryPicker.selectedRowInComponent(0))
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

extension ItemImagePickerViewController: UITextViewDelegate {

    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.text! == "Description") {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
            //optional
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text! == "") {
            textView.text = "Description"
            textView.textColor = UIColor.lightGrayColor()
            //optional
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
    }
}

extension ItemImagePickerViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.containerScrollView.setContentOffset(CGPointMake(0, 200), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.containerScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
}

//Mark: - IBActions
extension ItemImagePickerViewController {

    @IBAction func chooseSellerNetworks(sender: AnyObject) {
        
        //segue to networks selection
        self.performSegueWithIdentifier("SelectNetworkSegue", sender: self)
    }
    
    
}
