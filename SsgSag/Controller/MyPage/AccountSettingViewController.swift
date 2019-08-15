//
//  AccountSettingViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import Photos

protocol UpdateDataDelegate: class {
    func reloadUserData()
}

class AccountSettingViewController: UIViewController {

    weak var delegate: UpdateDataDelegate?
    
    let settingTitles = ["닉네임",
                         "아이디(이메일)",
                         "비밀번호",
                         "학교",
                         "학과",
                         "학년",
                         "입학년도"]
    
    var selectedImage: UIImage?
    var userData: UserInfoModel?
    var currentTextField: UITextField?
    
    var nickName: String?
    var univ: String?
    var major: String?
    var studentNumber: String?
    var grade: Int?
    
    private let mypageService: MyPageService
        = DependencyContainer.shared.getDependency(key: .myPageService)
    
    private lazy var profileImagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    private lazy var settingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    private lazy var completeButton = UIBarButtonItem(title: "완료",
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(touchUpCompleteButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationItem.title = "계정설정"
        completeButton.tintColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = completeButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupCollectionView()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(settingCollectionView)
        
        settingCollectionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        settingCollectionView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        settingCollectionView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        settingCollectionView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
    }

    private func setupCollectionView() {
        
        // header
        let settingImageNib = UINib(nibName: "SettingProfileImageCollectionReusableView",
                                    bundle: nil)
        
        settingCollectionView.register(settingImageNib,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: "settingImageHeaderID")
        
        settingCollectionView.register(TempCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: "tempHeaderID")
        
        // Footer
        settingCollectionView.register(TempCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: "tempFooterID")
        
        // cell
        let settingTextFieldNib = UINib(nibName: "SettingTextFieldCollectionViewCell",
                                        bundle: nil)
        
        settingCollectionView.register(settingTextFieldNib,
                                       forCellWithReuseIdentifier: "settingTextFieldCellID")
        
        let menuNib = UINib(nibName: "SettingMenuCollectionViewCell",
                            bundle: nil)
        
        settingCollectionView.register(menuNib,
                                       forCellWithReuseIdentifier: "menuCellID")
        
    }
    
    private func uploadImage(_ selecteImage: UIImage?) {
        
        guard let sendImage = selecteImage else { return }
        
        guard let sendData = sendImage.jpegData(compressionQuality: 0.7) else {return}
        
        let boundary = generateBoundaryString()
        
        let bodyData = createBody(parameters: [:],
                                      boundary: boundary,
                                      data: sendData,
                                      mimeType: "image/jpg",
                                      filename: "profileImage.jpg")
        
        mypageService.requestUpdateProfile(boundary: boundary,
                                           bodyData: bodyData) { [weak self] result in
                                            switch result {
                                            case .success(let status):
                                                DispatchQueue.main.async {
                                                    switch status {
                                                    case .processingSuccess:
                                                        self?.delegate?.reloadUserData()
                                                        self?.dismiss(animated: true)
                                                    case .requestError:
                                                        self?.simplerAlert(title: "사진 등록에 실패했습니다.")
                                                        return
                                                    case .dataBaseError:
                                                        self?.simplerAlert(title: "database error")
                                                        return
                                                    case .serverError:
                                                        self?.simplerAlert(title: "server error")
                                                        return
                                                    default:
                                                        return
                                                    }
                                                }
                                            case .failed(let error):
                                                print(error)
                                                return
                                            }
        }
        
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createBody(parameters: [String: String],
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
        body.appendString("Content-Disposition: form-data; name=\"profile\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    private func rePermission() {
        let alertController = UIAlertController (title: "카메라 권한 설정",
                                                 message: "세팅 하시겠습니까?",
                                                 preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "세팅",
                                           style: .default) { (_) -> Void in
            
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
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .default,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func touchUpBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func touchUpCompleteButton() {
        currentTextField?.resignFirstResponder()
        
        guard checkInformation() else {
            return
        }
        
        let bodyData: [String: Any] = ["userNickname" : nickName ?? (userData?.userNickname ?? ""),
                                       "userUniv" : univ ?? (userData?.userUniv ?? ""),
                                       "userMajor" : major ?? (userData?.userMajor ?? ""),
                                       "userStudentNum" : studentNumber ?? (userData?.userStudentNum ?? ""),
                                       "userGrade" : grade ?? (userData?.userGrade ?? 1)]
        
        mypageService.requestUpdateUserInfo(bodyData: bodyData) { [weak self] result in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    switch status {
                    case .processingSuccess:
                        self?.uploadImage(self?.selectedImage)
                    case .requestError:
                        self?.simplerAlert(title: "학교와 학과의 형식이 일치하지 않습니다.")
                        return
                    case .dataBaseError:
                        self?.simplerAlert(title: "database error")
                        return
                    default:
                        return
                    }
                }
            case .failed(let error):
                print(error)
                return
            }
        }
        
//        guard let header
//            = settingCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader,
//                                                      at: IndexPath(item: 0, section: 0))
//                as? SettingProfileImageCollectionReusableView else {
//            return
//        }
//        
//        uploadImage(header.profileImageView.image)
    }
    
    private func checkInformation() -> Bool {
        guard nickName != ""
            && univ != ""
            && major != ""
            && studentNumber != ""
            && grade != nil else {
                simplerAlert(title: "입력되지 않은 정보가 있습니다.")
                return false
        }
        
        guard isValidateNickName(nickName: nickName) else {
            simplerAlert(title: "닉네임은 1~10자\n영문자, 한글, 숫자 조합을\n사용해주세요")
            return false
        }
        
        guard grade! >= 1 && grade! <= 5 else {
            simplerAlert(title: "학년은 1~5학년 사이로 입력해주세요")
            return false
        }
        return true
    }
    
    private func isValidateNickName(nickName: String?) -> Bool {
        guard nickName != nil else { return false }
        
        let regEx = "^[a-zA-Z가-힣0-9]{1,10}$"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: nickName)
    }
    
    // MARK: - Save Image API
    private func saveImage(imageName: String, image: UIImage) {
        
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
}

extension AccountSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let editedImage: UIImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            saveImage(imageName: "myImage", image: editedImage)
            picker.dismiss(animated: true, completion: nil)
            
        } else if let originalImage: UIImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            picker.dismiss(animated: true, completion: nil)
        }
        
        settingCollectionView.reloadSections([0])
        
        // 이미지 업로드 할것
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AccountSettingViewController: ShowImagePickerDelegate {
    func imagePickerShouldLoad() {
        // TODO: imagePicker 띄울것
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            present(profileImagePicker,
                    animated: true)
        case .denied, .restricted:
            rePermission()
            print("사진첩 접근 불허")
        case .notDetermined:
            print("접근 아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                switch status {
                case .authorized:
                    print("사용자가 허용")
                    self?.present(self!.profileImagePicker,
                                 animated: true)
                case .denied:
                    print("사용자가 불허")
                default:
                    break
                }
            }
        }
    }
}

extension AccountSettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            nickName = textField.text
        case 3:
            univ = textField.text
        case 4:
            major = textField.text
        case 5:
            guard let gradeText = textField.text,
                let gradeNumber = Int(gradeText) else {
                    return
            }
            self.grade = gradeNumber
        case 6:
            studentNumber = textField.text
        default:
            break
        }
    }
}


extension AccountSettingViewController: PasswordDelegate {
    func changePassword() {
        guard userData?.signupType == 10 else {
            simplerAlert(title: "카카오톡 로그인의 경우\n비밀번호 변경이 불가능합니다.")
            return
        }
        
        let storyboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let changePasswordVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC")
    
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
}
