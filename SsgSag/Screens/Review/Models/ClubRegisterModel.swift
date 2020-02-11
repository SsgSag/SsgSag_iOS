//
//  ClubRegisterModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

class ClubRegisterModel {
    var isReviewExist = false
    var clubIdx = -1
    //one step
    var clubType: ClubType
    var clubName = ""
    var univOrLocation = ""
    var oneLine = ""
    var category: [String] = []
    //two step
    var activeMember = ""
    var meetTime = ""
    var fee = ""
    var webSite = ""
    var introduce = ""
    var photoUrlList: [String] = []
    //three step
    var email = ""
    var phone = ""
    
    init(clubType: ClubType) {
        self.clubType = clubType
    }
   
}
