//
//  ApplySuccessViewController.swift
//  SsgSag
//
//  Created by admin on 22/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

// 지원완료 화면
class ApplySuccessViewController: UIViewController {
    
    private let calendarServiceImp: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)
    
    var posters: [Posters] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func moveToCalendar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 임시
//        posters = getPostersData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.backgroundColor = UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        tableView.separatorStyle = .none
    }
    // 임시
//    private func getPostersData() -> [Posters] {
//
//        let userDefaultsPoster = StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm()
//
//        var resultPoster: [Posters] = []
//
//        for poster in userDefaultsPoster {
//
//            guard let posterIdx = poster.posterIdx else { return resultPoster }
//
//            if let completePoster = UserDefaults.standard.object(forKey: "completed\(posterIdx)") as? Int {
//                guard let completeState = applyCompleted(rawValue: completePoster) else { return resultPoster}
//
//                if completeState == .completed {
//                    resultPoster.append(poster)
//                }
//            }
//        }
//
//        return resultPoster
//    }
}

extension ApplySuccessViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let todoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoTableViewCell else {
            return .init()
        }
        
        todoTableViewCell.poster = posters[indexPath.row]
        
        return todoTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 89
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "삭제") { [weak self] action, indexPath in
            // 임시
//
//            var posterInfo = StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm()
//
//            guard let posterIdx = self?.posters[indexPath.row].posterIdx else {return}
//
//            for index in 0..<posterInfo.count-1 {
//
//                guard let posterInfoPosterIdx = posterInfo[index].posterIdx else { return }
//
//                if posterIdx == posterInfoPosterIdx {
//                    posterInfo.remove(at: index)
//
//                    self?.calendarServiceImp.requestDelete(posterIdx) { [weak self] (dataResponse) in
//
//                        guard let statusCode = dataResponse.value?.status else {return}
//
//                        guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
//
//                        switch httpStatusCode {
//                        case .processingSuccess:
//                            print("DeletePoster isSuccessfull")
//                        case .serverError:
//                            print("DeletePoster serverError")
//                        case .dataBaseError:
//                            print("DeletePoster dataBaseError")
//                        default:
//                            break
//                        }
//                    }
//
//                }
//            }
//
//            StoreAndFetchPoster.shared.storePoster(posters: posterInfo)
//
//            NotificationCenter.default.post(name: NSNotification.Name(NotificationName.deleteUserDefaults), object: nil)
//
//            self?.posters = self?.getPostersData() ?? []
//
//            DispatchQueue.main.async {
//                tableView.reloadData()
//            }
        }
        
        deleteAction.backgroundColor = UIColor.rgb(red: 249, green: 106, blue: 106)
        
        return [deleteAction]
    }
    
}
