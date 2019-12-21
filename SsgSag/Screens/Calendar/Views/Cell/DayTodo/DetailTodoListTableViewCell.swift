//
//  DetailTodoListTableViewCell.swift
//  SsgSag
//
//  Created by admin on 16/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol TodoDeleteDelegate: class {
    func selectedTodo(_ posterIdx: Int, indexPath: IndexPath)
    func deselectedTodo(_ posterIdx: Int, indexPath: IndexPath)
}

class DetailTodoListTableViewCell: UITableViewCell {
    
    weak var deleteDelegate: TodoDeleteDelegate?
    
    private let posterService: PosterService
        = DependencyContainer.shared.getDependency(key: .posterService)
    
    private var isLike: Int = 0
    var isEditingDelete: Bool = false
    var indexPath: IndexPath?
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var posterName: UILabel!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var posterDate: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var poster: MonthTodoData? {
        didSet {
            setupTodoCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.posterImageView.image = UIImage(named: "ic_imgDefault")
        self.posterName.text = ""
    }
    
    private func setupTodoCell() {
        guard let posterInfo = poster else { return }
        posterName.text = posterInfo.posterName
        
        guard let categoryIdx = posterInfo.categoryIdx,
            let posterCate = PosterCategory(rawValue: categoryIdx),
            let posterEndDate = posterInfo.posterEndDate else { return }
        
        var categoryString = posterCate.categoryString()
        
        if categoryIdx == 2 {
            let subCategory = posterInfo.subCategoryIdx == 0 ? "연합" : "교내"
            categoryString.append("(\(subCategory))")
        }
        
        categoryButton.setTitle(categoryString, for: .normal)
        categoryButton.setTitleColor(posterCate.categoryColors(), for: .normal)
        
        categoryButton.backgroundColor = posterCate.categoryColors().withAlphaComponent(0.05)
        
        let endDate = DateCaculate.stringToDateWithGenericFormatter(using: posterEndDate)
        let component = Calendar.current.dateComponents([.month, .day, .weekday], from: endDate)
        guard let weekDay = WeekDays(rawValue: component.weekday!) else {return}
        
        let startDateFormString = DateCaculate.stringToDateWithGenericFormatter(using: posterInfo.posterStartDate ?? "")
        let startComponent = Calendar.current.dateComponents([.month, .day, .weekday], from: startDateFormString)
        guard let startWeekDay = WeekDays(rawValue: startComponent.weekday!) else {return}
        
        let startDateString = "\(startComponent.month!).\(startComponent.day!)(\(startWeekDay.koreanWeekdays))"
        let endDateString = "\(component.month!).\(component.day!)(\(weekDay.koreanWeekdays))"
        
        posterDate.text = startDateString == endDateString ? "~\(endDateString)" : "\(startDateString)~\(endDateString)"
        
        if isEditingDelete {
            favoriteButton.setImage(UIImage(named: "ic_selectAllPassive"), for: .normal)
        } else {
            if posterInfo.isFavorite == 1 {
                favoriteButton.setImage(UIImage(named: "ic_favorite"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "ic_favoritePassive"), for: .normal)
            }
            
            isLike = posterInfo.isFavorite ?? 0
        }
    }
    
    @IBAction func touchUpFavoriteButton(_ sender: UIButton) {
        if isEditingDelete {
            guard let indexPath = indexPath,
                let posterIdx = poster?.posterIdx else {
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
        
        let method: HTTPMethod = poster?.isFavorite == 1 ? .delete : .post
        
        guard let index = poster?.posterIdx else {
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
                            self?.isLike = 1
                        } else {
                            sender.setImage(UIImage(named: "ic_favoritePassive"),
                                            for: .normal)
                            self?.isLike = 0
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
