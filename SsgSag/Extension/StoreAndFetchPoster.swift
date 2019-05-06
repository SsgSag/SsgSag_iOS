//
//  StoreAndFetchPoster.swift
//  SsgSag
//
//  Created by admin on 06/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

struct StoreAndFetchPoster {
    
    static func storePoster(posters: [Posters]) {
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(posters), forKey: "poster")
    }
    
    static var getPoster: [Posters] {
        
        guard let poster = UserDefaults.standard.object(forKey: "poster") as? Data else{ return
            []
        }
        
        guard let storedPosters = try? PropertyListDecoder().decode([Posters].self, from: poster) else {
            return []
        }
        
        return storedPosters
    }
    
}
