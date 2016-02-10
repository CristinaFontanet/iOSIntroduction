//
//  ViewControllerSend.swift
//  Projecte
//
//  Created by Cristina Fontanet on 10/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit
import MessageUI

class ViewControllerSend: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, priorityLanguages, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var languagesTable: UITableView!
    
    var links = [Link]()
    var manuals: [Manual]!
    var priority = [priorityLang]()
    
    struct priorityLang {
        var priority:Int
        var language:String
    }
    
    func initializePriority(){
        var languages = [String]()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let lang = userDefaults.objectForKey("languages") {
            if let hope = lang as? [String] {
                languages = hope
            }
        }
        for lang in languages {
            priority.append(priorityLang(priority: 0, language: lang))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        mailField.delegate = self
        initializePriority()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

/*Return Key */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

/*Table functions */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priority.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCellWithIdentifier("languagePriority", forIndexPath: indexPath) as? TableViewCellLanguagePriority {
            cell.languageLabel.text = priority[indexPath.row].language
            cell.priorityStepper.value = Double(priority[indexPath.row].priority)
            cell.priorityLabel.text = String(priority[indexPath.row].priority)
            cell.languageNum = indexPath.row
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
/* Do all stuff to send a message with the links in the prefered language*/
    @IBAction func onSendClicked() {
        selectLinksToSend()
        
        sendEmail()
    }
    /* For each Manual, we want to send the link in the language determinate for the language priority selected if it exists; if the manual doesn't have any of the languages selected, the link will be in some other language aviable*/
    func selectLinksToSend() {
        /*languages ordered in descendent priority */
        self.priority.sortInPlace { $0.priority > $1.priority }
        
        for manual in manuals {
            var i = 0
            var trobat = false
        
            while i < priority.count && !trobat {
                if let link = manual.hasLanguage(priority[i].language) {
                    trobat = true
                    links.append(link)
                }
                ++i
            }
            /* As each Manual has at least one link, links will be never empty*/
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailField.text!])
            mail.setSubject("Some manuals")
            var message = Mail.previousNameMessage + nameField.text! + Mail.afterNameMessage
            for link in links {
                message.appendContentsOf(Mail.previousLinksMessage)
                message.appendContentsOf(link.link!)
                message.appendContentsOf(Mail.afterLinkMessage)
                message.appendContentsOf((link.manual?.name!)!)
                message.appendContentsOf(Mail.afterNameLinkMessage)
            }
            message.appendContentsOf(Mail.lastMessage)
            mail.setMessageBody(message, isHTML: true)
            presentViewController(mail, animated: true, completion: nil)
        }
        else {
            AlertManager.basicAlert(NSLocalizedString("Error", comment: " "), message: NSLocalizedString("alertMessageMail", comment: " "), button: NSLocalizedString("Ok", comment: " "), who: self)
        }
    }
    
    /*Once we return from the mailView, we reorder the languages according to the previous priority in case we have to resend */
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.languagesTable.reloadData()
    }
    
 /* As delegate, to mantain the user priority language*/
    func priorityChanged(which: Int, newPriority: Int) {
        self.priority[which].priority = newPriority
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
