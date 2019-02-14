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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.applyRadius(radius: profileImageView.frame.height / 2)
    }
  
    @IBAction func removeDefaults(_ sender: Any) {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys.forEach { (key) in
            UserDefaults.standard.removeObject(forKey: "poster")
        }
        print("지웠음")
    }
    
    @IBAction func touchUpCameraButton(_ sender: UIButton) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logoutClicked(_ sender: AnyObject) {
        KOSession.shared().logoutAndClose { [weak self] (success, error) -> Void in
            _ = self?.navigationController?.popViewController(animated: true)
        }
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
    

//    func getData(careerType: Int) {
//        
//        let json: [String: Any] = ["careerType" : careerType]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        let url = URL(string: "http://54.180.79.158:8080/users/info")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
//        request.addValue(key2, forHTTPHeaderField: "Authorization")
//        request.httpBody = jsonData
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            guard error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            do {
//                let apiResponse = try JSONDecoder().decode(Career.self, from: data)
//                print("orders: \(apiResponse)")
//                if careerType == 0 {
//                    //                    self.activityList = apiResponse.data
//                    DispatchQueue.main.async {
//                        //                        self.activityTableView.reloadData()
//                    }
//                }
//            } catch (let err) {
//                print(err.localizedDescription)
//                print("sladjalsdjlasjdlasjdlajsldjas")
//            }
//        }
//        task.resume()
//    }

    func getData(careerType: String) {
        
        let json: [String: Any] = ["careerType" : careerType]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "http://54.180.32.22:8080/users/info")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue(key2, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            guard let data = data else {
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(Career.self, from: data)
                print("orders: \(apiResponse)")
                if careerType == "0" {
                    //                    self.activityList = apiResponse.data
                    DispatchQueue.main.async {
                        //                        self.activityTableView.reloadData()
                    }
                }
            } catch (let err) {
                print(err.localizedDescription)
                print("sladjalsdjlasjdlasjdlajsldjas")
            }
        }
    }

}



