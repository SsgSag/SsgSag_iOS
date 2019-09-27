//
//  InquireViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import MessageUI

class InquireViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var functionButton: UIButton!
    @IBOutlet weak var designButton: UIButton!
    @IBOutlet weak var promotionButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var outsideStackView: UIStackView!
    @IBOutlet weak var contentsTextViewHeightConstraint: NSLayoutConstraint!
    
    private var kind: InquireKind = .feedBack
    
    var callback: (()->())?
    
    private lazy var backbutton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationItem.leftBarButtonItem = backbutton
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentsTextView.textContainer.lineFragmentPadding = 3
        contentsTextView.textContainerInset = UIEdgeInsets(top: 10,
                                                       left: 12,
                                                       bottom: 10,
                                                       right: 12)
    }
    
    private func setupTextViewPlaceHolder() {
        if contentsTextView.text == "슥삭을 사용하면서 불편했던 점을 말씀해주세요!" {
            contentsTextView.text = ""
            contentsTextView.textColor = #colorLiteral(red: 0.2924695313, green: 0.2924772203, blue: 0.2924730778, alpha: 1)
        } else {
            contentsTextView.text = "슥삭을 사용하면서 불편했던 점을 말씀해주세요!"
            contentsTextView.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        }
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectedInquireKind(_ sender: UIButton) {
        for tag in 1...6 {
            if sender.tag == tag {
                sender.setTitleColor(.white, for: .normal)
                sender.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
                
                switch sender.tag {
                case 1:
                    kind = .feedBack
                case 2:
                    kind = .error
                case 3:
                    kind = .function
                case 4:
                    kind = .design
                case 5:
                    kind = .promotion
                case 6:
                    kind = .etc
                default:
                    break
                }
            } else {
                guard let button = view.viewWithTag(tag) as? UIButton else {
                    continue
                }
                button.backgroundColor = .white
                button.setTitleColor(#colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 1), for: .normal)
            }
        }
    }
    
    @IBAction func touchUpSendButton(_ sender: Any) {
        if contentsTextView.text == "슥삭을 사용하면서 불편했던 점을 말씀해주세요!" || contentsTextView.text == "" {
            simplerAlert(title: "내용을 입력해주세요")
            return
        }
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ssgsag.univ@gmail.com"])
            mail.setMessageBody(contentsTextView.text, isHTML: true)
            
            switch kind {
            case .feedBack:
                mail.setSubject("문의: 피드백")
            case .error:
                mail.setSubject("문의: 오류")
            case .function:
                mail.setSubject("문의: 기능추가")
            case .design:
                mail.setSubject("문의: 디자인개선")
            case .promotion:
                mail.setSubject("문의: 홍보문의")
            case .etc:
                mail.setSubject("문의: 기타")
            }

            mail.modalPresentationStyle = .fullScreen
            present(mail, animated: true)
        } else {
            simpleAlert(title: "메일 전송 실패",
                        message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.")
        }
    }

}

extension InquireViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: outsideStackView.subviews[1].frame.origin.y),
                                    animated: true)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let height = self?.view.frame.height else {
                return
            }
            
            self?.contentsTextViewHeightConstraint.constant = height * 0.25
        }
        setupTextViewPlaceHolder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.scrollView.contentOffset.y = 0
            self?.contentsTextViewHeightConstraint.constant = 333
        }
        
        if textView.text == "" {
            setupTextViewPlaceHolder()
        }
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

extension InquireViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        contentsTextView.resignFirstResponder()
        return true
    }
}

extension InquireViewController: MFMailComposeViewControllerDelegate {
    @objc(mailComposeController:didFinishWithResult:error:)
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        switch result {
        case .cancelled:
            controller.dismiss(animated: true)
        case .sent:
            controller.simpleAlertwithOKButton(title: "메일 전송 완료",
                                               message: "여러분의 소중한 의견 감사드립니다.\n - 슥삭 -") { [weak self] _ in
                controller.presentingViewController?.dismiss(animated: true)
                self?.navigationController?.popViewController(animated: true)
            }
        case .failed:
            controller.simplerAlert(title: "메일 전송 실패")
        default:
            controller.dismiss(animated: true)
        }
    }
}

enum InquireKind {
    case feedBack
    case error
    case function
    case design
    case promotion
    case etc
}
