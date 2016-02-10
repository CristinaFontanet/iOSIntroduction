//
//  ViewControllerAddLink.swift
//  Projecte
//
//  Created by 1181432 on 5/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit

protocol linkAddDelegate {
        func saveNewDownloadLinkSelected(link:String, language:String)
}

class ViewControllerAddLink: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var languagesPicker: UIPickerView!
    @IBOutlet weak var linkText: UITextField!
    
    var delegate: linkAddDelegate!
    var languages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkText.becomeFirstResponder()

        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let lang = userDefaults.objectForKey("languages") {
            if let hope = lang as? [String] {
                languages = hope
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/*Picker functions */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
/* Save new link */
    @IBAction func saveClicked() {
        /* Check that there's something writted and send the new information link to the delegate*/
        if linkText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet() ) != "" {
                delegate.saveNewDownloadLinkSelected(linkText.text!, language: languages[languagesPicker.selectedRowInComponent(0)])
        }
    }
    
    @IBAction func cancelClicked() {
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
