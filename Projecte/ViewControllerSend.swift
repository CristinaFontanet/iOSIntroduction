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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
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
    
    
    @IBAction func onSendClicked() {
        print("Vaig a preparar els links de " + String(manuals.count) + " manuals")
        selectLinksToSend()
        print("Vaig a cridar a enviar")
        sendEmail()
    }
    
    func selectLinksToSend() {
        self.priority.sortInPlace { $0.priority > $1.priority }
        
        for manual in manuals {
            print("aquest manual te " + String(manual.links?.count) + " links")
            var i = 0
            var trobat = false
            
            while i < priority.count && !trobat {
                if let link = manual.hasLanguage(priority[i].language) {
                    print("el manual te l'idioma " + priority[i].language)
                    trobat = true
                    links.append(link)
                }
                else {
                    print("el manual NOOO te l'idioma " + priority[i].language)
                }
                ++i
            }
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
            let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in  }
            actionSheetController.addAction(cancelAction)

            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.languagesTable.reloadData()
    }
    
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
