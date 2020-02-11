//
//  NoClubManagerViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class NoClubManagerViewController: UIViewController {
    var service: ClubServiceProtocol!

    @IBOutlet weak var adminPhoneTextField: UITextField!
    @IBOutlet weak var adminNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func completeClick(_ sender: Any) {
        guard let name = adminNameTextField.text else {return}
        guard let phone = adminPhoneTextField.text else {return}
        service.requestNotMemberClubRegister(admin: 0, name: name, phone: phone) { isSuccess in
            isSuccess ? self.dismiss(animated: true) : self.simplerAlert(title: "전송중 오류가 발생하였습니다.")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
