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
    
    private let posterService: PosterService
        = DependencyContainer.shared.getDependency(key: .posterService)
    
    weak var deleteDelegate: TodoDeleteDelegate?
    
    var isEditingDelete: Bool = false
    var isLiked: Int = 0
    var indexPath: IndexPath?
    
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
            let categoryIdx = todoData.categoryIdx,
            let isFavorite = todoData.isFavorite else {
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
        
        if isEditingDelete {
            favoriteButton.setImage(UIImage(named: "ic_selectAllPassive"), for: .normal)
            return
        }
        
        if isFavorite == 1 {
            favoriteButton.setImage(UIImage(named: "ic_favorite"), for: .normal)
            isLiked = 1
        } else {
            favoriteButton.setImage(UIImage(named: "ic_favoritePassive"), for: .normal)
            isLiked = 0
        }
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        ddayButton.setTitle("", for: .normal)
        calendarSaveCountButton.setTitle("", for: .normal)
        titleLabel.text = ""
        hashTagLabel.text = ""
    }
    
    @IBAction func touchUpFavoriteButton(_ sender: UIButton) {
        if isEditingDelete {
            guard let indexPath = indexPath,
                let posterIdx = todoData?.posterIdx else {
                return
            }

            sender.isSelected = !sender.isSelected

            if sender.isSelected {
                sender.setImage(UIImage(named: "ic_selectAll-1"),
                                for: .normal)
                deleteDelegate?.selectedTodo(posterIdx, indexPath: indexPath)
            } else {
                sender.setImage(UIImage(named: "ic_selectAllPassive"),
                                for: .normal)
                deleteDelegate?.deselectedTodo(posterIdx, indexPath: indexPath)
            }
            return
        }
        
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool,
            !isTryWithoutLogin else {
                return
        }
        
        let method: HTTPMethod = todoData?.isFavorite == 1 ? .delete : .post
        
        guard let index = todoData?.posterIdx else {
            return
        }
        
        posterService.requestPosterFavorite(index: index,
                                            method: method) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .processingSuccess:
                    DispatchQueue.main.async {
                        if sender.imageView?.image == UIImage(named: "ic_favoritePassive") {
                            sender.setImage(UIImage(named: "ic_favorite"),
                                            for: .normal)
                            self?.isLiked = 1
                        } else {
                            sender.setImage(UIImage(named: "ic_favoritePassive"),
                                            for: .normal)
                            self?.isLiked = 0
                        }
                    }
                case .dataBaseError:
                    print("DB 에러")
                    return
                case .serverError:
                    print("server 에러")
                default:
                    return
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
}
