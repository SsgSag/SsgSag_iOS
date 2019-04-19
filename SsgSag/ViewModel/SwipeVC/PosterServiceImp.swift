//
//  PosterServiceImp.swift
//  SsgSag
//
//  Created by admin on 20/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class PosterServiceImp: PosterService {
    
    init() {
        
    }
    
    func requestPoster(completionHandler: @escaping (DataResponse<[Posters]>) -> Void) {
        
        let urlString = UserAPI.sharedInstance.getURL("/poster/show")
        
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        guard let tokenKey = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.addValue(tokenKey, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { (data, err, res) in
            guard let data = data else { return }
            
            do {
                let order = try JSONDecoder().decode(networkData.self, from: data)
                
                guard let posters = order.data?.posters else { return }
                
                completionHandler(DataResponse.success(posters))
            
            } catch {
                print("getPosterData JSON Parising Error")
            }
        }
        
    }

}

