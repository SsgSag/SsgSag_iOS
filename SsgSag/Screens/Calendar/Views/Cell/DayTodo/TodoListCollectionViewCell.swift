//
//  TodoListCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 30/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import FBSDKCoreKit

protocol dismissDelegate: class {
    func touchUpCancelButton()
}

protocol PushDelegate: class {
    func pushViewController(_ controller: UIViewController, _ favoriteButton: UIButton)
}

protocol ReloadCalendarDelegate: class {
    func reloadCalendarData()
}

protocol DeleteTodoDelegate: class {
    func selectedItem(with indexPath: IndexPath)
}

class TodoListCollectionViewCell: UICollectionViewCell {
    weak var delegate: dismissDelegate?
    weak var pushDelegate: PushDelegate?
    weak var deleteDelegate: DeleteTodoDelegate?
    weak var calendarDelegate: ReloadCalendarDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoListTableView: UITableView!
    @IBOutlet weak var edtingButton: UIButton!
    
    var callback: (([MonthTodoData]?)->())?
    var deleteIndexPaths: [IndexPath] = []
    var deletePosterIndexs: [Int] = []
    var controller: UIViewController?
    var monthTodoData: [MonthTodoData]?
    var isEditing: Bool = false {
        didSet {
            changedIsEditing()
        }
    }
    
    private let calendarService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
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
    }
    
    private func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer
            = UILongPressGestureRecognizer(target: self,
                                           action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
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
                
                controller.simpleAlertwithHandler(title: "\(posterTitle)",
                                                  message: "해당 일정을 삭제하시겠습니까?") { [weak self] _ in
                    
                    self?.calendarService.requestTodoDelete([posterIdx]) { [weak self] result in
                        switch result {
                        case .success(let status):
                            DispatchQueue.main.async {
                                switch status {
                                case .processingSuccess:
                                    self?.monthTodoData?.remove(at: indexPath.row)
                                    self?.todoListTableView.deleteRows(at: [indexPath],
                                                                       with: .fade)
                                    self?.callback?(self?.monthTodoData)
                                case .dataBaseError:
                                    print("DB 에러")
                                    return
                                case .serverError:
                                    print("서버 에러")
                                    return
                                default:
                                    return
                                }
                            }
                        case .failed:
                            assertionFailure()
                            return
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func touchUpEditButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "삭제" && deleteIndexPaths.count != 0 {
            
            controller?.simpleAlertwithHandler(title: "",
                                               message: "\(deleteIndexPaths.count)개의 일정을 삭제하시겠어요?") { [weak self] _ in
                guard let self = self else {
                    return
                }
                                                
                self.deleteIndexPaths.sort()
                                                
                self.calendarService.requestTodoDelete(self.deletePosterIndexs) { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    switch result {
                    case .success(let status):
                        DispatchQueue.main.async {
                            switch status {
                            case .processingSuccess:
                                var count = 0
                                self.deleteIndexPaths.forEach {
                                    self.monthTodoData?.remove(at: $0.item - count)
                                    count += 1
                                }
                                self.todoListTableView.deleteRows(at: self.deleteIndexPaths,
                                                                  with: .fade)
                                self.deleteIndexPaths = []
                                self.callback?(self.monthTodoData)
                            case .dataBaseError:
                                print("DB 에러")
                                return
                            case .serverError:
                                print("서버 에러")
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
        
        if isEditing {
            sender.setImage(#imageLiteral(resourceName: "ic_etc"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "ic_editBack"), for: .normal)
        }
        sender.setTitle("", for: .normal)
        isEditing = !isEditing
    }
    
    private func changedIsEditing() {
        todoListTableView.reloadData()
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
        
        cell.deleteDelegate = self
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        
        guard let monthTodoData = monthTodoData?[indexPath.row] else {
            return cell
        }
        
        cell.isEditingDelete = isEditing
        cell.poster = monthTodoData
        
        if monthTodoData.photoUrl == cell.poster?.photoUrl {
            let imageURL = monthTodoData.photoUrl ?? ""
            
            ImageNetworkManager.shared.getImageByCache(imageURL: imageURL){ (image, error) in
                if error == nil {
                    cell.posterImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        if monthTodoData?.count == 0 {
            return tableView.frame.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return NoTodoHeaderView()
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard !isEditing else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? DetailTodoListTableViewCell else {
            return
        }
        AppEvents.logEvent(.viewedContent, valueToSum: 2)
        let detailInfoVC = DetailInfoViewController()
        
        detailInfoVC.posterIdx = monthTodoData?[indexPath.row].posterIdx

        pushDelegate?.pushViewController(detailInfoVC, cell.favoriteButton)
    }

}

extension TodoListCollectionViewCell: UIGestureRecognizerDelegate {
}

extension TodoListCollectionViewCell: TodoDeleteDelegate {
    func selectedTodo(_ posterIdx: Int, indexPath: IndexPath) {
        if deleteIndexPaths.count == 0 {
            edtingButton.setImage(nil, for: .normal)
            edtingButton.setTitle("삭제", for: .normal)
        }
        deletePosterIndexs.append(posterIdx)
        deleteIndexPaths.append(indexPath)
    }
    
    func deselectedTodo(_ posterIdx: Int, indexPath: IndexPath) {
        var index = 0
        
        for deleteIndexPath in deleteIndexPaths {
            if indexPath == deleteIndexPath {
                deleteIndexPaths.remove(at: index)
                deletePosterIndexs.remove(at: index)
                if deleteIndexPaths.count == 0 {
                    edtingButton.setImage(#imageLiteral(resourceName: "ic_editBack"), for: .normal)
                    edtingButton.setTitle("", for: .normal)
                }
                return
            }
            index += 1
        }
    }
}
