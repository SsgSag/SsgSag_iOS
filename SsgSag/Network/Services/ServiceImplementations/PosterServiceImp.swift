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
    
    func requestSwipePosters(completionHandler: @escaping (DataResponse<PosterData>) -> Void) {
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.initPoster.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let order = try JSONDecoder().decode(networkData.self,
                                                         from: data)
                    
                    guard let posterData = order.data else { return }
                    
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
    
    func requestPosterStore(of posterIdx: Int,
                            type likedCategory: likedOrDisLiked,
                            completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
        let like = likedCategory.rawValue
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.posterLiked(posterIdx: posterIdx,
                                                                   likeType: like).getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .post,
                                       header: ["Authorization": token],
                                       body: nil) else {
            return
        }
        network.dispatch(request: request) { result in
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
                    let response = try JSONDecoder().decode(PosterDetail.self,
                                                            from: data)
                    
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
    
    func requestPosterFavorite(index: Int,
                               method: HTTPMethod,
                               completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.favorite(posterIdx: index).getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: method,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(PosterDetail.self,
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
    
    func requestAllPosterAfterSwipe(category: Int,
                                    sortType: Int,
                                    interestType: Int? = nil,
                                    curPage: Int,
                                    completionHandler: @escaping (DataResponse<[PosterDataAfterSwpie]>) -> Void) {
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.allPoster(category: category,
                                                                 sortType: sortType,
                                                                 interestField: interestType,
                                                                 curPage: curPage).getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let order = try JSONDecoder().decode(PosterAfterSwipe.self,
                                                         from: data)
                    
                    guard let posterData = order.data else { return }
                    
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
    
    func requestStoredPoster(index: Int,
                             type likedCategory: likedOrDisLiked,
                             completionHandler: @escaping (DataResponse<PosterData>) -> Void) {
        let storedPosters = MockPosterStorage.shared.fetchPoster(type: likedCategory)
        let posters = PosterData(storedPosters, 0)
        completionHandler(.success(posters))
    }
}

