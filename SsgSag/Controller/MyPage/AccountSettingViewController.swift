//
//  AccountSettingViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import Photos

class AccountSettingViewController: UIViewController {

    let settingTitles = ["닉네임",
                         "아이디(이메일)",
                         "비밀번호",
                         "학교",
                         "학과",
                         "학년",
                         "입학년도"]
    
    var selectedImage: UIImage?
    
    var currentTextField: UITextField?
    
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
        print("complete")
    }
}

extension AccountSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let editedImage: UIImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
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
}
