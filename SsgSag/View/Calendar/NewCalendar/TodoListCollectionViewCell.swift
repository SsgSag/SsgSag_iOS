//
//  TodoListCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 30/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol dismissDelegate: class {
    func touchUpCancelButton()
}

protocol PushDelegate: class {
    func pushViewController(_ controller: UIViewController)
}

class TodoListCollectionViewCell: UICollectionViewCell {
    weak var delegate: dismissDelegate?
    weak var pushDelegate: PushDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    var monthTodoData: [MonthTodoData]? {
        didSet {
            todoListTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        setupTableView()
    }
    
    private func setupTableView() {
        let todoNib = UINib(nibName: "DetailTodoListTableViewCell",
                            bundle: nil)
        todoListTableView.register(todoNib,
                                   forCellReuseIdentifier: "todoCell")
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        delegate?.touchUpCancelButton()
    }
    
    override func prepareForReuse() {
        dateLabel.text = ""
        monthTodoData = nil
    }

}

extension TodoListCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}

extension TodoListCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return monthTodoData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell
            = tableView.dequeueReusableCell(withIdentifier: "todoCell",
                                            for: indexPath)
                as? DetailTodoListTableViewCell else {
                    return .init()
        }
        
        cell.selectionStyle = .none
        
        guard let monthTodoData = monthTodoData?[indexPath.row] else {
            return cell
        }
        
        cell.poster = monthTodoData
        
        if monthTodoData.photoUrl == cell.poster?.photoUrl {
            let imageURL = monthTodoData.photoUrl ?? ""
            guard let url = URL(string: imageURL) else {
                return cell
            }
            
            ImageNetworkManager.shared.getImageByCache(imageURL: url){ (image, error) in
                if error == nil {
                    cell.posterImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let detailInfoVC = DetailInfoViewController()
        
        detailInfoVC.posterIdx = monthTodoData?[indexPath.row].posterIdx

        pushDelegate?.pushViewController(detailInfoVC)
    }
    
}
