//
//  ViewControllerSend.swift
//  Projecte
//
//  Created by Cristina Fontanet on 10/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit
import MessageUI

class ViewControllerSend: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSendClicked() {
        print("Vaig a cridar a enviar")
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailField.text!])
            mail.setSubject("Some manuals")
            mail.setMessageBody("<p>someText here</p>", isHTML: true)
            presentViewController(mail, animated: true) {
                print("He acabat d'enviar el mail?")
            }
        }
        else {
            let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", preferredStyle: .Alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in  }
            actionSheetController.addAction(cancelAction)

            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true) {
            print("He fet dismiss del viewController")
        }
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
