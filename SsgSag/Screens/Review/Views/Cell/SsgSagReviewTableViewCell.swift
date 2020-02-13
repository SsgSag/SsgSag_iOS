//
//  SsgSagReviewTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SsgSagReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activeYearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var advantageLabel: UILabel!
    @IBOutlet weak var disAdvantageLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var honeyTipLabel: UILabel!
    @IBOutlet weak var likeFixLabel: UILabel!
    @IBOutlet weak var likeBackView: UIView!
    
    lazy var fullStar = UIImage(named: "star2")
    lazy var halfStar = UIImage(named: "star1")
    lazy var blackStar = UIImage(named: "star0")
    lazy var unSelectImg = UIImage(named: "icHelpful")
    lazy var selectImg = UIImage(named: "icHelpfulActive")
//    var score: Float = -1
    var service: ReviewServiceProtocol?
    var model: ReviewInfo?
    
    let isSelectObservable = BehaviorRelay(value: false)
    let likeNumObservable = BehaviorRelay(value: 0)
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bind(model: ReviewInfo, service: ReviewServiceProtocol = ReviewService()) {
        self.service = service
        self.model = model
        userNameLabel.text = String(model.userIdx)
        let activeDate = model.clubEndDate.split(separator: "-").map{String($0)}
        activeYearLabel.text = activeDate[0]+"년 활동"
        titleLabel.text = model.oneLine
        advantageLabel.text = model.advantage
        disAdvantageLabel.text = model.disadvantage
        honeyTipLabel.text = model.honeyTip
        likeLabel.text = "\(model.likeNum)개"
        scoreLabel.text = "별점 \(model.score0)"
        self.ratePaint(score: Float(model.score0))
        
        isSelectObservable
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isSelect in
                DispatchQueue.main.async {
                    if isSelect {
                        self?.likeFixLabel.textColor = .white
                        self?.likeImg.image = self?.selectImg
                        self?.likeLabel.textColor = .white
                        self?.likeBackView.backgroundColor = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
                        self?.likeBackView.layer.borderWidth = 0
                    } else {
                        self?.likeFixLabel.textColor = #colorLiteral(red: 0.5406702161, green: 0.5406834483, blue: 0.5406762958, alpha: 1)
                        self?.likeImg.image = self?.unSelectImg
                        self?.likeLabel.textColor = #colorLiteral(red: 0.5406702161, green: 0.5406834483, blue: 0.5406762958, alpha: 1)
                        self?.likeBackView.backgroundColor = .white
                        self?.likeBackView.layer.borderWidth = 1
                    }
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
        
        let select = model.isLike == 0 ? false : true
        isSelectObservable.accept(select)
        likeNumObservable.accept(model.likeNum)
        
    }
    
    func ratePaint(score: Float) {
    
        let stackStar = self.starStackView.subviews as! [UIImageView]
        var score = score
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
    
    @IBAction func likeClick(_ sender: Any) {
        guard let model = model else {return}
        if model.isLike == 1 {
            
        } else {
            print("좋아요를 눌렀습니다!!")
            service?.requestPostLike(clubPostIdx: model.clubPostIdx) { isSuccess in
                    if isSuccess {
                        self.model?.isLike = 1
                        self.isSelectObservable.accept(true)
                        self.likeNumObservable.accept(model.likeNum+1)
                    }
            }
        }
        
    }
    
    @IBAction func editClick(_ sender: Any) {
    }
}
