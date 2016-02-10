//
//  TableViewCellLanguagePriority.swift
//  Projecte
//
//  Created by 1181432 on 10/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit

protocol priorityLanguages {
    func priorityChanged(which: Int, newPriority: Int)
}

class TableViewCellLanguagePriority: UITableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var priorityStepper: UIStepper!
    @IBOutlet weak var priorityLabel: UILabel!
    
    var languageNum:Int!
    var delegate: priorityLanguages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priorityStepper.wraps = false
        priorityStepper.autorepeat = true
        priorityStepper.maximumValue = 10
        priorityStepper.minimumValue = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
 /* alert the change to the delegate */
    @IBAction func valueChanged(sender: UIStepper) {
        priorityLabel.text = Int(sender.value).description
        delegate.priorityChanged(languageNum, newPriority: Int(sender.value))
    }

}
