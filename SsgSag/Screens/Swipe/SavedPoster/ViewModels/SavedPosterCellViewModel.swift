//
//  SavedPosterCellViewModel.swift
//  SsgSag
//
//  Created by bumslap on 09/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

class SavedPosterCellViewModel {
    let isLiked: Bool
    let poster: Posters
    
    init(isLiked: Bool, poster: Posters) {
        self.isLiked = isLiked
        self.poster = poster
    }
}
