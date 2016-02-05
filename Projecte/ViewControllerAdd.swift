//
//  ViewControllerAdd.swift
//  Projecte
//
//  Created by 1181432 on 4/2/16.
//  Copyright © 2016 FIB. All rights reserved.
//

import UIKit

class ViewControllerAdd: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, linksDelegate {

    
    var links = [String]()
    var languages = ["Mozzarella","Gorgonzola","Provolone","Brie","Maytag Blue","Sharp Cheddar","Monterrey Jack","Stilton","Gouda","Goat Cheese", "Asiago"]
    var picker:UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            cell.linkText.text = links[indexPath.row]
            cell.which = indexPath
            return cell
        }
        return UITableViewCell()
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
    
    @IBAction func onAddLinkClicked() {
       // let alert =
        let actionSheetController: UIAlertController = UIAlertController(title: "Add link", message: "Copy from the browser and Paste here the download link", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in //no fem res quan cliquem cancel
        }
        let nextAction: UIAlertAction = UIAlertAction(title: "Save", style: .Default) { action -> Void in
            print("falta guardar el link")
        }
        
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(nextAction)
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.textColor = UIColor.blueColor()
        }
        
        let pickerFrame: CGRect = CGRectMake(0,0, 0, 0); // CGRectMake(left), top, width, height) - left and top are like margins
        picker = UIPickerView(frame: pickerFrame);
        
        //  set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
      //  picker.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height / 2.0)
  //      let auxContr = UIViewController()
   
        //  Add the picker to the alert controller
        actionSheetController .view.subviews[0].subviews[0].subviews[0].addSubview(picker);
      //  actionSheetController.addChildViewController(picker)
      //  actionSheetController.view.bounds = CGRectMake(200.0,200.0,200.0,200)
        
      //  actionSheetController.view.sizeThatFits(CGSize(width: 200, height: 200))
      //  actionSheetController.automaticallyAdjustsScrollViewInsets = true
      //  actionSheetController.addChildViewController(ViewControllerPicker())
        
        
        print("num: " + String(actionSheetController.view.subviews.count))
        print("View1: " + actionSheetController.view.subviews[0].description)
        print("     num1: " + String(actionSheetController.view.subviews[0].subviews.count))
        print("     View10: " + actionSheetController.view.subviews[0].subviews[0].description)
        print("         num2: " + String(actionSheetController.view.subviews[0].subviews[0].subviews.count))
        print("     View10: " + actionSheetController.view.subviews[0].subviews[0].subviews[0].description)
        print("         num2: " + String(actionSheetController.view.subviews[0].subviews[0].subviews[0].subviews.count))
   //     print("View2: " + actionSheetController.view.subviews[1].description)
//        let topConstraint = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: actionSheetController.view.subviews[0], attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
//        actionSheetController.view.addConstraint(topConstraint)
        let botConstraint = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: actionSheetController.view.subviews[1], attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        actionSheetController.view.addConstraint(botConstraint)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
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
