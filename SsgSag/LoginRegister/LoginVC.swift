//
//  LoginVC.swift
//  SsgSag
//
//  Created by admin on 25/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        loginButton.addTarget(self, action: #selector(moveToSwipeVC), for: UIControl.Event.touchUpInside)
        
        view.addSubview(passwordTextField)
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true

        view.addSubview(loginTextField)
        loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -15).isActive = true
        loginTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loginTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true

        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant:15).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(ssgSagImage)
        ssgSagImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ssgSagImage.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -50).isActive = true
        ssgSagImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        ssgSagImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    @objc func moveToSwipeVC() {
        let storyboard = UIStoryboard(name: "Tinder", bundle: nil)
        let swipeVC = storyboard.instantiateViewController(withIdentifier: "Tinder")
        present(swipeVC, animated: true, completion: nil)
    }
    
    let loginTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "아이디"
        text.layer.borderColor = UIColor.blue.cgColor
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 5
        text.layer.masksToBounds = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "비밀번호"
        text.layer.borderColor = UIColor.blue.cgColor
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 5
        text.layer.masksToBounds = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("로그인", for: UIControl.State.normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let ssgSagImage: UIView = {
        let imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
}
