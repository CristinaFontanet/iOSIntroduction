//
//  ProductTableViewCell.swift
//  Fira
//
//  Created by 1181432 on 3/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit

protocol SwitchClickDelegate {
    func onSwitchChange(active:Bool, indexPath: NSIndexPath)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var imageManual: UIImageView!
    
    var delegate: SwitchClickDelegate!
    var path: NSIndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchClicked(sender: UISwitch) {
        delegate.onSwitchChange(sender.on, indexPath: path)
    }
    
}
