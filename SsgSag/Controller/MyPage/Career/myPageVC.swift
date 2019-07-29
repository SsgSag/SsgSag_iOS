//
//  myPageVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import Photos
import SwiftKeychainWrapper

class myPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var schoolLabel: UILabel!

    @IBOutlet weak var majorLabel: UILabel!
    
    @IBOutlet weak var myPageTableView: UITableView!
    
    static private let myImage: String = "myImage"
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        setupTableView()

        profileImageView.applyRadius(radius: profileImageView.frame.height / 2)
    }
    
    private func setupTableView() {
        let myPageMenuNib = UINib(nibName: "myPageMenuTableViewCell", bundle: nil)
        
        myPageTableView.register(myPageMenuNib, forCellReuseIdentifier: "menuTableViewCell")
    }
    
    private func loadImage() {
        if let loadedImage = loadImageFromDiskWith(fileName: myPageVC.myImage) {
            profileImageView.image = loadedImage
        }
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func touchUpSettingButton(_ sender: UIButton) {
        present(UINavigationController(rootViewController: AccountSettingViewController()), animated: true)
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
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage: UIImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            saveImage(imageName: myPageVC.myImage, image: editedImage)
            self.profileImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
            
        } else if let originalImage: UIImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.profileImageView.image = selectedImage!
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        uploadImage(selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Network
    private func uploadImage(_ selecteImage: UIImage?) {
        
        guard let url = UserAPI.sharedInstance.getURL("/user/photo") else {return}
        
        guard let sendImage = selecteImage else { return }
        
        guard let sendData = sendImage.jpegData(compressionQuality: 1) else {return}
        
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else { return }
    
        let boundary = generateBoundaryString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = createBody(parameters: [:],
                                      boundary: boundary,
                                      data: sendData,
                                      mimeType: "image/jpeg",
                                      filename: "profile")
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            
            guard let data = data else {
                return
            }
            
            do {
                let status = try JSONDecoder().decode(BasicNetworkModel.self, from: data)
                
                //500번 서버 내부 에러 발생 하고 있음
                print("Message!! \(status.message)")
                
            } catch {
                print("upload data parsing error")
            }
        }
    }
    
    
    private func getData() {
        guard let url = UserAPI.sharedInstance.getURL("/user") else {return}
        
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { [weak self] (data, error, res) in
            if error != nil {
                print(error.debugDescription)
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(UserNetworkModel.self, from: data)
                
                DispatchQueue.main.async {
                    self?.nameLabel.text = apiResponse.data?.userName
                    self?.idLabel.text = apiResponse.data?.userNickname
                    self?.majorLabel.text = apiResponse.data?.userMajor
                    self?.schoolLabel.text = apiResponse.data?.userUniv
                }
                
            } catch (let err) {
                print(err.localizedDescription)
            }
        }
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func createBody(parameters: [String: String],
                            boundary: String,
                            data: Data,
                            mimeType: String,
                            filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}

extension myPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension myPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell
            = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell",
                                            for: indexPath) as? myPageMenuTableViewCell else {
            return .init()
        }
        
        cell.configure(row: indexPath.row)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // 나의 이력
            return
        case 1:
            // 게시판 설정
            return
        case 2:
            // 공지사항
            let storyboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
            let noticeNavigationVC = storyboard.instantiateViewController(withIdentifier: "noticeNavigationVC")
            present(noticeNavigationVC, animated: true)
        case 3:
            // 문의하기
            return
        default:
            return
        }
    }
}
