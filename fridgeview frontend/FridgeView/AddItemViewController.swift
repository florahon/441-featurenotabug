import UIKit
import UserNotifications

class CellClass: UITableViewCell {
    
}

protocol AddItemVCDelegate {
    func controller(controller: AddItemViewController, didSaveItemWithName name: String, andQuantity quantity: Int, andExpr_Date expr_date: String, andCategory category: String)
}

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var expr_dateTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var myImg: UIImageView!
    
    @IBOutlet weak var btnSelectCategory: UIButton!
    let transparentView = UIView()
        let tableView = UITableView()
        
        var selectedButton = UIButton()
        
        var dataSource = [String]()
    
    var category = ""
    
    var delegate: AddItemVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
                tableView.dataSource = self
                tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
//        var dateString1 = String(month!) + "/" + String(day!) + "/" + String(year!)
//        expr_dateTextField.text = dateString1
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
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            let cameraView = UIImagePickerController()
//            cameraView.delegate = self as?
//            UIImagePickerControllerDelegate & UINavigationControllerDelegate
//            cameraView.sourceType = .camera
//            self.present(cameraView, animated: true, completion: nil)
//        }
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
//                    myImg.contentMode = .scaleToFill
//                    myImg.image = pickedImage
//                }
//                picker.dismiss(animated: true, completion: nil)
//            }
//
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)

            guard let image = info[.editedImage] as? UIImage else {
                print("No image found")
                return
            }
            myImg.contentMode = .scaleToFill
            myImg.image = image
        }
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(sender: UIBarButtonItem) {
        if let name = nameTextField.text, let quantityAsString = quantityTextField.text, let quantity = Int(quantityAsString), let expr_date = expr_dateTextField.text {
                // Notify Delegate
            
            category = selectedButton.currentTitle!
            
            delegate?.controller(controller: self, didSaveItemWithName: name, andQuantity: quantity, andExpr_Date: expr_date, andCategory: category)
                 
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.alert, .sound, .badge]){
                (granted, error) in
            }
            
            // print(expr_dateTextField.text)
            let content = UNMutableNotificationContent()
            content.title = "Your Food is about to Expire!"
            content.body = "You have a week before you food expires"
            
            
            let currentDate = Date()
            if (selectedButton.currentTitle! == "Produce"){
               // print("TESTING to see if this prints in category select")
                let modifiedDate = Calendar.current.date(byAdding: .second, value: 20, to: currentDate)!
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from:modifiedDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let uuidString = UUID().uuidString
                
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    // Check the error parameter and handle any errors
                }
               
            }
            if (selectedButton.currentTitle == "Protein"){
               // print("TESTING to see if this prints in category select")
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 14, to: currentDate)!
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from:modifiedDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let uuidString = UUID().uuidString
                
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    // Check the error parameter and handle any errors
                }
            }
            if (selectedButton.currentTitle == "Dairy"){
                //print("TESTING to see if this prints in category select")
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from:modifiedDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let uuidString = UUID().uuidString
                
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    // Check the error parameter and handle any errors
                }
            }
            if (selectedButton.currentTitle == "Other"){
                //print("TESTING to see if this prints in category select")
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 21, to: currentDate)!
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from:modifiedDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let uuidString = UUID().uuidString
                
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    // Check the error parameter and handle any errors
                }
            }
            
                // Dismiss View Controller
            dismiss(animated: true, completion: nil)
            }
        }
    
    func addTransparentView(frames: CGRect) {
            let window = UIApplication.shared.keyWindow
            transparentView.frame = window?.frame ?? self.view.frame
            self.view.addSubview(transparentView)
            
            tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            self.view.addSubview(tableView)
            tableView.layer.cornerRadius = 5
            
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            tableView.reloadData()
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
            transparentView.addGestureRecognizer(tapgesture)
            transparentView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0.5
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
            }, completion: nil)
        }
        
        @objc func removeTransparentView() {
            let frames = selectedButton.frame
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            }, completion: nil)
            
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
//            let dateString = formatter.string(from: currentDateTime)
            
            
            
//            let components = dateString.components(separatedBy: "/")
//            var month = Int(components[0])
//            var day = Int(components[1])
//            var year = Int(components[2])
            
            if (selectedButton.currentTitle == "Produce"){
                print("TESTING to see if this prints in category select")
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
                let dateString = formatter.string(from:modifiedDate)
                expr_dateTextField.text = dateString
            }
            if (selectedButton.currentTitle == "Protein"){
                print("TESTING to see if this prints in category select")
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 21, to: currentDate)!
                let dateString = formatter.string(from:modifiedDate)
                expr_dateTextField.text = dateString
            }
            if (selectedButton.currentTitle == "Dairy"){
                print("TESTING to see if this prints in category select")
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 14, to: currentDate)!
                let dateString = formatter.string(from:modifiedDate)
                expr_dateTextField.text = dateString
            }
            if (selectedButton.currentTitle == "Other"){
                print("TESTING to see if this prints in category select")
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 28, to: currentDate)!
                let dateString = formatter.string(from:modifiedDate)
                expr_dateTextField.text = dateString
            }
        }

    @IBAction func onClickSelectCategory(_ sender: Any) {
            dataSource = ["Produce", "Dairy", "Protein", "Other"]
            selectedButton = btnSelectCategory
            print("testing before the if statement")
            addTransparentView(frames: btnSelectCategory.frame)
        
        }
}
extension AddItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
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
