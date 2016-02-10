//
//  AlertManager.swift
//  Projecte
//
//  Created by 1181432 on 10/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//


import UIKit


class AlertManager {

    static func basicAlert(title:String, message:String, button:String, who:UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: button, style: .Default, handler: nil))
        who.presentViewController(ac, animated: true, completion: nil)
    }
}