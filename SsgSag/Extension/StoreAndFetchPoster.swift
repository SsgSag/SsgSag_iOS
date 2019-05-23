//
//  StoreAndFetchPoster.swift
//  SsgSag
//
//  Created by admin on 06/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class StoreAndFetchPoster {
    
    public static let shared = StoreAndFetchPoster()
    
    var isChanged: Bool = false
    
    private var data: Data?
    
    private var posters: [Posters]?

    private init() {
        
        guard let datas = UserDefaults.standard.object(forKey: UserDefaultsName.poster) as? Data else{
            self.data = nil
            self.posters = nil
            return
        }
        
        guard let storedPosters = try? PropertyListDecoder().decode([Posters].self, from: datas) else {
            self.data = datas
            self.posters = nil
            return
        }
        
        self.data = datas
        self.posters = storedPosters
    }
    
    // FIXME: 변화될 상황에 대해서만 isChanged를 바꾸어 주면된다.
    func getPostersAfterAllChangedConfirm() -> [Posters] {
        if isChanged {
            isChanged = false
            guard let poster = UserDefaults.standard.object(forKey: UserDefaultsName.poster) as? Data else{ return
                []
            }
            
            guard let storedPosters = try? PropertyListDecoder().decode([Posters].self, from: poster) else {
                return []
            }
            
            self.posters = storedPosters
            
            return storedPosters
        } else {
            guard let result = self.posters else { return [] }
            return result
        }
    }

    func storePoster(posters: [Posters]) {
        isChanged = true
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(posters), forKey: UserDefaultsName.poster)
    }
    
}

//enum StoreAndFetchPoster {
//
//    static var tempPosters: [Posters] {
//        return
//    }
//
//    static func storePoster(posters: [Posters]) {
//        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(posters), forKey: UserDefaultsName.poster)
//    }
//
//    static var getPoster: [Posters] {
//
//        guard let poster = UserDefaults.standard.object(forKey: UserDefaultsName.poster) as? Data else{ return
//            []
//        }
//
//        guard let storedPosters = try? PropertyListDecoder().decode([Posters].self, from: poster) else {
//            return []
//        }
//
//        return storedPosters
//    }
//
//    static var getPosterWhenUserDefaultsIsNotChange: [Posters] {
//        self.getPoster
//    }
//}
