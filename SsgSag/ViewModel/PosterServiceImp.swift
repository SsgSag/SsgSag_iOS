//
//  PosterServiceImp.swift
//  SsgSag
//
//  Created by admin on 20/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class PosterServiceImp: PosterService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestPosterLiked(of poster: Posters,
                            type likedCategory: likedOrDisLiked) {
        
        let like = likedCategory.rawValue
        
        guard let posterIdx = poster.posterIdx else { return }
        
        guard let token = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        guard let url
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
                    let likedPosterNetworkData = try JSONDecoder().decode(PosterFavoriteForNetwork.self, from: data)
                    
                    guard let statusCode = likedPosterNetworkData.status else { return }
                    
                    guard let httpStatusCode = HttpStatusCode(rawValue: statusCode) else { return }
                    
                    do {
                        try self?.likedErrorHandling(httpStatusCode, likedCategory: likedCategory)
                    } catch HttpStatusCode.dataBaseError {
                        print("likedPosterNetworkData dataBaseError")
                    } catch HttpStatusCode.serverError {
                        print("likedPosterNetworkData serverError")
                    }
                    
                } catch {
                    print("likedPosterNetworkData parsing Error")
                    return
                }
            case .failure(let error):
                print(error)
                return
            }
        }
        
    }
    
    func likedErrorHandling(_ httpStatusCode: HttpStatusCode,
                            likedCategory: likedOrDisLiked) throws {
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
    
    func requestPoster(completionHandler: @escaping (DataResponse<[Posters]>) -> Void) {
        
        guard let token
            = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        guard let url
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
            = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        guard let url
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

