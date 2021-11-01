//
//  CameraViewController.swift
//  FridgeView
//
//  Created by Akash Agrawal Bejarano on 10/31/21.
//

import Foundation
import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.backgroundColor = .secondarySystemBackground
        
        button.backgroundColor = .systemBlue
        button.setTitle("Take Picture", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
    }
    @IBAction func didTapButton(){
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.delegate = self
        present(camera, animated: true)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as?
                UIImage else{
                    return
                }
        imageView.image = image
    }
    
}
