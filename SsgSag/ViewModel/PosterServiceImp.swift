//
//  PosterServiceImp.swift
//  SsgSag
//
//  Created by admin on 20/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class PosterServiceImp: PosterService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestPosterLiked(of poster: Posters,
                            type likedCategory: likedOrDisLiked,
                            completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
        let like = likedCategory.rawValue
        
        guard let posterIdx = poster.posterIdx else { return }
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.posterLiked(posterIdx: posterIdx,
                                                                   likeType: like).getRequestURL),
            let request = requestMaker.makeRequest(url: url,
                                                   method: .post,
                                                   header: ["Authorization": token],
                                                   body: nil) else {
            return
        }
        
        network.dispatch(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(PosterFavoriteForNetwork.self,
                                                   from: data)
                    
                    guard let statusCode = decodedData.status,
                        let httpStatusCode = HttpStatusCode(rawValue: statusCode) else {
                            return
                    }
                    
                    completionHandler(.success(httpStatusCode))
                    
                } catch let error {
                    completionHandler(.failed(error))
                    return
                }
            case .failure(let error):
                completionHandler(.failed(error))
                return
            }
        }
        
    }
    
    func requestPoster(completionHandler: @escaping (DataResponse<[Posters]>) -> Void) {
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.initPoster.getRequestURL),
            let request = requestMaker.makeRequest(url: url,
                                                   method: .get,
                                                   header: ["Authorization": token],
                                                   body: nil) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let order = try JSONDecoder().decode(networkData.self, from: data)
                    
                    guard let posters = order.data?.posters else { return }
                    
                    completionHandler(.success(posters))
                    
                } catch let error {
                    completionHandler(.failed(error))
                    return
                }
            case .failure(let error):
                completionHandler(.failed(error))
                return
            }
        }
    }
    
    func requestPosterDetail(posterIdx: Int,
                             completionHandler: @escaping (DataResponse<DataClass>) -> Void) {
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.posterDetail(posterIdx: posterIdx).getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: ["Authorization": token,
                                                "Content-Type": "application/json"],
                                       body: nil) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(PosterDetail.self, from: data)
                    
                    guard let posterData = response.data else { return }
                    
                    completionHandler(.success(posterData))
                    
                } catch let error {
                    completionHandler(.failed(error))
                    return
                }
            case .failure(let error):
                completionHandler(.failed(error))
                return
            }
        }
    }
}

