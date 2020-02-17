//
//  ClubEditViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/17.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SearchTextField

class ClubEditViewController: UIViewController {

    @IBOutlet weak var locationCollectionViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var oneLineTextField: UITextField!
    @IBOutlet weak var univOrLocationImg: UIImageView!
    @IBOutlet weak var univOrLocationButton: UIButton!
    @IBOutlet weak var univOrLocationTextField: SearchTextField!
    @IBOutlet weak var clubNameTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    var viewModel: ClubEditViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        completeButton.deviceSetSize()
    }
    
    @IBAction func selectOptionClick(_ sender: UIButton) {
//        let type: InputType = sender.tag == 0 ? .location : .category
//
//        if type == .category {
//            guard !viewModel.isMaxCategory() else {
//                self.simplerAlert(title: "3개를 초과하였습니다.")
//                return
//            }
//        }
//
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClubRegisterAlertVC") as? ClubRegisterAlertViewController else {return}
//        nextVC.viewModel = viewModel
//        nextVC.type = type
//
//        self.present(nextVC, animated: true)
    }

}
