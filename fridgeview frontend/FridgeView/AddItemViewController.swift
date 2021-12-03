import UIKit
import UserNotifications
import Alamofire

class CellClass: UITableViewCell {
    
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

protocol AddItemVCDelegate {
    func controller(controller: AddItemViewController, didSaveItemWithName name: String, andQuantity quantity: Int, andExpr_Date expr_date: String, andCategory category: String)
}

class AddItemViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var expr_dateTextField: UITextField!

    @IBOutlet weak var imageTake: UIImageView!
    var imagePicker: UIImagePickerController!
    
    var choice = 0
    let serverUrl = "https://3.131.128.223"
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    struct ScannedItems{
        static var scanned = [Item]()
    }
    
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

    @IBAction func takePhoto(_ sender: UIButton) {
        choice = 0
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto1(_ sender: UIButton) {
        choice = 1
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
//    func selectImageFrom1(_ source: ImageSource){
//        imagePicker =  UIImagePickerController()
//        imagePicker.delegate = self
//        switch source {
//        case .camera:
//            imagePicker.sourceType = .camera
//        case .photoLibrary:
//            imagePicker.sourceType = .photoLibrary
//        }
//        present(imagePicker, animated: true, completion: nil)
//    }
    
    
 
    
    // ___________________

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

extension AddItemViewController: UIImagePickerControllerDelegate{

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
       imagePicker.dismiss(animated: true, completion: nil)
       guard let selectedImage = info[.originalImage] as? UIImage else {
           print("Image not found!")
           return
       }
       imageTake.image = selectedImage
       //let jsonObj = ["receipt": imageTake.image]
       
       ScannedItems.scanned = []
           
       if choice == 0 {
           guard let apiUrl = URL(string: serverUrl+"/scanreceipt/") else {
               print("postReceipt: Bad URL")
               return
           }
           
           guard let getUrl = URL(string: serverUrl+"/getitems/") else {
               print("getReceipt: Bad URL")
               return
           }
           
           let id = randomString(length: 20)
           print("id: " + id)
           let imgData = imageTake.image!.jpegData(compressionQuality: 1.0)
           
           AF.upload(multipartFormData: { mpFD in
               if let image = imgData {
                   mpFD.append(image, withName: "receipt", fileName: "receipt", mimeType: "image/jpeg")
               }
               if let identifier = id.data(using: .utf8) {
                   mpFD.append(identifier, withName: "identifier")
               }
           }, to: apiUrl, method: .post).response { response in
               switch (response.result) {
               case .success:
                   print(response.debugDescription)
                   print("postChatt: chatt posted!")
               case .failure:
                   print("postChatt: posting failed")
               }
               
           }
           let secondsToDelay = 20.0
           DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
               print("passes post")
               let jsonObj = ["identifier": id]
               AF.request(getUrl, method: .get, parameters: jsonObj, encoding: URLEncoding.default).responseJSON { response in
                   print("gets to here")
                   print(response.debugDescription)
                       if case let .success(items) = response.result {
                           if let dictionary = items as? [String: Any] {
                               for (key, value) in dictionary {
                                   print("key: " + key)
                                   print("value: ")
                                   print(value)
                               }
                           }
                       } else{
                           print("failed")
                       }
                       }
           }
           let viewController = ReceiptViewController()
           self.present(viewController, animated: true, completion: nil)
       }
       else if choice == 1 {
           guard let apiUrl = URL(string: serverUrl+"/scanimage/") else {
               print("postReceipt: Bad URL")
               return
           }
           
           guard let getUrl = URL(string: serverUrl+"/getitems/") else {
               print("getReceipt: Bad URL")
               return
           }
           
           let id = randomString(length: 20)
           print("id: " + id)
           let imgData = imageTake.image!.jpegData(compressionQuality: 1.0)
           
           AF.upload(multipartFormData: { mpFD in
               if let image = imgData {
                   mpFD.append(image, withName: "image", fileName: "image", mimeType: "image/jpeg")
               }
               if let identifier = id.data(using: .utf8) {
                   mpFD.append(identifier, withName: "identifier")
               }
           }, to: apiUrl, method: .post).response { response in
               switch (response.result) {
               case .success:
                   print(response.debugDescription)
                   print(response.error)
                   print("postChatt: image posted!")
               case .failure:
                   print("postChatt: posting failed")
               }
               
           }
           let secondsToDelay = 15.0
           DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
               print("passes post")
               let jsonObj = ["identifier": id]
               AF.request(getUrl, method: .get, parameters: jsonObj, encoding: URLEncoding.default).responseJSON { response in
                   print(response.debugDescription)
                   print(response.result)
                   let currentDate = Date()
                               let formatter = DateFormatter()
                               formatter.dateStyle = .short
                   let modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
                                   let dateString = formatter.string(from:modifiedDate)
                       if case let .success(items) = response.result {
                           if let dictionary = items as? [String: Any] {
                               for (key, value) in dictionary {
                                   if key == "items"{
                                       if let dict2 = value as? [String: Any] {
                                           for (key, value) in dict2 {
                                               print(value)
                                               let item = Item(name: value as! String, quantity: 1, expr_date: dateString, category: "Other")
                                               ScannedItems.scanned.append(item)
                                               print("item name: " + item.name)
                                           }
                                       }
                                   }
                               }
                           }
                       } else{
                           print("failed")
                       }
                       }
               let seconds = 2.0
               DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                   print(ScannedItems.scanned.count)
                   self.performSegue(withIdentifier: "CameraVC", sender: self)
               }
           }
           
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
