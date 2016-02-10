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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonClicked(sender: UIButton) {
        performSegueWithIdentifier("addManual", sender: self)
    }

    func alreadyExistsLanguage(languages: [String], newLanguage:String)->Bool {
        for lang in languages {
            if lang == newLanguage {return true}
        }
        return false
    }
    
    @IBAction func onAddLanguageClicked() {
        let alert = UIAlertController(title: "New Language", message: "Add a new language", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in
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
                    
                    AlertManager.basicAlert(NSLocalizedString("alertTitleNewLanguageOk", comment: " "), message: "The new language has been saved.", button: "Ok", who: self)
                }
                else {
                    AlertManager.basicAlert(NSLocalizedString("alertTitleNewLanguageError", comment: " "), message: "This language already exists", button: "Ok", who: self)
                }
            }
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) -> Void in }
        
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
