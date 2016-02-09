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
    
    var selectedIndexPath:NSIndexPath!
    var manuals =  [Manual]()
    var selectedManuals = [Int:NSIndexPath] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectsContext = appDelegate.managedObjectContext
        //   entityDescription = NSEntityDescription.entityForName(entityManualName, inManagedObjectContext: managedObjectsContext) //descripció d'entitat, no instacia!!
        let fetchProductRequest = NSFetchRequest(entityName: "Manual")
        do {
            manuals = try managedObjectsContext.executeFetchRequest(fetchProductRequest) as! [Manual]
        }
        catch {
            print(error)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        print("Hey, he seleccionat")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manuals.count
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "FIB.Projecte" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("userAttribute", forIndexPath: indexPath)
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
                languages = "There are no links"
            }
            cell.languagesLabel.text = languages
            //image
            let fileManager = NSFileManager.defaultManager()
            guard manuals[indexPath.row].name != nil else {
                cell.imageManual.image = UIImage(named: "Book")
                return cell
            }
            let pathURL = applicationDocumentsDirectory.URLByAppendingPathComponent(manuals[indexPath.row].name!)
            if let path = pathURL.path {
                if fileManager.fileExistsAtPath(path), let recoveredData = fileManager.contentsAtPath(path) {
                        cell.imageManual.image = UIImage(data: recoveredData)
                }
                else {
                    cell.imageManual.image = UIImage(named: "Book")
                    print("error no existeix fitxer al path :" + path)
                }
            }
            else {
                cell.imageManual.image = UIImage(named: "Book")
                print("error")
            }
            return cell
        }
    
        return UITableViewCell()
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func onSwitchChange(active:Bool, indexPath: NSIndexPath) {
        if(active) {print("He activat el switch de la linia " + String(indexPath.row) ) }
        else {print("He DESACTIVAT el switch de la linia " + String(indexPath.row) ) }
    }
    
    func newManualAdded(newManual:Manual, addView: ViewControllerAdd) {
        manuals.append(newManual)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveContext()
        addView.dismissViewControllerAnimated(true) {
            let indexPath = NSIndexPath(forRow: self.manuals.count-1, inSection: 0)
            self.manualsTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
        }
    }
    
    
    @IBAction func onSendClick() {
        performSegueWithIdentifier("send", sender: self)
    }

}

