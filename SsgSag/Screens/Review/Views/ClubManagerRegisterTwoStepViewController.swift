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

        let nib = UINib(nibName: "RegisterPhotoCollectionViewCell", bundle: nil)
        photoCollectionView.register(nib, forCellWithReuseIdentifier: "RegisterPhotoCell")
        
        bindInput(viewModel: viewModel)
        bindOutput(viewModel: viewModel)
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
            .subscribe(onNext: { text in
                self.introduceLabel.isHidden = text.count == 0 ? false : true
            })
            .disposed(by: disposeBag)
        
        viewModel.photoURLObservable.bind(to: photoCollectionView.rx.items(cellIdentifier: "RegisterPhotoCell")) { (indexPath, cellViewModel, cell) in
            guard let cell = cell as? RegisterPhotoCollectionViewCell else {return}
            
            cell.viewModel = viewModel
            cell.setImg(index: indexPath)
            
        }
        .disposed(by: disposeBag)
        
        viewModel.photoURLObservable
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

    
    @IBAction func uploadClick(_ sender: Any) {
        if viewModel.isMaxPhoto() {
            self.simplerAlert(title: "최대 갯수를 초과하였습니다.")
            return
        }
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func nextClick(_ sender: Any) {
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
            var tempImgArray = viewModel.photoURLObservable.value
            guard let imgData = originImage.jpegData(compressionQuality: 1.0) else { return }
            tempImgArray.append(imgData)
            viewModel.photoURLObservable.accept(tempImgArray)
        }
        self.dismiss(animated: true)
    }
}

