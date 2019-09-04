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
    
    var controller: UIViewController?
    
    private let calendarService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    var monthTodoData: [MonthTodoData]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        setupTableView()
        setupLongPressGesture()
    }
    
    private func setupTableView() {
        let todoNib = UINib(nibName: "DetailTodoListTableViewCell",
                            bundle: nil)
        
        todoListTableView.register(todoNib,
                                   forCellReuseIdentifier: "todoCell")
        
        let noTodoNib = UINib(nibName: "NoTodoTableViewCell", bundle: nil)
        todoListTableView.register(noTodoNib, forCellReuseIdentifier: "noTodoCell")
    }
    
    private func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer
            = UILongPressGestureRecognizer(target: self,
                                           action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        todoListTableView.addGestureRecognizer(longPressGesture)
    }
    
    func setupMonthTodoData(_ monthTodoData: [MonthTodoData]) {
        self.monthTodoData = monthTodoData
        todoListTableView.reloadData()
        
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: todoListTableView)
            if let indexPath = todoListTableView.indexPathForRow(at: touchPoint) {
                guard let controller = controller as? DayTodoViewController else {
                    return
                }
                
                guard let posterIdx = monthTodoData?[indexPath.row].posterIdx,
                    let posterTitle = monthTodoData?[indexPath.row].posterName else {
                    return
                }
                
                controller.simpleAlertwithHandler(title: "[ \(posterTitle) ]",
                                                  message: "해당 일정을 삭제하시겠습니까?") { [weak self] _ in
                    
                    self?.calendarService.requestTodoDelete(posterIdx) { [weak self] result in
                        switch result {
                        case .success(let status):
                            DispatchQueue.main.async {
                                switch status {
                                case .processingSuccess:
                                    self?.monthTodoData?.remove(at: indexPath.row)
                                    self?.todoListTableView.deleteRows(at: [indexPath],
                                                                       with: .fade)
                                    self?.calendarDelegate?.reloadCalendarData()
                                case .dataBaseError:
                                    return
                                case .serverError:
                                    return
                                default:
                                    return
                                }
                            }
                        case .failed(let error):
                            print(error)
                            return
                        }
                    }
                }
            }
        }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "noTodoCell",
                                                           for: indexPath) as? NoTodoTableViewCell else {
                return .init()
            }
            
            cell.selectionStyle = .none
            
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
        if monthTodoData?.count == 0 {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? DetailTodoListTableViewCell else {
            return
        }
        
        let detailInfoVC = DetailInfoViewController()
        
        detailInfoVC.posterIdx = monthTodoData?[indexPath.row].posterIdx

        pushDelegate?.pushViewController(detailInfoVC, cell.favoriteButton)
    }

}

extension TodoListCollectionViewCell: UIGestureRecognizerDelegate {
}
