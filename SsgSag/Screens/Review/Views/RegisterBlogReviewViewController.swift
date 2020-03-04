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
    
    var clubIdx: Int!
    var service: ReviewServiceProtocol!
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
        guard let blogUrl = blogTextField.text else { return }
        service.requestBlogReviewPost(clubIdx: clubIdx, blogUrl: blogUrl) { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as? CompleteViewController else {return}
                    nextVC.titleText = "제출이\n완료되었습니다 :)"
                    nextVC.subText = "승인여부는 3일 내 이메일로 알려드릴게요."
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.simpleAlert(title: "다시 시도해주세요", message: "네이버 블로그이고\n한 게시물만 있는 주소인지 확인해주세요")
                }
            }
        }
        
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
