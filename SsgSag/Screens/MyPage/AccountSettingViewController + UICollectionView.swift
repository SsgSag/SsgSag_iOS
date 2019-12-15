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
            return 6
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
            
            switch indexPath.item {
            case 0:
                // 닉네임
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "settingTextFieldCellID",
                                                         for: indexPath)
                        as? SettingTextFieldCollectionViewCell else {
                    return .init()
                }
                
                guard let userData = userData else {
                    return cell
                }
                
                guard let nickName = userData.userNickname else {
                    return cell
                }
                
                cell.setupCell(title: settingTitles[indexPath.row],
                               placeholder: "\(settingTitles[indexPath.row])을/를 입력해주세요",
                               text: nickName)
                cell.settingTextField.delegate = self
                cell.settingTextField.tag = indexPath.item
                
                return cell
            case 1:
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "settingTextFieldCellID",
                                                         for: indexPath)
                        as? SettingTextFieldCollectionViewCell else {
                            return .init()
                }
                
                guard let userData = userData else {
                    return cell
                }
                
                guard let email = userData.userEmail else {
                    return cell
                }
                
                cell.setupUnalterableCell(title: settingTitles[indexPath.row],
                                          data: email)
                cell.settingTextField.delegate = self
                cell.settingTextField.tag = indexPath.item
                return cell
            case 2:
                // 비밀번호
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "settingTextFieldCellID",
                                                         for: indexPath)
                        as? SettingTextFieldCollectionViewCell else {
                            return .init()
                }
                
                guard let userData = userData else {
                    return cell
                }
                cell.setupPasswordCell(title: settingTitles[indexPath.row],
                                       placeholder: "\(settingTitles[indexPath.row])을/를 입력해주세요",
                                       text: "**********")
                
                cell.delegate = self
                cell.settingTextField.delegate = self
                cell.settingTextField.tag = indexPath.item
                return cell
            case 3:
                // 학교, 학과
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "univSettingCell",
                                                         for: indexPath)
                        as? UnivCollectionViewCell else {
                            return .init()
                }
                
                guard let userData = userData else {
                    return cell
                }
                
                guard let univ = userData.userUniv,
                    let major = userData.userMajor else {
                    return cell
                }
                
                cell.univName = univ
                cell.majorTextField.text = major
                cell.univTextField.delegate = self
                cell.majorTextField.delegate = self
                cell.univTextField.tag = indexPath.item
                cell.majorTextField.tag = indexPath.item + 1
                
                return cell
            case 4:
                // 학번
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "studentNumberSettingCell",
                                                         for: indexPath)
                        as? StudentNumberCollectionViewCell else {
                            return .init()
                }
                
                guard let userData = userData else {
                    return cell
                }
                
                cell.studentNumberTextField.delegate = self
                cell.studentNumberTextField.tag = indexPath.item + 1
                
                guard let studentNum = Int(userData.userStudentNum ?? "") else {
                    return cell
                }
                
                cell.studentNumberTextField.text = studentNum < 10 ? "0\(studentNum)학번" : "\(studentNum)학번"
                
                guard let text = cell.studentNumberTextField.text else {
                    return cell
                }
                
                let year = Calendar.current.component(.year, from: Date())
                
                if studentNum == (year - 10) % 100 {
                    cell.studentNumberTextField.text = "~\(text)"
                }

                return cell
            case 5:
                // 학년
                guard let cell
                    = collectionView.dequeueReusableCell(withReuseIdentifier: "gradeSettingCell",
                                                         for: indexPath)
                        as? GradeCollectionViewCell else {
                            return .init()
                }
                
                guard let userData = userData else {
                    return cell
                }
                
                guard let studentNum = userData.userGrade else {
                    return cell
                }
                
                cell.gradeTextField.text = "\(studentNum)학년"
                cell.gradeTextField.delegate = self
                cell.gradeTextField.tag = indexPath.item + 1
                return cell
            default:
                return .init()
            }
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
            if (indexPath.item == 1 || indexPath.item == 2) && userData?.signupType == 0 {
                return CGSize(width: view.frame.width, height: 0)
            } else if indexPath.item == 3 {
                return CGSize(width: view.frame.width, height: 180)
            }
            
            return CGSize(width: view.frame.width, height: 90)
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
}
