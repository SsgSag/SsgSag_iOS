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
    func pushViewController(_ controller: UIViewController, _ favoriteButton: UIButton)
}

protocol ReloadCalendarDelegate: class {
    func reloadCalendarData()
}

class TodoListCollectionViewCell: UICollectionViewCell {
    weak var delegate: dismissDelegate?
    weak var pushDelegate: PushDelegate?
    weak var calendarDelegate: ReloadCalendarDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    private let calendarService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    var monthTodoData: [MonthTodoData]? {
        didSet {
            todoListTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        setupTableView()
    }
    
    private func setupTableView() {
        let todoNib = UINib(nibName: "DetailTodoListTableViewCell",
                            bundle: nil)
        
        todoListTableView.register(todoNib,
                                   forCellReuseIdentifier: "todoCell")
        
        let noTodoNib = UINib(nibName: "NoTodoTableViewCell", bundle: nil)
        todoListTableView.register(noTodoNib, forCellReuseIdentifier: "noTodoCell")
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
        if monthTodoData?.count == 0 {
            return tableView.frame.height - 50
        }
        return 83
    }
}

extension TodoListCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if monthTodoData?.count == 0 {
            return 1
        }
        return monthTodoData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if monthTodoData?.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "noTodoCell", for: indexPath) as? NoTodoTableViewCell else {
                return .init()
            }
            return cell
        }
        
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
        
        guard let cell = tableView.cellForRow(at: indexPath) as? DetailTodoListTableViewCell else {
            return
        }
        
        let detailInfoVC = DetailInfoViewController()
        
        detailInfoVC.posterIdx = monthTodoData?[indexPath.row].posterIdx

        pushDelegate?.pushViewController(detailInfoVC, cell.favoriteButton)
    }
//
//    func tableView(_ tableView: UITableView,
//                   canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView,
//                   commit editingStyle: UITableViewCell.EditingStyle,
//                   forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            monthTodoData?.remove(at: indexPath.row)
//
//            guard let posterIdx = monthTodoData?[indexPath.row].posterIdx else {
//                return
//            }
//
//            calendarService.requestDelete(posterIdx) { [weak self] result in
//                switch result {
//                case .success(let status):
//                    DispatchQueue.main.async {
//                        switch status {
//                        case .processingSuccess:
//                            self?.calendarDelegate?.reloadCalendarData()
//                            print("완료")
//                        case .dataBaseError:
//                            return
//                        case .serverError:
//                            return
//                        default:
//                            return
//                        }
//                    }
//                case .failed(let error):
//                    print(error)
//                    return
//                }
//            }
//
//            tableView.deleteRows(at: [indexPath],
//                                 with: .fade)
//        }
//    }
//
}
