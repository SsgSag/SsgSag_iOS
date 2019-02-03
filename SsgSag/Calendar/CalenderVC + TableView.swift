extension CalenderVC: UITableViewDelegate,UITableViewDataSource {
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoTableData.count
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "지우기"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoTableViewCell else {
            return .init()
        }
        
        let todayDay = Calendar.current.component(.day, from: Date())
        let todoListDay = Calendar.current.component(.day, from: todoTableData[indexPath.row].1)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // FIXME: 주어진 카테고리값에 따라서 라인의 색깔을 바꿔야함
        if indexPath.row % 3 == 0 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 97/255, green: 118/255, blue: 221/255, alpha: 1.0)
        } else if indexPath.row % 3 == 1 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 7/255, green: 166/255, blue: 255/255, alpha: 1.0)
        } else if indexPath.row % 3 == 2 {
            cell.leftLineView.backgroundColor = UIColor(displayP3Red: 254/255, green: 109/255, blue: 109/255, alpha: 1.0)
        }
        
        var categoryLabel = ""
        switch todoTableData[indexPath.row].5 {
        case 0:
            categoryLabel = "공모전"
        case 1:
            categoryLabel = "대외활동"
        case 2:
            categoryLabel = "동아리"
        case 3:
            categoryLabel = "교내공지"
        case 4:
            categoryLabel = "채용"
        default:
            categoryLabel = "기타"
        }
        
        cell.categoryLabel.text = categoryLabel
        cell.contentLabel.text = "\(todoTableData[indexPath.row].4)"
        
        let todoDataStartMonth = Calendar.current.component(.month, from: todoTableData[indexPath.row].0)
        let todoDataStartDay = Calendar.current.component(.day, from: todoTableData[indexPath.row].0)
        
        let todoDataEndMonth = Calendar.current.component(.month, from: todoTableData[indexPath.row].1)
        let todoDataEndDay = Calendar.current.component(.day, from: todoTableData[indexPath.row].1)
        
        cell.dateLabel.text = "\(todoDataStartMonth).\(todoDataStartDay) ~ \(todoDataEndMonth).\(todoDataEndDay)"
        cell.leftedDay.text = "\(todoListDay-todayDay)"
        
        cell.dateLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .light)
        cell.leftedDay.font = UIFont.systemFont(ofSize: 34.0, weight: .medium)
        
        return cell
    }
    
    //MARK: UITableviewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Calendar", bundle: nil)
        let nav = storyBoard.instantiateViewController(withIdentifier: "DetailPoster") as! CalendarDetailVC
        
        let defaults = UserDefaults.standard
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo {
                    if todoTableData[indexPath.row].4 == poster.posterName! {
                        nav.Poster = poster
                    }
                }
            }
        }
        
        present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "완료", handler: { (action, indexPath) in
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "삭제", handler: { (action, indexPath) in
            let defaults = UserDefaults.standard
            
            if let posterData = defaults.object(forKey: "poster") as? Data {
                if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                    for i in 0...posterInfo.count-1 {
                        if posterInfo[i].posterName! == self.todoTableData[indexPath.row].4 {
                            self.todoTableData.remove(at: i)
                        }
                    }
                }
            }
            tableView.reloadData()
        })
        
        deleteAction.backgroundColor = UIColor.red
        editAction.backgroundColor = UIColor.blue
        
        return [editAction, deleteAction]
    }
}
