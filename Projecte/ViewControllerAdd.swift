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
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    func initCore() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectsContext = appDelegate.managedObjectContext
        entityManualDescription = NSEntityDescription.entityForName("Manual", inManagedObjectContext: managedObjectsContext) //descripció d'entitat, no instacia!!
        entityLinkDescription = NSEntityDescription.entityForName("Link", inManagedObjectContext: managedObjectsContext) //descripció d'entitat, no instacia!!
        manual = Manual(entity: entityManualDescription!, insertIntoManagedObjectContext: managedObjectsContext )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manualName.delegate = self //Per poder amagar el teclat
        imageView.image = UIImage(named: Images.placeholder)
        newPicture = false
        
        initCore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

 /* ReturnKey */
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
            let mess =  NSLocalizedString("repeatedLanguagePrevious", comment: " ") + language + NSLocalizedString("repeatedLanguageAfter", comment: " ")
            AlertManager.basicAlert(NSLocalizedString("alertTitleSaveError", comment: " "), message: mess, button: NSLocalizedString("Ok", comment: " "), who: self)
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
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("alertTitleDeleteLink", comment: " "), message: NSLocalizedString("alertMessageDeleteLink", comment: " "), preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("No", comment: " "), style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        
        /////HEREEEEEEEEEEEEEEEEEE
        let yesAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Yes", comment: " "), style: .Default) { action -> Void in
            /*let aux = self.manual.links as! NSMutableSet
            aux.removeObject(self.links[which.row])
            self.manual.links = aux as NSSet */
            self.managedObjectsContext.deleteObject(self.links[which.row])
            self.links.removeAtIndex(which.row)
            self.linksTable.reloadData()
        }
        actionSheetController.addAction(yesAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

/*Add image */
    @IBAction func onImageAddClicked(sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("alertTitleImage", comment: " "), message: "", preferredStyle: .Alert)
        let firstAction = UIAlertAction(title: NSLocalizedString("alertActionCamera", comment: " "), style: .Default) { (alert: UIAlertAction!) -> Void in
            self.cameraOptionSelected()
        }
        alert.addAction(firstAction)
        
        let secondAction = UIAlertAction(title: NSLocalizedString("alertActionFile", comment: " "), style: .Default) { (alert: UIAlertAction!) -> Void in
            self.cameraRollOptionSelected()
        }
        alert.addAction(secondAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("alertActionCancel", comment: " "), style: .Default) { (alert: UIAlertAction!) -> Void in
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
            AlertManager.basicAlert(NSLocalizedString("alertTitleSaveError", comment: " "), message: (error?.localizedDescription)!, button: NSLocalizedString("Ok", comment: " "), who: self)
        }
        else {
        }
    }
    
    func saveImageToDocuments(image: UIImage, name:String){
        let dataImag = UIImagePNGRepresentation(image)
        let fileURL = applicationDocumentsDirectory.URLByAppendingPathComponent(name)
        if let data = dataImag {
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
                AlertManager.basicAlert(NSLocalizedString("alertTitleSaveError", comment: " "), message: NSLocalizedString("alertMessageAddLinks", comment: " "), button: NSLocalizedString("Ok", comment: " "), who: self)
            }
        }
        else {
            AlertManager.basicAlert(NSLocalizedString("alertTitleSaveError", comment: " "), message: NSLocalizedString("alertMessageWriteName", comment: " "), button: NSLocalizedString("Ok", comment: " "), who: self)
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
