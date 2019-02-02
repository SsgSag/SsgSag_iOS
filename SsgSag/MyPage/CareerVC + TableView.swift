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
        
        return tableView.sectionHeaderHeight + 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight + 20))
        headerView.backgroundColor = UIColor.cyan
        headerView.layer.borderColor = UIColor.white.cgColor
        headerView.layer.borderWidth = 1.0;
        
         let headerButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width - 5, height: tableView.sectionHeaderHeight + 20))
        headerButton.setTitle("추가예용", for: .normal)
        headerView.addSubview(headerButton)

        switch tableView {
        case activityTableView:
            headerButton.target(forAction: #selector(addPresentAction), withSender: nil)
            if headerButton.isSelected == true {
                print("눌럿습니댜")
            }
        case prizeTableView:
            headerButton.target(forAction: #selector(addActivityPresentAction), withSender: nil)
        default:
            print("dasdasd")
        }
        
        return headerView
    }

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bottomLine = UIView()
        customTabBar.addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomLine.backgroundColor = UIColor.white
        bottomLine.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalToSystemSpacingBelow: customTabBar.bottomAnchor, multiplier: 0).isActive = true
        
        switch tableView {
        case activityTableView:
            if activityList.count > 0 {
                return activityList.count
            } else {
                print("asldjlasjdlajsldkjalsjdklajslkdjasl: \(activityList.count)")
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
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        print("눌러눌러")
    //        if indexPath.row == 0 {
    //            if let activityVC = storyboard?.instantiateViewController(withIdentifier: "AddActivityVC")
    //            {
    //                present(activityVC, animated: true)
    //            }
    //        }
    //    }
}
