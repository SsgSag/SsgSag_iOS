//
//  PosterServiceImp.swift
//  SsgSag
//
//  Created by admin on 20/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class PosterServiceImp: PosterService {
    
    func requestPosterLiked(of poster: Posters, type likedCategory: likedOrDisLiked ) {
        
        let like = likedCategory.rawValue
        
        guard let posterIdx = poster.posterIdx else { return }
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.posterLiked(posterIdx: posterIdx, likeType: like).getRequestURL()) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(key, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
            
                let likedPosterNetworkData = try JSONDecoder().decode(PosterFavoriteForNetwork.self, from: data)
                
                guard let statusCode = likedPosterNetworkData.status else { return }
                
                guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else { return }
                
                do {
                    try self.likedErrorHandling(httpStatusCode, likedCategory: likedCategory)
                } catch HttpStatusCode.dataBaseError {
                    print("likedPosterNetworkData dataBaseError")
                } catch HttpStatusCode.serverError {
                    print("likedPosterNetworkData serverError")
                }
                
            } catch {
                print("likedPosterNetworkData parsing Error")
            }
        }
    }
    
    func likedErrorHandling(_ httpStatusCode: HttpStatusCode, likedCategory: likedOrDisLiked) throws {
        switch httpStatusCode {
        case .sucess:
            if likedCategory == .liked {
                print("posterFavorite liked is Send to Server")
            } else if likedCategory == .disliked {
                print("posterFavorite Disliked is Send to Server")
            }
        case .dataBaseError, .serverError:
            try httpStatusCode.throwError()
        default:
            break
        }
    }

    init() {
        
    }
    
    func requestPoster(completionHandler: @escaping (DataResponse<[Posters]>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.initPoster.getRequestURL()) else {return}
    
        guard let tokenKey = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else {
            return
        }
        
        var request = URLRequest(url: url)
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

