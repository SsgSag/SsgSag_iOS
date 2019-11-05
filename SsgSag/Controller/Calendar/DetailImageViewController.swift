//
//  DetailImageViewController.swift
//  SsgSag
//
//  Created by 이혜주 on 09/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {

    var urlString: String? {
        didSet {
            guard let urlString = self.urlString else {
                    return
            }
            
            ImageNetworkManager.shared.getImageByCache(imageURL: urlString) { [weak self] image, error in
                guard let image = image,
                    let width = self?.view.frame.width else {
                    return
                }
                
                let resizedImage = self?.imageWithImage(sourceImage: image,
                                                        scaledToWidth: width)
                self?.detailImageView.image = resizedImage
            }
        }
    }
    
    var titleText: String? {
        didSet {
            guard let titleText = self.titleText else {
                return
            }
            titleLabel.text = titleText
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .semibold)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_cancelWhite"),
                        for: .normal)
        button.addTarget(self, action: #selector(touchUpCloseButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        return scrollView
    }()
    
    private let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        view.addSubview(imageScrollView)
        imageScrollView.addSubview(detailImageView)
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        
        imageScrollView.topAnchor.constraint(
            equalTo: view.topAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
        
        detailImageView.topAnchor.constraint(
            equalTo: imageScrollView.topAnchor).isActive = true
        detailImageView.leadingAnchor.constraint(
            equalTo: imageScrollView.leadingAnchor).isActive = true
        detailImageView.trailingAnchor.constraint(
            equalTo: imageScrollView.trailingAnchor).isActive = true
        detailImageView.bottomAnchor.constraint(
            equalTo: imageScrollView.bottomAnchor).isActive = true
        detailImageView.centerXAnchor.constraint(
            equalTo: imageScrollView.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(
            equalTo: closeButton.leadingAnchor,
            constant: -20).isActive = true
        
        closeButton.widthAnchor.constraint(
            equalToConstant: 48).isActive = true
        closeButton.heightAnchor.constraint(
            equalToConstant: 48).isActive = true
        closeButton.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -15).isActive = true
        closeButton.centerYAnchor.constraint(
            equalTo: titleLabel.centerYAnchor).isActive = true

    }
    
    func imageWithImage(sourceImage: UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @objc private func touchUpCloseButton() {
        dismiss(animated: true)
        print(imageScrollView.frame.size)
        print(detailImageView.frame.size)
        print(detailImageView.image!.size)
    }
}

extension DetailImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailImageView
    }
}

