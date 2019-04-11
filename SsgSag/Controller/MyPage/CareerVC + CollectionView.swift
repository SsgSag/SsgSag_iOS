//
//  CareerVC + CollectionView.swift
//  SsgSag
//
//  Created by CHOMINJI on 31/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation



extension CareerVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCareerCell", for: indexPath) as! CustomCareerCell
        if indexPath.row == 0 {
            cell.label.textColor = .black
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        
        switch indexPath.row {
        case 0 :
            cell.label.text = "대외활동"
            getData(careerType: 0)
        case 1 : cell.label.text = "수상내역"
            getData(careerType: 1)
        case 2 : cell.label.text = "자격증"
            getData(careerType: 2)
        default: break
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 3 , height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCareerCell else {return}
        cell.label.textColor = .black
        indicatorViewLeadingConstraint.constant = (self.view.frame.width / 3) * CGFloat((indexPath.row))
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.customTabBar.layoutIfNeeded()
        }, completion: nil)

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.scrollView.contentOffset.x = self.view.frame.width * CGFloat(indexPath.row)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCareerCell else {return}
        cell.label.textColor = .lightGray
    }
    
    @objc func addActivityPresentAction() {
        if let activityVC = storyboard?.instantiateViewController(withIdentifier: "AddActivityVC")
        {
            
            present(activityVC, animated: true)
        }
    }
    
    @objc func addPresentAction() {
        if let addVC = storyboard?.instantiateViewController(withIdentifier: "AddVC") {
            present(addVC, animated: true)
        }
    }
    
    @objc func addCertificationPresentAction() {
        if let certifiVC = storyboard?.instantiateViewController(withIdentifier: "AddCertificationVC") {
            present(certifiVC, animated: true, completion: nil)
        }
    }
    
   
    
}

