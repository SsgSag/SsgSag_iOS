//
//  NormalReviewCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/29.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NormalReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likeImgTopLayout: NSLayoutConstraint!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activeYearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var advantageLabel: UILabel!
    @IBOutlet weak var disAdvantageLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var honeyLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var honeyTipLabel: UILabel!
    @IBOutlet weak var likeFixLabel: UILabel!
    @IBOutlet weak var advantageHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var disAdvantageHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var honeyHeightLayout: NSLayoutConstraint!
    
    lazy var fullStar = UIImage(named: "star2")
    lazy var halfStar = UIImage(named: "star1")
    lazy var blackStar = UIImage(named: "star0")
    lazy var unSelectImg = UIImage(named: "icHelpful")
    lazy var selectImg = UIImage(named: "icHelpfulActive")
//    var score: Float = -1
    
    let isSelectObservable = BehaviorRelay(value: false)
    let likeNumObservable = BehaviorRelay(value: 0)
    var disposeBag = DisposeBag()
    var service: ReviewServiceProtocol?

    var viewModel: ReviewCellInfo! {
        willSet {
            if newValue.onClick {
                showTipLabel()
            } else {
                hideTipLabel()
            }
        }
    }
    
    override func awakeFromNib() {
        disposeBag = DisposeBag()
    }
    
    func ratePaint(score: Int) {
        var score = score
        let stackStar = self.starStackView.subviews as! [UIImageView]
        
        stackStar.forEach {
            score -= 1
            if score >= 0 {
                $0.image = self.fullStar
            } else if score > -1 {
                $0.image = self.halfStar
            } else {
                $0.image = self.blackStar
            }
        }
    }
    
    func bind(service: ReviewServiceProtocol = ReviewService()) {
        self.service = service
        guard let viewModel = viewModel.data else {return}
        userNameLabel.text = String(viewModel.userIdx)
        let activeDate = viewModel.clubEndDate.split(separator: "-").map{String($0)}
        activeYearLabel.text = activeDate[0]+"년 활동"
        titleLabel.text = viewModel.oneLine
        advantageLabel.text = viewModel.advantage
        disAdvantageLabel.text = viewModel.disadvantage
        honeyTipLabel.text = viewModel.honeyTip
        likeLabel.text = "\(viewModel.likeNum)개"
        scoreLabel.text = "별점 \(viewModel.score0)"
        
        let advantage = viewModel.advantage
        let disadvantage = viewModel.disadvantage
        let font = UIFont.fontWithName(type: .regular, size: 13)
        
        self.layoutIfNeeded()
        advantageHeightLayout.constant = advantage.estimatedFrame(font: font).height
        disAdvantageHeightLayout.constant = disadvantage.estimatedFrame(font: font).height
        
        isSelectObservable
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isSelect in
                if isSelect {
                    self?.likeFixLabel.textColor = .white
                    self?.likeImg.image = self?.selectImg
                    self?.likeLabel.textColor = .white
                    self?.likeView.backgroundColor = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
                    self?.likeView.layer.borderWidth = 0
                } else {
                    self?.likeFixLabel.textColor = #colorLiteral(red: 0.5406702161, green: 0.5406834483, blue: 0.5406762958, alpha: 1)
                    self?.likeImg.image = self?.unSelectImg
                    self?.likeLabel.textColor = #colorLiteral(red: 0.5406702161, green: 0.5406834483, blue: 0.5406762958, alpha: 1)
                    self?.likeView.backgroundColor = .white
                    self?.likeView.layer.borderWidth = 1
                }
            })
        .disposed(by: disposeBag)
        
        likeNumObservable
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] likeNum in
                self?.likeLabel.text = "\(likeNum)개"
            })
            .disposed(by: disposeBag)
        
        let select = viewModel.isLike == 0 ? false : true
        isSelectObservable.accept(select)
        likeNumObservable.accept(viewModel.likeNum)
    }
    
    func hideTipLabel() {
        DispatchQueue.main.async {
            self.moreButton.isHidden = false
            self.honeyLabel.isHidden = true
            self.honeyTipLabel.isHidden = true
            self.layoutIfNeeded()
            self.honeyHeightLayout.constant = 0
            //기본 15
            self.likeImgTopLayout.constant = 15
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resizeTableView"), object: nil)
        }
    }
    
    func showTipLabel() {
        DispatchQueue.main.async {
            self.moreButton.isHidden = true
            self.honeyLabel.isHidden = false
            self.honeyTipLabel.isHidden = false
            let honeyText = self.viewModel.data.honeyTip
            let height = honeyText.estimatedFrame(font: UIFont.fontWithName(type: .regular, size: 13)).height
            self.layoutIfNeeded()
            // 꿀팁크기 26, 기본 15
            self.honeyHeightLayout.constant = height
            self.likeImgTopLayout.constant = height + 26 + 15
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resizeTableView"), object: nil)
        }
    }
    
    @IBAction func moreViewClick(_ sender: Any) {
        showTipLabel()
    }
    
    @IBAction func likeClick(_ sender: Any) {
        guard let model = viewModel.data else {return}
        DispatchQueue.main.async {
            if model.isLike == 1 {
                self.service?.requestDeleteLike(clubPostIdx: model.clubPostIdx) { isSuccess in
                    self.viewModel.data.isLike = 0
                    self.viewModel.data.likeNum -= 1
                    self.isSelectObservable.accept(false)
                    self.likeNumObservable.accept(model.likeNum-1)
                }
            } else {
                self.service?.requestPostLike(clubPostIdx: model.clubPostIdx) { isSuccess in
                    if isSuccess {
                        self.viewModel.data.isLike = 1
                        self.viewModel.data.likeNum += 1
                        self.isSelectObservable.accept(true)
                        self.likeNumObservable.accept(model.likeNum+1)
                    }
                }
            }
        }
    }
    
    @IBAction func editClick(_ sender: Any) {
        guard let reviewInfo = viewModel.data else {return}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reviewEdit"), object: reviewInfo)
    }
}
