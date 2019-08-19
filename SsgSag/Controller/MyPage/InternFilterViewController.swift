//
//  InternFilterViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 13/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    func completeFilterSetting(_ categoryName: String)
}

class InternFilterViewController: UIViewController {

    weak var delegate: FilterDelegate?
    
    private let mypageService: MyPageService
        = DependencyContainer.shared.getDependency(key: .myPageService)
    
    private var selectedInterest: [Int] = []
    private var selectedJobNumber = 0
    private var selectedCompanyNumber = 0
    var categoryName: String?
    
    @IBOutlet weak var jobAllButton: UIButton!
    
    @IBOutlet weak var companyAllButton: UIButton!
    
    @IBOutlet weak var jobCategoryStackView: UIStackView!
    
    @IBOutlet weak var companyKindCategoryStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestInterest()
    }
    
    private func requestInterest() {
        mypageService.requestSelectedState { [weak self] result in
            switch result {
            case .success(let interest):
                DispatchQueue.main.async {
                    self?.setupInterestButton(interest: interest.data?.interests)
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
    private func setupInterestButton(interest: [Int]?) {
        guard let interest = interest else {
            return
        }
        
        interest.forEach {
            if let button = jobCategoryStackView?.viewWithTag($0) as? UIButton {
                button.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                button.isSelected = !button.isSelected
                selectedInterest.append($0)
                selectedJobNumber += 1
            }
            
            if let button = companyKindCategoryStackView.viewWithTag($0) as? UIButton {
                button.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                button.isSelected = !button.isSelected
                selectedInterest.append($0)
                selectedCompanyNumber += 1
            }
        }
        
        if selectedJobNumber == 14 {
            jobAllButton.setImage(UIImage(named: "ic_selectAll"),
                                  for: .normal)
            jobAllButton.setTitleColor(#colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1), for: .normal)
            
            jobAllButton.isSelected = true
        }
        
        if selectedCompanyNumber == 6 {
            companyAllButton.setImage(UIImage(named: "ic_selectAll"),
                                      for: .normal)
            companyAllButton.setTitleColor(#colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1), for: .normal)
            
            companyAllButton.isSelected = true
        }
        
    }

    @IBAction func touchUpCancelButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func touchUpCompleteButton(_ sender: Any) {
        mypageService.requestStoreSelectedField(selectedInterest) { [weak self] result in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    switch status {
                    case .sucess:
                        self?.delegate?.completeFilterSetting(self?.categoryName ?? "")
                        self?.dismiss(animated: false)
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
    
    @IBAction func touchUpAllSelectButton(_ sender: UIButton) {
        
        if sender.isSelected {
            return
        }
        
        sender.setImage(UIImage(named: "ic_selectAll"), for: .normal)
        sender.setTitleColor(#colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1), for: .normal)
        
        let stackView = sender.tag == 1 ? jobCategoryStackView : companyKindCategoryStackView
        
        let startNumberOfTag = sender.tag == 1 ? 101 : 10000
        let numberOfTag = sender.tag == 1 ? 114 : 60000
        let by = sender.tag == 1 ? 1 : 10000
        
        for tag in stride(from: startNumberOfTag, through: numberOfTag, by: by) {
            guard let button = stackView?.viewWithTag(tag) as? UIButton else {
                return
            }
            
            
            button.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            stackView == jobCategoryStackView ? (selectedJobNumber += 1) : (selectedCompanyNumber += 1)
            
            if !selectedInterest.contains(tag) {
                selectedInterest.append(tag)
            }
            
            button.isSelected = !button.isSelected
        }
        
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func touchUpFilterButton(_ sender: UIButton) {
        
        if sender.isSelected {
            if selectedJobNumber == 1 || selectedCompanyNumber == 1 {
                return
            }
            
            sender.tag < 10000 ? (selectedJobNumber -= 1) : (selectedCompanyNumber -= 1)
            
            sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            sender.setTitleColor(#colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1), for: .normal)
            
            var index = 0
            
            selectedInterest.forEach {
                if $0 == sender.tag {
                    selectedInterest.remove(at: index)
                    return
                }
                
                index += 1
            }
        } else {
            sender.tag < 10000 ? (selectedJobNumber += 1) : (selectedCompanyNumber += 1)
            
            sender.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
            sender.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            if !selectedInterest.contains(sender.tag) {
                selectedInterest.append(sender.tag)
            }
        }
        
        sender.isSelected = !sender.isSelected
        
        if selectedJobNumber == 14 {
            jobAllButton.setImage(UIImage(named: "ic_selectAll"), for: .normal)
            jobAllButton.setTitleColor(#colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1), for: .normal)
            
            jobAllButton.isSelected = true
        } else {
            jobAllButton.setImage(UIImage(named: "ic_selectAllPassive"), for: .normal)
            jobAllButton.setTitleColor(#colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1), for: .normal)
            
            jobAllButton.isSelected = false
        }
        
        if selectedCompanyNumber == 6 {
            companyAllButton.setImage(UIImage(named: "ic_selectAll"), for: .normal)
            companyAllButton.setTitleColor(#colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1), for: .normal)
            
            companyAllButton.isSelected = true
        } else {
            companyAllButton.setImage(UIImage(named: "ic_selectAllPassive"), for: .normal)
            companyAllButton.setTitleColor(#colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1), for: .normal)
            
            companyAllButton.isSelected = false
        }
        
    }
}
