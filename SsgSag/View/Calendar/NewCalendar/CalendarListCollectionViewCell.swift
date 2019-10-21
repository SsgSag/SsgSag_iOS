//
//  CalendarListCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 21/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CalendarListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ddayButton: UIButton!
    @IBOutlet weak var calendarSaveCountButton: UIButton!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var todoData: MonthTodoData? {
        didSet {
            guard let todoData = self.todoData else {
                return
            }
            
            setupCellData(todoData)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupCellData(_ todoData: MonthTodoData) {
        guard let title = todoData.posterName,
            let dday = todoData.dday,
            let calendarSaveCount = todoData.likeNum,
            let hashTag = todoData.keyword,
            let categoryIdx = todoData.categoryIdx else {
            return
        }
        
        if let category = PosterCategory(rawValue: categoryIdx) {
            categoryButton.setTitle(category.categoryString(), for: .normal)
            categoryButton.setTitleColor(category.categoryColors(), for: .normal)
            categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
        }
        
        titleLabel.text = title
        ddayButton.setTitle("D-\(dday)", for: .normal)
        calendarSaveCountButton.setTitle("\(calendarSaveCount)", for: .normal)
        hashTagLabel.text = hashTag
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        ddayButton.setTitle("", for: .normal)
        calendarSaveCountButton.setTitle("", for: .normal)
        titleLabel.text = ""
        hashTagLabel.text = ""
    }
    
    @IBAction func touchUpFavoriteButton(_ sender: UIButton) {
        sender.setImage(UIImage(named: "ic_favorite"), for: .normal)
    }
}
