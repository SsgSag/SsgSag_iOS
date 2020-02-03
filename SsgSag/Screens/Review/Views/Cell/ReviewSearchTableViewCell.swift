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
    let fullStar = UIImage(named: "star2")
    let halfStar = UIImage(named: "star1")
    let blackStar = UIImage(named: "star0")
    
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
        
        labels.compactMap {
            let lable = CategoryView(text: $0)
            return lable
        }
        .forEach {
            categoryStack.addSubview($0)
        }
        self.layoutIfNeeded()
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
    
    func bind(viewModel: ReviewSearchViewModel, row: Int) {
        categoryStack.subviews.forEach { $0.removeFromSuperview() }
        categoryFactory(labels: viewModel.cellModel.value[row].categoryList.removeComma())
        clubNameLabel.text = viewModel.cellModel.value[row].clubName
        oneLineLabel.text = viewModel.cellModel.value[row].oneLine
        ratePaint(score: viewModel.cellModel.value[row].aveScore)
        scoreLabel.text = "평점 \(viewModel.cellModel.value[row].aveScore)"
        scoreNumLabel.text = "후기 \(viewModel.cellModel.value[row].scoreNum)개"
        
        
    }
    
}
