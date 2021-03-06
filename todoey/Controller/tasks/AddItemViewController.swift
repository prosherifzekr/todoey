//
//  AddCategoryViewController.swift
//  todoey
//
//  Created by Sherif  Wagih on 7/31/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

protocol sendItemBack {
    func getItem(newItem:Item);
}
class AddItemViewController: UIViewController {
    var delegate:sendItemBack?
    var category: Category?;
    var colorNumber: Int?;
    var dateFormatter:DateFormatter = DateFormatter();
    var datePickerValueChanged:Bool = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Date Picker display date only
        myDatePicker.datePickerMode = UIDatePickerMode.date
        dateFormatter.dateFormat = "dd MMM yyyy"
        myDatePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
    }
    
    //MARK : Color Button Pressed
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        print(sender.tag);
    }
    //Mark : - Back Button Pressed
    
    
    @IBAction func backButtonPress(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    //Mark : Item TextField Outlet
    @IBOutlet weak var newItemValue: UITextField!
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBAction func addCategoryButtonPressed(_ sender: UIButton) {
        if newItemValue.text?.count != 0
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let item =  Item(context: context);
            item.title = newItemValue.text!
            item.done = false;
            if datePickerValueChanged
            {
                
                if myDatePicker.date.timeIntervalSinceNow.sign == .plus
                {
                   item.date = dateFormatter.string(from:  myDatePicker.date)
                    
                    LocalPushManager.shared.requestAuth();
                    let componentsFromDate = Calendar.current.dateComponents(in: TimeZone.current, from:myDatePicker.date)
                    LocalPushManager().sendLocalPush(in: componentsFromDate,title:"You have something to do",body: item.title!)
                    item.parentCategory = category;
                    delegate?.getItem(newItem: item);
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "Error!!", message: "You must enter a valid Date or don't change the date and leave it blank", preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil);
                }
            }
            else
            {
                item.date = "";
                item.parentCategory = category;
                delegate?.getItem(newItem: item);
                self.dismiss(animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error!!", message: "You must enter a valid Task Name", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil);
        }
    }
    @objc func datePickerChanged(picker: UIDatePicker) {
        datePickerValueChanged = true;
    }
    
}


