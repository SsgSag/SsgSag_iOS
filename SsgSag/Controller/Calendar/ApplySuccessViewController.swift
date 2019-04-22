//
//  ApplySuccessViewController.swift
//  SsgSag
//
//  Created by admin on 22/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ApplySuccessViewController: UIViewController {
    
    var posters: [Posters] {
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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func moveToCalendar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}
