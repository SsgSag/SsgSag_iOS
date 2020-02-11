//
//  ClubRegisterModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

class ClubRegisterModel {
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
    var photoDatas: [Data] = []
    //three step
    var email = ""
    var phone = ""
    
    init(clubType: ClubType) {
        self.clubType = clubType
    }
   
}
