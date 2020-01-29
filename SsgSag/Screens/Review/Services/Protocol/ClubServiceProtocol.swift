//
//  ClubServiceProtocol.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/27.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

protocol ClubServiceProtocol {
    
    //동아리 후기 전체목록
    func requestClubList(curPage: Int, completion: @escaping (([ClubListData]?) -> Void))
    
    //동아리 상세 정보
    func requestClubInfo(clubIdx: Int, completion: @escaping (ClubInfo?) -> Void)
}
