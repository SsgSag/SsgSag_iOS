//
//  ApplySuccessViewController.swift
//  SsgSag
//
//  Created by admin on 22/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ApplySuccessViewController: UIViewController {
    
    private func getPostersData() -> [Posters]{
        let userDefaultsPoster = CalenderView.getPosterUsingUserDefaults()
        
        var resultPoster: [Posters] = []
        
        for poster in userDefaultsPoster {
            
            guard let posterIdx = poster.posterIdx else { return resultPoster }
            
            if let completePoster = UserDefaults.standard.object(forKey: "completed\(posterIdx)") as? Int {
                guard let completeState = applyCompleted(rawValue: completePoster) else { return resultPoster}
                
                if completeState == .completed {
                    resultPoster.append(poster)
                }
            }
        }
        
        return resultPoster
    }
    
    var posters: [Posters] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func moveToCalendar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posters = getPostersData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.backgroundColor = UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        tableView.separatorStyle = .none
    }
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
        
        return Staticheight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "삭제", handler: { (action, indexPath) in
        
            var posterInfo = CalenderView.getPosterUsingUserDefaults()
            
            guard let posterIdx = self.posters[indexPath.row].posterIdx else {return}
            
            for index in 0..<posterInfo.count-1 {
                
                guard let posterInfoPosterIdx = posterInfo[index].posterIdx else { return }
                
                if posterIdx == posterInfoPosterIdx {
                        posterInfo.remove(at: index)
                    
                    let posterDelete = CalendarServiceImp()
                    posterDelete.requestDelete(posterIdx) { (dataResponse) in
                        
                        guard let statusCode = dataResponse.value?.status else {return}
                        
                        guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
                        
                        switch httpStatusCode {
                        case .favoriteSuccess:
                            print("DeletePoster isSuccessfull")
                        case .serverError:
                            print("DeletePoster serverError")
                        case .dataBaseError:
                            print("DeletePoster dataBaseError")
                        default:
                            break
                        }
                    }
                    
                }
            }
            
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(posterInfo), forKey: "poster")
            
            NotificationCenter.default.post(name: NSNotification.Name("deleteUserDefaults"), object: nil)
        
            self.posters = self.getPostersData()
            
            tableView.reloadData()
        })
        
        deleteAction.backgroundColor = UIColor.rgb(red: 249, green: 106, blue: 106)
        
        return [deleteAction]
    }
    
}
