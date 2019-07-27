//
//  AccountSettingViewController + UICollectionView.swift
//  SsgSag
//
//  Created by 이혜주 on 23/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

extension AccountSettingViewController: UICollectionViewDelegate {
    
}

extension AccountSettingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 0 {
                guard let header
                    = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                      withReuseIdentifier: "settingImageHeaderID",
                                                                      for: indexPath)
                        as? SettingProfileImageCollectionReusableView else {
                            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: "tempHeaderID",
                                                                                   for: indexPath)
                }
                
                header.delegate = self
                header.setProfileImage(image: selectedImage)
                
                return header
            }
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "tempHeaderID",
                                                                   for: indexPath)
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "tempFooterID",
                                                                   for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "settingTextFieldCellID",
                                                     for: indexPath)
                    as? SettingTextFieldCollectionViewCell else {
                        return .init()
            }
            
            if indexPath.row == 1 {
                cell.setupUnalterableCell(title: settingTitles[indexPath.row],
                                          data: "@naver.com")
            } else {
                cell.setupCell(title: settingTitles[indexPath.row],
                               placeholder: "\(settingTitles[indexPath.row])을/를 입력해주세요")
            }
            
            cell.settingTextField.delegate = self
            
            return cell
        } else {
            guard let cell
                = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCellID",
                                                     for: indexPath)
                    as? SettingMenuCollectionViewCell else {
                        return .init()
            }
            
            cell.configure(row: indexPath.row)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        view.endEditing(true)
        currentTextField?.resignFirstResponder()
        
        // 서비스 정보
        if indexPath == IndexPath(item: 0, section: 1) {
            navigationController?.pushViewController(ServiceInfoViewController(),
                                                     animated: true)
        } else if indexPath == IndexPath(item: 1, section: 1) {
            // 로그아웃
            let storyboard = UIStoryboard(name: "MyPageStoryBoard",
                                          bundle: nil)
            
            guard let logoutVC
                = storyboard.instantiateViewController(
                    withIdentifier: ViewControllerIdentifier.logoutViewController
                    ) as? LogoutViewController else {
                        return
            }
            
            navigationController?.pushViewController(logoutVC,
                                                     animated: true)
        } else if indexPath == IndexPath(item: 2, section: 1) {
            // 회원 탈퇴
            let storyboard = UIStoryboard(name: "MyPageStoryBoard",
                                          bundle: nil)
            
            guard let membershipCancelVC
                = storyboard.instantiateViewController(
                    withIdentifier: ViewControllerIdentifier.membershipCancelViewController
                    ) as? MembershipCancelViewController else {
                        return
            }
            
            navigationController?.pushViewController(membershipCancelVC,
                                                     animated: true)
        }
    }
}

extension AccountSettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 175)
        } else {
            return CGSize(width: view.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 90)
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
}
