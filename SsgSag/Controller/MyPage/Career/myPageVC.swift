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
    
    private var userInfo: UserInfoModel?
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        profileImageView.applyRadius(radius: profileImageView.frame.height / 2)
    }
    
    private func setupTableView() {
        let myPageMenuNib = UINib(nibName: "myPageMenuTableViewCell", bundle: nil)
        
        myPageTableView.register(myPageMenuNib, forCellReuseIdentifier: "menuTableViewCell")
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func touchUpSettingButton(_ sender: UIButton) {
        let accountSettingVC = AccountSettingViewController()
        accountSettingVC.userData = userInfo
        accountSettingVC.nickName = userInfo?.userNickname
        accountSettingVC.univ = userInfo?.userUniv
        accountSettingVC.major = userInfo?.userMajor
        accountSettingVC.studentNumber = userInfo?.userStudentNum
        accountSettingVC.selectedImage = profileImageView.image
        accountSettingVC.delegate = self
        
        let accountSettingNavigator = UINavigationController(rootViewController: accountSettingVC)
        accountSettingNavigator.modalPresentationStyle = .fullScreen
        present(accountSettingNavigator, animated: true)
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
                
                self?.userInfo = apiResponse.data
                
                DispatchQueue.main.async {
                    self?.nameLabel.text = apiResponse.data?.userName
                    self?.idLabel.text = apiResponse.data?.userNickname
                    self?.majorLabel.text = apiResponse.data?.userMajor
                    self?.schoolLabel.text = apiResponse.data?.userUniv
                    self?.requestImage()
                    self?.view.layoutIfNeeded()
                }
                
            } catch (let err) {
                print(err.localizedDescription)
            }
        }
    }
    
    private func requestImage() {
        guard let urlString = userInfo?.userProfileUrl,
            let url = URL(string: urlString) else {
            return
        }
        
        do {
            let imageData = try Data(contentsOf: url)
            
            profileImageView.image = UIImage(data: imageData, scale: 0.5)
        } catch let error {
            print(error)
            return
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
        let storyboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        switch indexPath.row {
        case 0:
            // 나의 이력
            let careerVC = storyboard.instantiateViewController(withIdentifier: "careerVC")
            navigationController?.pushViewController(careerVC, animated: true)
        case 1:
            // 알림 설정
            let pushAlarmVC = storyboard.instantiateViewController(withIdentifier: "pushAlarmVC")
            navigationController?.pushViewController(pushAlarmVC, animated: true)
        case 2:
            // 공지사항
            let noticeVC = storyboard.instantiateViewController(withIdentifier: "noticeVC")
            navigationController?.pushViewController(noticeVC, animated: true)
        case 3:
            // 문의하기
            let inquireVC = storyboard.instantiateViewController(withIdentifier: "inquireVC")
            
            navigationController?.pushViewController(inquireVC, animated: true)
        default:
            return
        }
    }
}

extension myPageVC: UpdateDataDelegate {
    func reloadUserData() {
        getData()
    }
}
