//
//  myPageVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class myPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
 
    override func viewDidLoad() {
       super.viewDidLoad()
        profileImageView.applyRadius(radius: profileImageView.frame.height/2)
        
        // Do any additional setup after loading the view.
        
//        var gradient = CAGradientLayer()
//
//        gradient.startPoint = CGPoint(x: 0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        gradient.colors = [
//            UIColor.rgb(red: 65, green: 163, blue: 255),
//            UIColor.rgb(red: 155, green: 65, blue: 250)
//        ]
//        self.divisionLineView.layer.addSublayer(gradient)
        
    }
    

    @IBAction func touchUpCameraButton(_ sender: UIButton) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.profileImageView.image = editedImage //받아온 이미지로 이미지 뷰에 세팅
//        } else if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            self.profileImageView.image = originalImage
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
    
}



