import UIKit

protocol AddItemVCDelegate {
    func controller(controller: AddItemViewController, didSaveItemWithName name: String, andQuantity quantity: Int, andExprDate expr_date: String)
}

class AddItemViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var expr_dateTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    
    var delegate: AddItemVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageView.backgroundColor = .secondarySystemBackground
//
//        button.backgroundColor = .systemBlue
//        button.setTitle("Take Picture", for: .normal)
//        button.setTitleColor(.white, for: .normal)
    }
    
//    @IBAction func didTapButton(sender: UIBarButtonItem){
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = self
//        present(picker, animated: true)
//    }
    @IBAction func camera(_ sender: Any){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraView = UIImagePickerController()
            cameraView.delegate = self as?
            UIImagePickerControllerDelegate & UINavigationControllerDelegate
            cameraView.sourceType = .camera
            self.present(cameraView, animated: true, completion: nil)
        }
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(sender: UIBarButtonItem) {
        if let name = nameTextField.text, let quantityAsString = quantityTextField.text, let quantity = Int(quantityAsString), let expr_date = expr_dateTextField.text {
                // Notify Delegate
            delegate?.controller(controller: self, didSaveItemWithName: name, andQuantity: quantity, andExprDate: expr_date)
                
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
