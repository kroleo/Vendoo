//
//  NetworkTableViewCell.swift
//  Vendoo
//
//  Created by Okechi Onyeje on 5/26/16.
//  Copyright © 2016 Okechi Onyeje. All rights reserved.
//

import UIKit

class EbayTableViewCell: UITableViewCell {
    @IBOutlet weak var networkToggle: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class AmazonTableViewCell: UITableViewCell {
    @IBOutlet weak var networkToggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class EtsyTableViewCell: UITableViewCell {
    @IBOutlet weak var networkToggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class FBTableViewCell: UITableViewCell {
    @IBOutlet weak var networkToggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
