var sharedTableViewHeight: CGFloat = 0

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
        guard let todoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoTableViewCell else {
            return .init()
        }
        
        todoTableViewCell.poster = todoTableData[indexPath.row]
        
        return todoTableViewCell
    }
    
    //MARK: UITableviewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: StoryBoardName.calendar, bundle: nil)
        let CalendarDetailVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.detailPosterViewController) as! CalendarDetailVC
    
        let posterInfo = StoreAndFetchPoster.getPoster
                for poster in posterInfo {
                    guard let posterName = todoTableData[indexPath.row].posterName else { return }
                    if posterName == poster.posterName! {
                        CalendarDetailVC.Poster = poster
                    }
                }
        
    
        
        present(CalendarDetailVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sharedTableViewHeight = tableView.frame.height / 3
        return tableView.frame.height / 3
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .default, title: "완료", handler: { (action, indexPath) in
            
            guard let posterIdx = self.todoTableData[indexPath.row].posterIdx else {return}
            
            UserDefaults.standard.setValue(1, forKey: "completed\(posterIdx)")
            
            let posterComplete = CalendarServiceImp()
            posterComplete.reqeustComplete(posterIdx) { (dataResponse) in
                
                guard let statusCode = dataResponse.value?.status else {return}
                
                guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {return}
                
                switch httpStatusCode {
                case .favoriteSuccess:
                    print("CompleteApplyPoster isSuccessfull")
                case .serverError:
                    print("CompleteApplyPoster serverError")
                case .dataBaseError:
                    print("CompleteApplyPoster dataBaseError")
                default:
                    break
                }
                
            }
            
            tableView.reloadData()
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "삭제", handler: { (action, indexPath) in
            
            //유저 디폴츠에서 꺼낸
            let posterInfo = StoreAndFetchPoster.getPoster

                    var userDefaultsData = posterInfo
                    
                    for index in 0...posterInfo.count-1 {
                        //유저디폴츠에서 꺼낸 poster과 todoTableData의 이름이 같다면
                        if posterInfo[index].posterName! == self.todoTableData[indexPath.row].posterName! {
                            
                            userDefaultsData.remove(at: index)
                            
                            let posterDelete = CalendarServiceImp()
                            guard let posterIdx = self.todoTableData[indexPath.row].posterIdx else {return}
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
            
                StoreAndFetchPoster.storePoster(posters: userDefaultsData)
                                    
                NotificationCenter.default.post(name: NSNotification.Name("deleteUserDefaults"), object: nil)
            
           
        })
        
        editAction.backgroundColor = UIColor.rgb(red: 49, green: 137, blue: 240)
        deleteAction.backgroundColor = UIColor.rgb(red: 249, green: 106, blue: 106)
        
        return [deleteAction, editAction]
    }
}

