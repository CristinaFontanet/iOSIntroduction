//
//  TableViewCellLink.swift
//  Projecte
//
//  Created by 1181432 on 4/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit

protocol linksDelegate {
    func deleteButtonSelected(which: NSIndexPath)
}

class TableViewCellLink: UITableViewCell {
    
    var delegate:linksDelegate!
    var which: NSIndexPath!

    @IBOutlet weak var linkText: UILabel!
    @IBOutlet weak var languageText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

/*Alert that the delete button of the cell has been pressed */
    @IBAction func onButtonClicked(sender: UIButton) {
        delegate.deleteButtonSelected(which)
    }
}
