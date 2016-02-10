//
//  ViewControllerSettings.swift
//  Projecte
//
//  Created by 1181432 on 4/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit

class ViewControllerSettings: UIViewController {

    var newLang:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 /* Add a new manual*/
    @IBAction func onButtonClicked(sender: UIButton) {
        performSegueWithIdentifier("addManual", sender: self)
    }
    
/* Add a new language*/
    func alreadyExistsLanguage(languages: [String], newLanguage:String)->Bool {
        for lang in languages {
            if lang == newLanguage {return true}
        }
        return false
    }
    
    @IBAction func onAddLanguageClicked() {
        let alert = UIAlertController(title: NSLocalizedString("New Language", comment: " "), message: NSLocalizedString("Add a new language", comment: " "), preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: " "), style: .Default, handler: { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            let newLanguage = textField!.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if newLanguage != "" {
                var languages = [String]()
                let userDefaults = NSUserDefaults.standardUserDefaults()
                if let lang = userDefaults.objectForKey("languages") {
                    if let hope = lang as? [String] {
                        languages = hope
                    }
                }
                if !self.alreadyExistsLanguage(languages, newLanguage: newLanguage) {
                    languages.append(newLanguage)
                    userDefaults.setObject(languages, forKey: "languages")
                    AlertManager.basicAlert(NSLocalizedString("alertTitleNewLanguageOk", comment: " "), message: NSLocalizedString("alertMessageNewLanguageOk", comment: " "), button: NSLocalizedString("Ok", comment: " "), who: self)
                }
                else {
                    AlertManager.basicAlert(NSLocalizedString("alertTitleSaveError", comment: " "), message: NSLocalizedString("alertMessageNewLanguageError", comment: " "), button: NSLocalizedString("Ok", comment: " "), who: self)
                }
            }
        })
        
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("alertActionCancel", comment: " "), style: .Cancel) { (action: UIAlertAction) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler {        //x afegir el textField
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion:  nil)
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
