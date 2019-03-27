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
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("사진첩 접근 허가")
            self.present(self.imagePicker, animated: true, completion: nil)
            
        case .denied:
            print("사진첩 접근 불허 ")
            
        case .notDetermined:
            print("접근 아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization( { (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용")
                    self.present(self.imagePicker, animated: true, completion: nil)
                case .denied:
                    print("사용자가 불허")
                default:
                    print("asdkljaskld")
                }
            })
        case .restricted:
            print("접근 제한")
        default:
            print("dsad")
        }
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage: UIImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            //uploadImage(selectedImage)
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
    
    private func uploadImage(_ selecteImage: UIImage?) {
        
        let urlString = UserAPI.sharedInstance.getURL("/user/photo")
        
        guard let sendImage = selecteImage else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        guard let key = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else {
            return
        }
    
        let _ = generateBoundaryString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(key, forHTTPHeaderField: "Authorization")
        
//        request.httpBody?.append("--\(boundary)\r\n".data(using: .utf8)!)
//        request.httpBody?.append("Content-Disposition: form-data; name=\"\(sendImage)\";".data(using: .utf8)!)
//        request.httpBody?.append(sendImage.pngData()!)
//        request.httpBody?.append("\r\n".data(using: .utf8)!)
        
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
        let urlString = UserAPI.sharedInstance.getURL("/user")
        
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
    
    
//    func createRequest(userid: String, password: String, email: String) throws -> URLRequest {
//        let parameters = [
//            "user_id"  : userid,
//            "email"    : email,
//            "password" : password]  // build your dictionary however appropriate
//
//        let boundary = generateBoundaryString()
//
//        let url = URL(string: "https://example.com/imageupload.php")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
//        request.httpBody = try createBody(with: parameters, filePathKey: "file", paths: [path1], boundary: boundary)
//
//        return request
//    }
//
    /// Create body of the `multipart/form-data` request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The `multipart/form-data` boundary
    ///
    /// - returns:                The `Data` of the body of the request
    
//    private func createBody(with parameters: [String: Data]? , boundary: String) throws -> Data {
//        var body = Data()
//
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.append("--\(boundary)\r\n")
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.append(value)
//            }
//        }
//
//        body.append("--\(boundary)--\r\n")
//        return body
//    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires `import MobileCoreServices`.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns `application/octet-stream` if unable to determine mime type.
    
//    private func mimeType(for path: String) -> String {
//        let url = URL(fileURLWithPath: path)
//        let pathExtension = url.pathExtension
//
//        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
//            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
//                return mimetype as String
//            }
//        }
//        return "application/octet-stream"
//    }

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
//extension Data {
//
//    /// Append string to Data
//    ///
//    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
//    ///
//    /// - parameter string:       The string to be added to the `Data`.
//
//    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
//        if let data = string.data(using: encoding) {
//            append(data)
//        }
//    }
//}
