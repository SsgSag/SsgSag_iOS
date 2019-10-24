//
//  ListCollectionViewDataSource.swift
//  SsgSag
//
//  Created by 이혜주 on 23/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class ListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private let todoData: [[MonthTodoData]]
    private let cache: NSCache<NSString, UIImage>

    init(_ todoData: [[MonthTodoData]], cache: NSCache<NSString, UIImage>) {
        self.todoData = todoData
        self.cache = cache
        
        super.init()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return todoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return todoData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell
            = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell",
                                                 for: indexPath)
                as? CalendarListCollectionViewCell else {
            return UICollectionViewCell()
        }
        //viewModel.request
        
        cell.todoData = todoData[indexPath.section][indexPath.item]
        
        if todoData[indexPath.section][indexPath.item].thumbPhotoUrl == cell.todoData?.thumbPhotoUrl {
            guard let urlString = todoData[indexPath.section][indexPath.item].thumbPhotoUrl else {
                return cell
            }
            
            if cache.object(forKey: urlString as NSString) == nil {
                if let imageURL = URL(string: urlString) {
                    
                    URLSession.shared.dataTask(with: imageURL) { [cell] data, response, error in
                        guard error == nil,
                            let data = data,
                            let image = UIImage(data: data) else {
                                return
                        }
                        
                        DispatchQueue.main.async {
                            cell.posterImageView.image = image
                        }
                    }.resume()
                }
                return cell
            }
            
            cell.posterImageView.image = cache.object(forKey: urlString as NSString)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if todoData.count == 0 {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "tempHeader",
                                                                       for: indexPath)
            }
            
            guard let header
                = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: "dateSeperateHeader",
                                                                  for: indexPath)
                    as? ListDateSperateCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            guard let posterEndDate
                = todoData[indexPath.section][indexPath.item].posterEndDate else {
                return header
            }
            
            guard let date = dateFormatter.date(from: posterEndDate) else {
                return header
            }
            
            dateFormatter.dateFormat = "M.d(E)"
            
            header.dateLabel.text = dateFormatter.string(from: date)
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
