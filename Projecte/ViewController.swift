//
//  ViewController.swift
//  Fira
//
//  Created by 1181432 on 29/1/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchClickDelegate{

    @IBOutlet weak var manualsTable: UITableView!
    
    var manuals:[Manual]!
    var selectedManuals:Set<NSIndexPath>!
    var manualsToSend: [Manual]!
    
    
    func initialize() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectsContext = appDelegate.managedObjectContext
        let fetchProductRequest = NSFetchRequest(entityName: "Manual")
        do {
            manuals = try managedObjectsContext.executeFetchRequest(fetchProductRequest) as! [Manual]
        }
        catch {
            AlertManager.basicAlert(NSLocalizedString("alertTitleRecoverError", comment: " "), message: NSLocalizedString("alertMessageRecoverError", comment: " "), button: NSLocalizedString("Ok", comment: " "), who: self)
        }
        selectedManuals = Set<NSIndexPath>()
    }
    
    func initializeLanguagesForFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let _ = userDefaults.objectForKey("languages") {/* It's not the first time so it already has a value */ }
        else { /* set a default value */
            userDefaults.setObject(["EN","ES","CAT"], forKey: "languages")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initializeLanguagesForFirstTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manuals.count
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    func setPlaceholderImage(cell: ProductTableViewCell) {
        cell.imageManual.image = UIImage(named: Images.placeholder)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("manualCell", forIndexPath: indexPath) as? ProductTableViewCell {
            cell.delegate = self
            cell.path = indexPath
            cell.nameLabel.text = manuals[indexPath.row].name
            let links = manuals[indexPath.row].links
            var languages = ""
            if let unwrappedLinks = links {
                for link in unwrappedLinks {
                    let l = link as! Link
                    languages.appendContentsOf(l.language! + " ")
                }
            }
            else {
                languages =  NSLocalizedString("labelCellWhenNoLinks", comment: " ")
            }
            cell.languagesLabel.text = languages
            //image
            let fileManager = NSFileManager.defaultManager()
            guard manuals[indexPath.row].name != nil else {
                setPlaceholderImage(cell)
                return cell
            }
            let pathURL = applicationDocumentsDirectory.URLByAppendingPathComponent(manuals[indexPath.row].name!)
            if let path = pathURL.path {
                if fileManager.fileExistsAtPath(path), let recoveredData = fileManager.contentsAtPath(path) {
                        cell.imageManual.image = UIImage(data: recoveredData)
                }
                else { setPlaceholderImage(cell) }
            }
            else { setPlaceholderImage(cell) }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
 /* To controll which cells have the switch on */
    func onSwitchChange(active:Bool, indexPath: NSIndexPath) {
        if(active) { selectedManuals.insert(indexPath) }
        else { selectedManuals.remove(indexPath) }
    }
    
 /* As a delegate, when returning from the creation of a new Manual*/
    func newManualAdded(newManual:Manual, addView: ViewControllerAdd) {
        initialize()    //Navigation?
        manuals.append(newManual)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
        addView.dismissViewControllerAnimated(true) {
            let indexPath = NSIndexPath(forRow: self.manuals.count-1, inSection: 0)
            self.manualsTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        }
    }
    
    
 /* To send the manuals with the switch on */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        switch segueIdentifier {
        case "send":
            let destination = segue.destinationViewController as! ViewControllerSend
            destination.manuals = manualsToSend
        default: break
        }
    }
    
    @IBAction func onSendClick() {
        manualsToSend = [Manual]()
        for path in selectedManuals {
            manualsToSend.append(manuals[path.row])
        }
        if manualsToSend.count > 0 {
           performSegueWithIdentifier("send", sender: self)
        }
        else {
            AlertManager.basicAlert(NSLocalizedString("alertTitleSendError", comment: " "), message: NSLocalizedString("alertMessageNoManualsSelected", comment: " "), button: NSLocalizedString("Ok", comment: " "), who: self)
        }
    }

}
