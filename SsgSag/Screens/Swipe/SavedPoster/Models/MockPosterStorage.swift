//
//  MockPosterStorage.swift
//  SsgSag
//
//  Created by bumslap on 09/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

class MockPosterStorage {
    private init() {}
    static let shared = MockPosterStorage()
    private var storage: [likedOrDisLiked: [Posters]] = [:]
    
    func store(type: likedOrDisLiked, poster: Posters) {
        guard let storedPosters = storage[type] else { return }
        let updateValue = Array([[poster], storedPosters].joined())
        storage.updateValue(updateValue, forKey: type)
    }
    
    func fetchPoster(type likedCategory: likedOrDisLiked) -> [Posters] {
        let posters = storage[likedCategory] ?? []
        return posters
    }
}
