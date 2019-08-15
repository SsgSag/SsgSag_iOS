//
//  CareerVC + TableView.swift
//  SsgSag
//
//  Created by CHOMINJI on 31/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

extension CareerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return tableView.sectionHeaderHeight + 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        
        let headerButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width - 5, height: tableView.sectionHeaderHeight))
        
        let myNormalAttributedTitle = NSAttributedString(string: " 추가하기",
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 66, green: 94, blue: 229), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        let mySelectedAttributedTitle = NSAttributedString(string: " 추가하기",
                                                           attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        
        headerButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        headerButton.setAttributedTitle(mySelectedAttributedTitle, for: .highlighted)
        headerButton.setImage(UIImage(named: "icPlus"), for: .normal)
        
        
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerButton)
        
        headerButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        headerButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        switch tableView {
        case activityTableView:
            headerButton.addTarget(self, action: #selector(addActivityPresentAction), for: .touchUpInside)
        case prizeTableView:
            headerButton.addTarget(self, action: #selector(addPresentAction), for: .touchUpInside)
        case certificationTableView:
            headerButton.addTarget(self, action: #selector(addCertificationPresentAction), for: .touchUpInside)
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case activityTableView:
            return activityList.count
            
        case prizeTableView:
            return prizeList.count
        
        case certificationTableView:
            return certificationList.count
        default : return 0
        }
    }
    
    // FIXME: - 이력의 각 테이블뷰 수정!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == activityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            
            cell.activityDelegate = self
            cell.selectionStyle = .none
            
            cell.activityInfo = self.activityList[indexPath.row]

            return cell
            
        } else if tableView == prizeTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeCell", for: indexPath) as! NonActivityCell
            
            cell.activityDelegate = self
            cell.careerInfo = prizeList[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CertificationCell", for: indexPath) as! NonActivityCell
            
            cell.activityDelegate = self
            cell.careerInfo = certificationList[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case activityTableView:
            
            guard let activityVC = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.addActivityViewController) as? AddActivityVC else {
                return
            }
            
            let activity: careerData = self.activityList[indexPath.row]
            activityVC.activityData = activity
            activityVC.isNewActivity = false
            activityVC.delegate = self
                    
            present(activityVC, animated: true)
            
        case prizeTableView:
            
            guard let prizeVC = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.addViewController) as? AddVC else {
                return
            }
            
            let prize: careerData = self.prizeList[indexPath.row]
            
            prizeVC.titleString = prize.careerName
            prizeVC.yearString = prize.careerDate1
            prizeVC.contentString = prize.careerContent
            prizeVC.isNewActivity = false
            prizeVC.index = prize.careerIdx
            prizeVC.delegate = self
            
            present(prizeVC, animated: true)
        case certificationTableView:
            
            guard let certiVC = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.addCertificationViewController) as? AddCertificationVC else {
                return
            }
            
            let certification: careerData = certificationList[indexPath.row]
            
            certiVC.titleString = certification.careerName
            certiVC.yearString = certification.careerDate1
            certiVC.contentString = certification.careerContent
            
            certiVC.isNewActivity = false
            certiVC.index = certification.careerIdx
            certiVC.delegate = self
            
            present(certiVC, animated: true)
        default:
            print("tableview가 없습니다.")
        }
        
    }
}

extension CareerVC: activityDelegate {
    func deleteSuccess() {
        let alert = UIAlertController(title: "데이터가 삭제 되었습니다.", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            
            self?.getData(careerType: 0)
            self?.getData(careerType: 1)
            self?.getData(careerType: 2)
            
            DispatchQueue.main.async { [weak self] in
                self?.activityTableView.reloadData()
                self?.prizeTableView.reloadData()
                self?.certificationTableView.reloadData()
            }
            
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}


