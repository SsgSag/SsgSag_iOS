//
//  StoreAndFetchPoster.swift
//  SsgSag
//
//  Created by admin on 06/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class StoreAndFetchPoster {
    
    var isChanged: Bool = false
    
    public static let shared = StoreAndFetchPoster()
    
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
    
    /// 어떠한 상황에 userdefaults가 바뀌었다면 새로 유저디폴츠에서 꺼내고 아니라면 기존에 로드된 데이터를 사용한다.
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
            
            return posters ?? []
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

