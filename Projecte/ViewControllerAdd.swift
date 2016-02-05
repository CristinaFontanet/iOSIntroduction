//
//  ViewControllerAdd.swift
//  Projecte
//
//  Created by 1181432 on 4/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit

class ViewControllerAdd: UIViewController, UITableViewDataSource, UITableViewDelegate, linksDelegate, linkAddDelegate {

    var manual: Manual!
    var links = [Link]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manual = Manual()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("userAttribute", forIndexPath: indexPath)
        if let cell = tableView.dequeueReusableCellWithIdentifier("linkCell", forIndexPath: indexPath) as? TableViewCellLink {
            cell.delegate = self
            cell.linkText.text = links[indexPath.row].language
            cell.which = indexPath
            return cell
        }
        return UITableViewCell()
    }
    
    
    @IBAction func onAddLinksClicked() {
        performSegueWithIdentifier("linkAdd", sender: self)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let segueIdentifier = segue.identifier else {
            return
        }
        
        print(segueIdentifier)
        
        switch segueIdentifier {
        case "linkAdd":
            let destination = segue.destinationViewController as! ViewControllerAddLink
            destination.delegate = self
            
        default: break
        }
        
    }
    
    func saveNewDownloadLinkSelected(link:String, language:String) {
        let newLink = Link()
        newLink.manual = manual
        newLink.language = language
        newLink.link = link
        
    }
    
    func deleteButtonSelected(which: NSIndexPath) {
        print("Delete from " + String(which.row) + " selected")
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            //Code for launching the camera goes here
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
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
