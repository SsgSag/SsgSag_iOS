//
//  myPageVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import Photos

class myPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var schoolLabel: UILabel!

    @IBOutlet weak var majorLabel: UILabel!
    
    static private let myImage: String = "myImage"
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()

        profileImageView.applyRadius(radius: profileImageView.frame.height / 2)
    }

    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func loadImage() {
        if let loadedImage = loadImageFromDiskWith(fileName: myPageVC.myImage) {
            profileImageView.image = loadedImage
        }
    }
    
    @IBAction func touchUpCameraButton(_ sender: UIButton) {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            self.present(self.imagePicker, animated: true, completion: nil)
        case .denied, .restricted:
            rePermission()
            print("사진첩 접근 불허 ")
        case .notDetermined:
            print("접근 아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("사용자가 허용")
                    self.present(self.imagePicker, animated: true, completion: nil)
                case .denied:
                    print("사용자가 불허")
                default:
                    break
                }
            }
        }
    }
    
    private func rePermission() {
        let alertController = UIAlertController (title: "카메라 권한 설정", message: "세팅 하시겠습니까?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "세팅", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl){ success in
                    print("Settings opened: \(success)") // Prints true
                }
            }
            
        }
        
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Save Image API
    func saveImage(imageName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        return nil
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage: UIImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            saveImage(imageName: myPageVC.myImage, image: editedImage)
            self.profileImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
            
        } else if let originalImage: UIImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.profileImageView.image = selectedImage!
            //uploadImage(selectedImage)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Network
    private func uploadImage(_ selecteImage: UIImage?) {
        
        guard let url = UserAPI.sharedInstance.getURL("/user/photo") else {return}
        
        guard let sendImage = selecteImage else {
            return
        }
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else {
            return
        }
    
        let _ = generateBoundaryString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(key, forHTTPHeaderField: "Authorization")
    
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.profileImageView.image = sendImage
            }
            print(data.description)
        }
    }
    
    
    private func getData() {
        guard let url = UserAPI.sharedInstance.getURL("/user") else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else {
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
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

}

