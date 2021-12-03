//
//  CameraRecipeViewController.swift
//  FridgeView
//
//  Created by Akash Agrawal Bejarano on 12/2/21.
//

import Foundation
import UIKit
import Alamofire


class CameraRecipeViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageTake: UIImageView!
    var imagePicker: UIImagePickerController!
    
    var choice = 0
    let serverUrl = "https://3.131.128.223"
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    struct ScannedRecipeItems{
        static var scanned = [Item]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    
    @IBAction func takePhoto(_ sender: Any) {
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
    
    
}

extension CameraRecipeViewController: UIImagePickerControllerDelegate{

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
       imagePicker.dismiss(animated: true, completion: nil)
       guard let selectedImage = info[.originalImage] as? UIImage else {
           print("Image not found!")
           return
       }
       imageTake.image = selectedImage
       
       ScannedRecipeItems.scanned = []
       
       if choice == 0 {
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
                                               ScannedRecipeItems.scanned.append(item)
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
                   print(ScannedRecipeItems.scanned.count)
                   self.navigationController?.popViewController(animated: true)
                   self.performSegue(withIdentifier: "CameraScanVC", sender: self)
               }
           }
           
       }
   }
}
