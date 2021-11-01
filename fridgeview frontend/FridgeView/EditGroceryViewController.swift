import UIKit
 
protocol EditGroceryVCDelegate {
    func controller(controller: EditGroceryViewController, didUpdateItem item: GroceryItem)
}
 
class EditGroceryViewController: UIViewController {
 
    @IBOutlet var nTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
     
    var item: GroceryItem!
     
    var delegate: EditGroceryVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // Create Save Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditViewController.save(sender:)))
        
        nTextField.text = item.name
        quantityTextField.text = "\(item.quantity)"
    }
     
    @objc func save(sender: UIBarButtonItem) {
        if let name = nTextField.text, let quantityAsString = quantityTextField.text, let quantity = Int(quantityAsString) {
            // Update Item
            item.name = name
            item.quantity = quantity
             
            // Notify Delegate
            delegate?.controller(controller: self, didUpdateItem: item)
             
            // Pop View Controller
            navigationController?.popViewController(animated: true)
        }
    }
}
