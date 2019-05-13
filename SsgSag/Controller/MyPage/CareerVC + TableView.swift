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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == activityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            
            cell.activityDelegate = self
            
            let activity: careerData = self.activityList[indexPath.row]
            
            
            cell.activityInfo = activity
            cell.selectionStyle = .none
            
            return cell
            
        } else if tableView == prizeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeCell", for: indexPath) as! NonActivityCell
            let prize: careerData = self.prizeList[indexPath.row]
            cell.titleLabel.text = prize.careerName
            cell.dateLabel1.text = prize.careerDate1
            cell.detailLabel.text = prize.careerContent
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CertificationCell", for: indexPath) as! NonActivityCell
            let certification: careerData = self.certificationList[indexPath.row]
            cell.titleLabel.text = certification.careerName
            cell.dateLabel1.text = certification.careerDate1
            cell.detailLabel.text = certification.careerContent
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case activityTableView:
            
            let activityVC = storyboard?.instantiateViewController(withIdentifier: "AddActivityVC") as! AddActivityVC
            
            let activity: careerData = self.activityList[indexPath.row]
            
            activityVC.activityData = activity
                    
            present(activityVC, animated: true)
            
        case prizeTableView:
            let prizeVC = storyboard?.instantiateViewController(withIdentifier: "AddVC") as! AddVC
            let prize: careerData = self.prizeList[indexPath.row]
            
            prizeVC.titleString = prize.careerName
            prizeVC.yearString = prize.careerDate1
            prizeVC.contentString = prize.careerContent
            
            present(prizeVC, animated: true)
        case certificationTableView:
            
            let certiVC = storyboard?.instantiateViewController(withIdentifier: "AddCertificationVC") as! AddCertificationVC
            
            let certification: careerData = certificationList[indexPath.row]
            
            certiVC.titleString = certification.careerName
            certiVC.yearString = certification.careerDate1
            certiVC.contentString = certification.careerContent
            
            present(certiVC, animated: true)
        default:
            print("tableview가 없습니다.")
        }
        
    }
}

extension CareerVC: activityDelegate {
    func deleteSuccess() {
        let alert = UIAlertController(title: "데이터가 삭제 되었습니다.", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.activityTableView.reloadData()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

/*
extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static var ItemView: UIStoryboard {
        return UIStoryboard(name: "ItemView", bundle: Bundle.main)
    }
    
    static var chatView: UIStoryboard {
        return UIStoryboard(name: "Chatting", bundle: Bundle.main)
    }
}
*/
