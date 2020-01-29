//
//  ClubReviewTableViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/26.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ClubListTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clubDetailButton: UIButton!
    
    let fullStar = UIImage(named: "star2")
    let halfStar = UIImage(named: "star1")
    let blackStar = UIImage(named: "star0")
    var score: Float = -1
    var delegate: ClubListSelectDelgate!
    var categorySet: [String] = []
    var viewModel: ClubListData! {
        willSet {
            self.reviewCountLabel.text = newValue.categoryList
            self.titleLabel.text = newValue.clubName
            self.descriptionLabel.text = newValue.oneLine
            self.scoreLabel.text = "평점 \(newValue.aveScore)"
            self.score = newValue.aveScore
            self.reviewCountLabel.text = "후기 20개"
            self.categorySet = newValue.categoryList.removeComma()
            ratePaint()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        self.categoryCollectionView.setCollectionViewLayout(layout, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func ratePaint() {
        let stackStar: [UIImageView] = [star1 , star2, star3, star4, star5]
    
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

    @IBAction func moreReviewClick(_ sender: Any) {
        delegate.clubDetailClick(clubIdx: viewModel.clubIdx)
    }
}

extension ClubListTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categorySet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClubListCategoryCell", for: indexPath) as! ClubCategoryCollectionViewCell
        
        cell.categoryLabel.text = self.categorySet[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = self.categorySet[indexPath.row]
        
        let widthEstimate = collectionView.frame.width/2
        let size = CGSize(width: widthEstimate, height: 18)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Apple SD 산돌고딕 Neo", size: 10.0) as Any]
        let estimateSize = NSString(string: title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        //폰트가로크기오차 6 마진 8
        //폰트세로크기오차 2 마진 8
        return CGSize(width: estimateSize.width+6+8, height: estimateSize.height+2+8)
    }
}
