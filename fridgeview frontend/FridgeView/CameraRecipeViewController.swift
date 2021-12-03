//
//  CameraRecipeViewController.swift
//  FridgeView
//
//  Created by Akash Agrawal Bejarano on 12/2/21.
//

import Foundation
import UIKit


class CameraRecipeViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageTake: UIImageView!
    var imagePicker: UIImagePickerController!
    
    var choice = 0
    
    enum ImageSource {
        case photoLibrary
        case camera
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
       //let jsonObj = ["receipt": imageTake.image]
   }
}
