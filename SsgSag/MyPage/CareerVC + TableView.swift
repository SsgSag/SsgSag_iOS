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
            print("추가하기 버튼 안 눌림")
        }
        return headerView
    }

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case activityTableView:
            if activityList.count > 0 {
                return activityList.count
            } else {
                //                setUpEmptyTableView(tableView: activityTableView, isEmptyTable: true)
                return activityList.count
            }
        case prizeTableView:
            if prizeList.count == 0 {
                print("2번째 비어있음: \(prizeList.count)")
                //                setUpEmptyTableView(tableView: prizeTableView, isEmptyTable: true)
                return prizeList.count
            } else { return prizeList.count }
        case certificationTableView:
            if certificationList.count == 0 {
                //                setUpEmptyTableView(tableView: certificationTableView)
                return certificationList.count
            } else { return certificationList.count }
        default : return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == activityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            let activity: Datum = self.activityList[indexPath.row]
            cell.titleLabel.text = activity.careerName
            cell.dateLabel1.text = activity.careerDate1
            guard let date2 = activity.careerDate2 else {
                print("없따아아아")
                return cell
            }
            cell.dateLabel2.text = "~ " + date2
//            if activity.careerDate2 != "" {
//                cell.dateLabel2.text = "~ " + activity.careerDate2!
//            }
            cell.detailLabel.text = activity.careerContent
            cell.selectionStyle = .none
            return cell
            
        } else if tableView == prizeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrizeCell", for: indexPath) as! NonActivityCell
            let prize: Datum = self.prizeList[indexPath.row]
            cell.titleLabel.text = prize.careerName
            cell.dateLabel1.text = prize.careerDate1
            cell.detailLabel.text = prize.careerContent
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CertificationCell", for: indexPath) as! NonActivityCell
            let certification: Datum = self.certificationList[indexPath.row]
            cell.titleLabel.text = certification.careerName
            cell.dateLabel1.text = certification.careerDate1
            cell.detailLabel.text = certification.careerContent
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("눌러눌러")
            
            switch tableView {
                
            case activityTableView:
                let activityVC = storyboard?.instantiateViewController(withIdentifier: "AddActivityVC") as! AddActivityVC
                let activity: Datum = self.activityList[indexPath.row]
                //TODO: - 날짜 수정
                activityVC.titleString = activity.careerName
//                activityVC.startDateLabel.text = cell.dateLabel1.text
//                activityVC.endDateLabel.text = cell.dateLabel2.text
                activityVC.contentTextString = activity.careerContent
                present(activityVC, animated: true)
                
                
                
            case prizeTableView:
                let prizeVC = storyboard?.instantiateViewController(withIdentifier: "AddVC") as! AddVC
                let prize: Datum = self.prizeList[indexPath.row]
               
                prizeVC.titleString = prize.careerName
                prizeVC.yearString = prize.careerDate1
                prizeVC.contentString = prize.careerContent
                
                present(prizeVC, animated: true)
                
            case certificationTableView:
                let certiVC = storyboard?.instantiateViewController(withIdentifier: "AddCertificationVC") as! AddCertificationVC
                 let certification: Datum = certificationList[indexPath.row]
                 
                 certiVC.titleString = certification.careerName
                 certiVC.yearString = certification.careerDate1
                 certiVC.contentString = certification.careerContent
                 
                present(certiVC, animated: true)
                
            default:
                print("tableview가 없습니다.")
            }
        }
}
