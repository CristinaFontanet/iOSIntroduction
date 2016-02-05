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
    var delegate: linkAddDelegate!
    
    @IBOutlet weak var linkText: UITextField!
    let languages = ["EN","ES","CAT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //  myLabel.text = pickerData[row]
        print("He seleccionat "+languages[row])
    }
    
    @IBAction func saveClicked() {
        print(linkText.selectedTextRange?.description)
        if let text = linkText.text {
    delegate.saveNewDownloadLinkSelected(text, language: " ")
        }
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
