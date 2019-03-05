//
//  myPageVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class myPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var majorLabel: UILabel!
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.applyRadius(radius: profileImageView.frame.height / 2)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    
    @IBAction func touchUpCameraButton(_ sender: UIButton) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage: UIImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.profileImageView.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage: UIImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.profileImageView.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getData() {
        let query = "/user"
        let urlString = UserAPI.sharedInstance.baseURLString + query
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        guard let key = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(key, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            if error != nil {
                print(error.debugDescription)
            }
            
            
            guard let data = data else {
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(UserNetworkModel.self, from: data)
                
                DispatchQueue.main.async { [weak self] in
                    self?.nameLabel.text = apiResponse.data.userName
                    self?.idLabel.text = apiResponse.data.userNickname
                    self?.majorLabel.text = apiResponse.data.userMajor
                    self?.schoolLabel.text = apiResponse.data.userUniv
                }
                
            } catch (let err) {
                print(err.localizedDescription)
            }
        }
    }

}



/* 혹시나 쓸수 있어서 남겨 둡니다.
 @objc func logoutClicked(_ sender: AnyObject) {
 KOSession.shared().logoutAndClose { [weak self] (success, error) -> Void in
 _ = self?.navigationController?.popViewController(animated: true)
 }
 }
 
 @objc func removeDefaults(_ sender: Any) {
 let dictionary = UserDefaults.standard.dictionaryRepresentation()
 
 dictionary.keys.forEach { (key) in
 UserDefaults.standard.removeObject(forKey: "poster")
 }
 }
 */
