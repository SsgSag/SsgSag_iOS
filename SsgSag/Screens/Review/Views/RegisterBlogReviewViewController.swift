//
//  RegisterBlogReviewViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/13.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterBlogReviewViewController: UIViewController {

    @IBOutlet weak var blogTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.deviceSetSize()
        bind()
        //블로그 등록 통신코드

    }
    
    func bind() {
        blogTextField
        .rx
        .text
        .orEmpty
        .map{ $0.isEmpty }
        .subscribe(onNext: { [weak self] isEmpty in
            self?.submitButton.isEnabled = !isEmpty
            self?.submitButton.backgroundColor = isEmpty ? .unselectedGray : .cornFlower
        })
        .disposed(by: disposeBag)
        
    }
    
    @IBAction func sumbitClick(_ sender: Any) {
        //통신 성공시
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as? CompleteViewController else {return}
        nextVC.titleText = "제출이\n완료되었습니다 :)"
        nextVC.subText = "승인여부는 3일 내 이메일로 알려드릴게요."
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
