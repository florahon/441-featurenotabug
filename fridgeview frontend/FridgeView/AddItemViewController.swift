import UIKit

protocol AddItemVCDelegate {
    func controller(controller: AddItemViewController, didSaveItemWithName name: String, andQuantity quantity: Int)
}

class AddItemViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    
    var delegate: AddItemVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(sender: UIBarButtonItem) {
        if let name = nameTextField.text, let quantityAsString = quantityTextField.text, let quantity = Int(quantityAsString) {
                // Notify Delegate
            delegate?.controller(controller: self, didSaveItemWithName: name, andQuantity: quantity)
                
                // Dismiss View Controller
            dismiss(animated: true, completion: nil)
            }
        }

}
