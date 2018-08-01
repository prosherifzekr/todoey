//
//  AddCategoryViewController.swift
//  todoey
//
//  Created by Sherif  Wagih on 7/31/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import CoreData
protocol sendItemBack {
    func getItem(newItem:Item);
}
class AddItemViewController: UIViewController {
    var delegate:sendItemBack?
    var category: Category?;
    var colorNumber: Int?;
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Date Picker display date only
        myDatePicker.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        //Mar: Request User Permission For Notification
        LocalPushManager.shared.requestAuth();
        let time = TimeInterval("10")
        LocalPushManager.shared.sendLocalPush(in: time!)
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item =  Item(context: context);
        item.title = newItemValue.text!
        item.done = false;
        item.date = myDatePicker.date
        item.parentCategory = category;
        delegate?.getItem(newItem: item);
        self.dismiss(animated: true, completion: nil)
    }
}
