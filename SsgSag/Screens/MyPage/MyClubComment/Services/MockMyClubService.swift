//
//  MockMyClubService.swift
//  SsgSag
//
//  Created by bumslap on 08/03/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift

class MockMyClubService: MyClubServiceProtocol {
    func requestMyClubComments(page: Int) -> Observable<[MyClubComment]> {
        let comment = MyClubComment(clubIdx: 1, clubName: "테스트", clubPostIdx: 0, clubType: 0, clubStartDate: "", clubEndDate: "", oneLine: "", advantage: "", disadvantage: "", honeyTip: "", score0: 0, score1: 0, score2: 0, score3: 0, score4: 0, userIdx: 0, regDate: "2020.03.07", adminAccept: 0, isMine: 0, isLike: 0, likeNum: 0, userNickname: "")
        return .just([comment])
    }
}
