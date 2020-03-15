//
//  ClubManagerRegisterTwoStepViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/10.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ClubManagerRegisterTwoStepViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var collectionHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var webSiteTextField: UITextField!
    @IBOutlet weak var feeTextField: UITextField!
    @IBOutlet weak var meetingTextField: UITextField!
    @IBOutlet weak var activeMemberTextField: UITextField!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var model: ClubRegisterModel!
    var viewModel: ClubRegisterTwoStepViewModel!
    let disposeBag = DisposeBag()
    let service = ClubService()
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        let nib = UINib(nibName: "RegisterPhotoCollectionViewCell", bundle: nil)
        photoCollectionView.register(nib, forCellWithReuseIdentifier: "RegisterPhotoCell")
        
        bindInput(viewModel: viewModel)
        bindOutput(viewModel: viewModel)
        nextButton.deviceSetSize()
    }
    
    @objc func tapHideKeyBoard() {
        self.view.endEditing(true)
    }
    
    func bindInput(viewModel: ClubRegisterTwoStepViewModel) {
        activeMemberTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.activeMemberObservable)
            .disposed(by: disposeBag)
            
        meetingTextField
        .rx
        .text
        .orEmpty
        .bind(to: viewModel.meetingTimeObservable)
        .disposed(by: disposeBag)
        
        feeTextField
        .rx
        .text
        .orEmpty
        .bind(to: viewModel.feeObservable)
        .disposed(by: disposeBag)
        
        webSiteTextField
        .rx
        .text
        .orEmpty
        .bind(to: viewModel.clubSiteObservable)
        .disposed(by: disposeBag)
        
        introduceTextView
        .rx
        .text
        .orEmpty
        .bind(to: viewModel.introduceObservable)
        .disposed(by: disposeBag)
        
    }
    
    func bindOutput(viewModel: ClubRegisterTwoStepViewModel) {
        
        viewModel.introduceObservable
            .subscribe(onNext: { [weak self] text in
                self?.introduceLabel.isHidden = text.count == 0 ? false : true
            })
            .disposed(by: disposeBag)
        
        viewModel.photoDataObservable.bind(to: photoCollectionView.rx.items(cellIdentifier: "RegisterPhotoCell")) { (indexPath, cellViewModel, cell) in
            guard let cell = cell as? RegisterPhotoCollectionViewCell else {return}
            
            cell.viewModel = viewModel
            cell.setImg(index: indexPath)
            
        }
        .disposed(by: disposeBag)
        
        viewModel.photoDataObservable
            .subscribe(onNext: { [weak self] imgDataSet in
                self?.collectionHeightLayout.constant = CGFloat.greatestFiniteMagnitude
                self?.view.layoutIfNeeded()
                self?.collectionHeightLayout.constant = self?.photoCollectionView.contentSize.height ?? 0
            })
            .disposed(by: disposeBag)
        
        viewModel.nextButtonEnableObservable
            .asDriver()
            .drive(onNext: { [weak self] isEnable in
                self?.nextButton.backgroundColor = isEnable ? .cornFlower : .unselectedGray
                self?.nextButton.isEnabled = isEnable
            })
            .disposed(by: disposeBag)

    }
    
    func modelInsertData(model: ClubRegisterModel, viewModel: ClubRegisterTwoStepViewModel) {
        model.activeMember = viewModel.activeMemberObservable.value
        model.meetTime = viewModel.meetingTimeObservable.value
        model.fee = viewModel.feeObservable.value
        model.webSite = viewModel.clubSiteObservable.value
        model.introduce = viewModel.introduceObservable.value
        model.photoUrlList = viewModel.photoURLObservable.value
    }

    
    @IBAction func uploadClick(_ sender: Any) {
        if viewModel.isMaxPhoto() {
            self.simplerAlert(title: "최대 갯수를 초과하였습니다.")
            return
        }
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func nextClick(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubManagerRegisterThreeStepVC") as? ClubManagerRegisterThreeStepViewController else {return}
        modelInsertData(model: model, viewModel: viewModel)
        nextVC.viewModel = ClubRegisterThreeStepViewModel()
        nextVC.model = model
        nextVC.service = ClubService()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ClubManagerRegisterTwoStepViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originImage: UIImage = info[.editedImage] as? UIImage {
            var tempImgArray = viewModel.photoDataObservable.value
            var tempUrlArray = viewModel.photoURLObservable.value
            guard let imgData = originImage.pngData() else { return }
            service.requestPhotoURL(imageData: imgData) { imgURL in
                if let imgURL = imgURL {
                    tempImgArray.append(imgData)
                    self.viewModel.photoDataObservable.accept(tempImgArray)
                    tempUrlArray.append(imgURL)
                    self.viewModel.photoURLObservable.accept(tempUrlArray)
                   
                } else {
                    self.simpleAlert(title: "이미지 업로드중 오류가 발생했습니다.", message: "다시 시도해주세요")
                }
            }
            self.dismiss(animated: true)
        }
    }
}

extension ClubManagerRegisterTwoStepViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
