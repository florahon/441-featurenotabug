import UIKit

protocol AddGroceryVCDelegate {
    func controller(controller: AddGroceryViewController, didSaveItemWithName name: String, andQuantity quantity: Int)
}

class AddGroceryViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    
//    @IBOutlet var button: UIButton!
//    @IBOutlet var button2: UIButton!
    
    
    var delegate: AddGroceryVCDelegate?
    
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

//extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion:nil)
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as?
//                UIImage else{
//                    return
//                }
//        imageView.image = image
//    }
//
//}
