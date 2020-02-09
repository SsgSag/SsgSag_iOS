//
//  ClubRegisterModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

class ClubRegisterModel {
    var clubType: ClubType
    var clubName = ""
    var univOrLocation = ""
    var oneLine = ""
    var category: [String] = []
    
    init(clubType: ClubType) {
        self.clubType = clubType
    }
}
