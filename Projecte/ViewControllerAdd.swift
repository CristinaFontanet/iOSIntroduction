//
//  ViewControllerAdd.swift
//  Projecte
//
//  Created by 1181432 on 4/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class ViewControllerAdd: UIViewController, UITableViewDataSource, UITableViewDelegate, linksDelegate, linkAddDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var linksTable: UITableView!
    @IBOutlet weak var manualName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    /* CoreData */
    var appDelegate: AppDelegate!
    var managedObjectsContext: NSManagedObjectContext!
    var entityManualDescription:NSEntityDescription! //descripció d'entitat, no instacia!!
    var entityLinkDescription:NSEntityDescription! //descripció d'entitat, no instacia!!
    
   /* image */
    var fileManager:NSFileManager!
    var fileURL:NSURL?
    var newPicture:Bool!
    var image:UIImage!
    
    var lastAddLinkView:ViewControllerAddLink!
    var manual: Manual!
    var links = [Link]()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "FIB.Projecte" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manualName.delegate = self //Per poder amagar el teclat
        imageView.image = UIImage(named: "Book")
        newPicture = false
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectsContext = appDelegate.managedObjectContext
        entityManualDescription = NSEntityDescription.entityForName("Manual", inManagedObjectContext: managedObjectsContext) //descripció d'entitat, no instacia!!
        entityLinkDescription = NSEntityDescription.entityForName("Link", inManagedObjectContext: managedObjectsContext) //descripció d'entitat, no instacia!!
        manual = Manual(entity: entityManualDescription!, insertIntoManagedObjectContext: managedObjectsContext )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
/* Table functions */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCellWithIdentifier("linkCell", forIndexPath: indexPath) as? TableViewCellLink {
            cell.delegate = self
            cell.linkText.text = links[indexPath.row].link
            cell.languageText.text = links[indexPath.row].language
            cell.which = indexPath
            return cell
        }
        return UITableViewCell()
    }
    
/* Segue */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let segueIdentifier = segue.identifier else {
            return
        }
        
        print(segueIdentifier)
        
        switch segueIdentifier {
        case "linkAdd":
            let destination = segue.destinationViewController as! ViewControllerAddLink
            destination.delegate = self
            lastAddLinkView = destination
        case "newManual":
            let dest = segue.destinationViewController as! UINavigationController
            let destination = dest.topViewController as! ViewController
            destination.newManualAdded(manual, addView: self)
        default: break
        }
        
    }
    
/* Add links */
    @IBAction func onAddLinksClicked() {
        performSegueWithIdentifier("linkAdd", sender: self)
    }
    
    func saveNewDownloadLinkSelected(link:String, language:String) {
        if let _ = manual.hasLanguage(language) {
            let mess = "This manual already has a " + language + " link"
            let ac = UIAlertController(title: "Save error", message: mess, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
        else {
            lastAddLinkView.dismissViewControllerAnimated(true) {
                let newLink = Link(entity: self.entityLinkDescription!, insertIntoManagedObjectContext: self.managedObjectsContext )
                newLink.manual = self.manual
                newLink.language = language
                newLink.link = link
                self.links.append(newLink)
                let indexPath = NSIndexPath(forRow: self.links.count-1, inSection: 0)
                self.linksTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
            }
        }
        
    }
    
/* Delete links */
    func deleteButtonSelected(which: NSIndexPath) {
        print("Delete from " + String(which.row) + " selected")
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete link", message: "Are you sure you want to delete this link?", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        
        /////HEREEEEEEEEEEEEEEEEEE
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            let aux = self.manual.links as! NSMutableSet
            aux.removeObject(self.links[which.row])
            self.manual.links = aux as NSSet
            self.links.removeAtIndex(which.row)
            self.linksTable.reloadData()
        }
        actionSheetController.addAction(yesAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

/*Add image */
    @IBAction func onImageAddClicked(sender: UIButton) {
        let alert = UIAlertController(title: "Choose an image", message: "", preferredStyle: .Alert) // 1
        let firstAction = UIAlertAction(title: "From camera", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.cameraOptionSelected()
        }
        alert.addAction(firstAction)
        
        let secondAction = UIAlertAction(title: "From file", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.cameraRollOptionSelected()
        }
        alert.addAction(secondAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in
            //discard
        }
        alert.addAction(cancelAction)
     
        presentViewController(alert, animated: true, completion:nil)
    }
    
    func cameraOptionSelected() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                newPicture = true
        }
    }
    
    func cameraRollOptionSelected() {
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            newPicture = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeImage as String {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            if (newPicture == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
                
            } else if mediaType == kUTTypeMovie as String {
                // Code to support video here
            }
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error != nil {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
        else {
        }
    }
    
    func saveImageToDocuments(image: UIImage, name:String){
        let dataImag = UIImagePNGRepresentation(image)
        let fileURL = applicationDocumentsDirectory.URLByAppendingPathComponent(name)
        if let data = dataImag {
            print("guardem al path: " + fileURL.path!)
            data.writeToFile(fileURL.path!, atomically: true)
            manual.imagePath = fileURL.path
        }
    }
    
    
/* SAVE */
    @IBAction func onSaveClicked() {
        let nameManual = manualName.text!
        if nameManual.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
            if links.count > 0 {
                manual.name = nameManual
                if let newImage = image {
                    saveImageToDocuments(newImage, name: nameManual)
                }
                //no passa res si no posen foto
                performSegueWithIdentifier("newManual", sender: self)
            }
            else {
                let ac = UIAlertController(title: "Save error", message: "Add links please", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(ac, animated: true, completion: nil)
            }
        }
        else {
            let ac = UIAlertController(title: "Save error", message: "Write a name please", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func onCancelClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
