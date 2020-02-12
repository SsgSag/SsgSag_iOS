//
//  ReviewSearchTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/31.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var scoreNumLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var oneLineLabel: UILabel!
    @IBOutlet weak var clubNameLabel: UILabel!
    let categoryStack = CategoryList()
    var disposeBag = DisposeBag()
    var delegate: ClubListSelectDelgate?
    var clubIdx: Int?
    
    lazy var fullStar: UIImage = {
        if let image = UIImage(named: "star2") {
            return image
        } else {
            return UIImage()
        }
    }()
    lazy var halfStar: UIImage = {
        if let image = UIImage(named: "star1") {
            return image
        } else {
            return UIImage()
        }
    }()
    lazy var blackStar: UIImage = {
        if let image = UIImage(named: "star0") {
            return image
        } else {
            return UIImage()
        }
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func categoryFactory(labels: [String]) {
        self.addSubview(categoryStack)
        
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        categoryStack.heightAnchor.constraint(equalToConstant: 18).isActive = true
        categoryStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        categoryStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        categoryStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
        
        labels
            .forEach {
                let label = CategoryView(text: $0)
                categoryStack.addSubview(label)
        }
    }
    
    func ratePaint(score: Float, starStackView: UIStackView) {
        guard let stackStar = starStackView.subviews as? [UIImageView] else { return }
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
    
    func bind(viewModel: ReviewSearchViewModel, row: Int) {
        categoryStack.subviews.forEach { $0.removeFromSuperview() }
        categoryFactory(labels: viewModel.cellModel.value[row].categoryList.removeComma())
        clubNameLabel.text = viewModel.cellModel.value[row].clubName
        oneLineLabel.text = viewModel.cellModel.value[row].oneLine
        ratePaint(score: viewModel.cellModel.value[row].aveScore, starStackView: starStackView)
        scoreLabel.text = "평점 \(viewModel.cellModel.value[row].aveScore)"
        scoreNumLabel.text = "후기 \(viewModel.cellModel.value[row].scoreNum)개"
        clubIdx = viewModel.cellModel.value[row].clubIdx
    }
    
    @IBAction func cellClick(_ sender: Any) {
        guard let clubIdx = clubIdx else {return}
        delegate?.clubDetailClick(clubIdx: clubIdx)
    }
}
