//
//  EditViewController.swift
//  FridgeView
//
//  Created by Joe Oleszczak on 10/29/21.
//

import UIKit
 
protocol EditVCDelegate {
    func controller(controller: EditViewController, didUpdateItem item: Item)
}
 
class EditViewController: UIViewController {
 
    @IBOutlet var nTextField: UITextField!
    
    @IBOutlet var quantityTextField: UITextField!
    
    @IBOutlet var expr_dateTextField: UITextField!
     
    var item: Item!
     
    var delegate: EditVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // Create Save Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditViewController.save(sender:)))
        
        nTextField.text = item.name
        quantityTextField.text = "\(item.quantity)"
        expr_dateTextField.text = item.expr_date
    }
     
    @objc func save(sender: UIBarButtonItem) {
        if let name = nTextField.text, let quantityAsString = quantityTextField.text, let quantity = Int(quantityAsString), let expr_date = expr_dateTextField.text {
            // Update Item
            item.name = name
            item.quantity = quantity
            item.expr_date = expr_date
             
            // Notify Delegate
            delegate?.controller(controller: self, didUpdateItem: item)
             
            // Pop View Controller
            navigationController?.popViewController(animated: true)
        }
    }
}
