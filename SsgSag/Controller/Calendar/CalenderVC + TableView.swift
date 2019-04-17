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
        
        let dateFormatter = DateFormatter.genericDateFormatter
        
        guard let posterEndDateString = todoTableData[indexPath.row].posterEndDate else {
            return cell
        }
        
        guard let posterEndDate = dateFormatter.date(from: posterEndDateString) else {
            return cell
        }
        
        let todoDataEndMonth = Calendar.current.component(.month, from: posterEndDate)
        
        let todoDataEndDay = Calendar.current.component(.day, from: posterEndDate)
        
        guard let posterCagegoryIdx = todoTableData[indexPath.row].categoryIdx else { return cell}
        
        guard let posterName = todoTableData[indexPath.row].posterName else { return cell}
        
        cell.contentLabel.text = "\(posterName)"
        
        if let category = PosterCategory(rawValue: posterCagegoryIdx) {
            cell.categoryLabel.text = category.categoryString()
            cell.categoryLabel.textColor = category.categoryColors()
            cell.leftLineView.backgroundColor =  category.categoryColors()
        }
        
        guard let posterStartDateString = todoTableData[indexPath.row].posterStartDate else { return cell }
        
        guard let posterStartDate = dateFormatter.date(from: posterStartDateString) else { return cell }
        
        let todoDataStartMonth = Calendar.current.component(.month, from: posterStartDate)
        let todoDataStartDay = Calendar.current.component(.day, from: posterStartDate)
        
        cell.dateLabel.text = "\(todoDataStartMonth).\(todoDataStartDay) ~ \(todoDataEndMonth).\(todoDataEndDay)"
        
        if Date() < posterEndDate {
            cell.newImage.isHidden = true
            cell.newImage.image = #imageLiteral(resourceName: "icTaskTimeout")
            
            cell.leftedDay.isHidden = false
            cell.leftedDayBottom.isHidden = false
            
            let dayInterval = Calendar.current.dateComponents([.day],
                                                              from: Date(),
                                                              to: posterEndDate)
            
            guard let interval = dayInterval.day else { return cell }
            
            cell.leftedDay.text = "\(interval)"
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
        let CalendarDetailVC = storyBoard.instantiateViewController(withIdentifier: "DetailPoster") as! CalendarDetailVC
    
        if let posterData = UserDefaults.standard.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){
                for poster in posterInfo {
                    guard let posterName = todoTableData[indexPath.row].posterName else { return }
                    if posterName == poster.posterName! {
                        CalendarDetailVC.Poster = poster
                    }
                }
            }
        }
        
        present(CalendarDetailVC, animated: true, completion: nil)
        
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
            
            //유저 디폴츠에서 꺼낸
            if let posterData =  UserDefaults.standard.object(forKey: "poster") as? Data {
                if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData){

                    for index in 0...posterInfo.count-1 {
                        //유저디폴츠에서 꺼낸 poster과 todoTableData의 이름이 같다면
                        if posterInfo[index].posterName! == self.todoTableData[indexPath.row].posterName! {
                            var userDefaultsData = posterInfo
                            userDefaultsData.remove(at: index)
                            
                            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(userDefaultsData), forKey: "poster")
                            NotificationCenter.default.post(name: NSNotification.Name("deleteUserDefaults"), object: nil)
                        }
                    }
                }
            }
        })
        
        editAction.backgroundColor = UIColor.rgb(red: 49, green: 137, blue: 240)
        deleteAction.backgroundColor = UIColor.rgb(red: 249, green: 106, blue: 106)
        
        return [editAction, deleteAction]
    }
}
