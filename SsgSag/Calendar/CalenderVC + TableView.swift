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
        
        if let category : PosterCategory = PosterCategory(rawValue:todoTableData[indexPath.row].5) {
            cell.categoryLabel.text = category.categoryString()
            cell.categoryLabel.textColor = category.categoryColors()
            cell.leftLineView.backgroundColor =  category.categoryColors()
        }
        
        cell.contentLabel.text = "\(todoTableData[indexPath.row].4)"
        
        let todoDataStartMonth = Calendar.current.component(.month, from: todoTableData[indexPath.row].0)
        let todoDataStartDay = Calendar.current.component(.day, from: todoTableData[indexPath.row].0)
        
        let todoDataEndMonth = Calendar.current.component(.month, from: todoTableData[indexPath.row].1)
        let todoDataEndDay = Calendar.current.component(.day, from: todoTableData[indexPath.row].1)
        
        cell.dateLabel.text = "\(todoDataStartMonth).\(todoDataStartDay) ~ \(todoDataEndMonth).\(todoDataEndDay)"
        
        if Date() < todoTableData[indexPath.row].1 {
            cell.newImage.isHidden = true
            cell.newImage.image = #imageLiteral(resourceName: "icTaskTimeout")
            
            cell.leftedDay.isHidden = false
            cell.leftedDayBottom.isHidden = false
            
            cell.leftedDay.text = "\(todoListDay-todayDay)"
        } else {
            cell.newImage.isHidden = false
            cell.leftedDay.isHidden = true
            cell.leftedDayBottom.isHidden = true
        }
        
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
        return tableView.frame.height / 3
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
        
        editAction.backgroundColor = UIColor.rgb(red: 49, green: 137, blue: 240)
        deleteAction.backgroundColor = UIColor.rgb(red: 249, green: 106, blue: 106)
        
        return [editAction, deleteAction]
    }
}
