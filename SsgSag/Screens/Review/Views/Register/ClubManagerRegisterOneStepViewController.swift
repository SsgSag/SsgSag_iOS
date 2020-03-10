//
//  ClubManagerRegisterOneStepViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SearchTextField

class ClubManagerRegisterOneStepViewController: UIViewController {

    @IBOutlet weak var univOrLocationLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var oneLineTextField: UITextField!
    @IBOutlet weak var univOrLocationImg: UIImageView!
    @IBOutlet weak var univOrLocationButton: UIButton!
    @IBOutlet weak var univOrLocationTextField: SearchTextField!
    @IBOutlet weak var clubNameTextField: UITextField!
    
    var viewModel: ClubRegisterOneStepViewModel!
    var model: ClubRegisterModel!
    let disposeBag = DisposeBag()
    let textLengthMaximum = 20
    var jsonResult: [[String: Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput(viewModel: viewModel, type: model.clubType)
        bindOutput(viewModel: viewModel)
        scrollView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        scrollView.addGestureRecognizer(tapGesture)
        clubTypeSetting(clubType: model.clubType)
        oneLineTextField.delegate = self
        let nib = UINib(nibName: "RegisterCategoryCollectionViewCell", bundle: nil)
        categoryCollectionView.register(nib, forCellWithReuseIdentifier: "RegisterCategoryCell")
        categoryCollectionView.delegate = self
        nextButton.deviceSetSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryTextField.text = viewModel.categoryObservable.value.last
    }
    
    private func configureSimpleLocalUnivSearchTextField() {
        univOrLocationTextField.startVisible = true
        let universities = localUniversities()
        univOrLocationTextField.filterStrings(universities)
        univOrLocationTextField.itemSelectionHandler = { item, itemPosition in
            self.univOrLocationTextField.text = item[itemPosition].title
        }
    }
    
    private func localUniversities() -> [String] {
        guard let path = Bundle.main.path(forResource: "majorListByUniv",
                                          ofType: "json") else {
            return []
        }
        
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path),
                                    options: .dataReadingMapped)
            
            guard let jsonResult
                = try JSONSerialization.jsonObject(with: jsonData,
                                                   options: .allowFragments)
                    as? [[String: Any]] else {
                        return []
            }
            
            self.jsonResult = jsonResult
            
            var resultUnivNames: [String] = []
            
            jsonResult.forEach {
                let univName = "\($0["학교명"]!)"
                if !resultUnivNames.contains(univName) {
                    resultUnivNames.append(univName)
                }
            }
            
            return resultUnivNames
        } catch {
            print("Error parsing jSON: \(error)")
            return []
        }
    }
    
    func bindInput(viewModel: ClubRegisterOneStepViewModel, type: ClubType) {
        clubNameTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.clubNameObservable)
            .disposed(by: disposeBag)
        
        if type == .School {
            univOrLocationTextField
                .rx
                .text
                .orEmpty
                .bind(to: viewModel.univOrLocationObservable)
                .disposed(by: disposeBag)
        }
        
        oneLineTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.oneLineObservable)
            .disposed(by: disposeBag)
        
    }
    
    func bindOutput(viewModel: ClubRegisterOneStepViewModel) {
        
        viewModel.univOrLocationObservable
            .subscribe(onNext: { [weak self] text in
                self?.univOrLocationTextField.text = text
            })
            .disposed(by: disposeBag)
        
        viewModel.nextButtonEnableObservable
            .subscribe(onNext: { [weak self] isEnable in
                self?.nextButton.backgroundColor = isEnable ? .cornFlower : .unselectedGray
                self?.nextButton.isEnabled = isEnable
            })
            .disposed(by: disposeBag)
        
        viewModel.categoryObservable.bind(to: categoryCollectionView.rx.items(cellIdentifier: "RegisterCategoryCell")) { (indexPath, cellViewModel, cell) in
            guard let cell = cell as? RegisterCategoryCollectionViewCell else {return}
        
            cell.viewModel = viewModel
            cell.setTitle(index: indexPath)
            
        }
        .disposed(by: disposeBag)
        
    }
    
    func clubTypeSetting(clubType: ClubType) {
        if clubType == .School {
            univOrLocationLabel.text = "소속 학교"
            configureSimpleLocalUnivSearchTextField()
        } else {
            univOrLocationLabel.text = "활동 지역"
            univOrLocationImg.isHidden = false
            univOrLocationTextField.isEnabled = false
            univOrLocationButton.isHidden = false
        }
    }
    
    @objc func tapHideKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let curString = textField.text else { return false }
        guard let stringRange = Range(range, in: curString) else { return false }
        
        let updateText = curString.replacingCharacters(in: stringRange, with: string)
        return updateText.count < textLengthMaximum
    }
    
    func modelInsertData(model: ClubRegisterModel, viewModel: ClubRegisterOneStepViewModel) {
        model.clubName = viewModel.clubNameObservable.value
        model.univOrLocation = viewModel.univOrLocationObservable.value
        model.oneLine = viewModel.oneLineObservable.value
        model.category = viewModel.categoryObservable.value
    }
    
    @IBAction func selectOptionClick(_ sender: UIButton) {
        let type: InputType = sender.tag == 0 ? .location : .category
        
        if type == .category {
            guard !viewModel.isMaxCategory() else {
                self.simplerAlert(title: "3개를 초과하였습니다.")
                return
            }
        }
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubRegisterAlertVC") as? ClubRegisterAlertViewController else {return}
        nextVC.viewModel = viewModel
        nextVC.type = type
        
        self.present(nextVC, animated: true)
    }
    
    @IBAction func nextStepClick(_ sender: Any) {
        
        // 자동완성 목록에 없는학교 거르기
        if model.clubType == .School {
            guard let school = univOrLocationTextField.text else {return}
            
            let universities = localUniversities()
            if !universities.contains(school) {
                self.simpleAlert(title: "학교명을 정확히 입력해주세요.", message: "목록에 없는 학교이름 입니다.\n자신의 학교가 없는 경우 문의주세요.")
                return
            }
        }
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubManagerRegisterTwoStepVC") as? ClubManagerRegisterTwoStepViewController else {return}
        modelInsertData(model: model, viewModel: viewModel)
        nextVC.model = model
        nextVC.viewModel = ClubRegisterTwoStepViewModel()
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ClubManagerRegisterOneStepViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = viewModel.categoryObservable.value[indexPath.row]
        var width = title.estimatedFrame(font: UIFont.fontWithName(type: .regular, size: 12)).width
        
        // 좌마진 12, 버튼크기 18, 우마진 8, 여유 8
        width += 12 + 18 + 8 + 8
        
        return CGSize(width: width, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

extension ClubManagerRegisterOneStepViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
extension ClubManagerRegisterOneStepViewController: UITextFieldDelegate {}
