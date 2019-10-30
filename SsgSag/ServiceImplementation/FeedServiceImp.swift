//
//  FeedServiceImp.swift
//  SsgSag
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class FeedServiceImp: FeedService {
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestFeedData(completionHandler: @escaping (DataResponse<[FeedData]>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.feed.getRequestURL
       
        guard let token
                   = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: ["Authorization": token],
                                       body: nil) else {
            completionHandler(.failed(NSError(domain: "request error",
                                              code: 0,
                                              userInfo: nil)))
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(Feed.self,
                                                               from: data)
                    
                    guard let feedDatas = decodedData.data else {
                        completionHandler(.failed(NSError(domain: "request error",
                                                          code: 0,
                                                          userInfo: nil)))
                        return
                    }
                    
                    completionHandler(.success(feedDatas))
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
    
    func requestScrapStore(feedIndex: Int,
                           completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.scrap(index: feedIndex).getRequestURL
        
        
        guard let token
        = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .post,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        completionHandler(.failed(NSError(domain: "request error",
                                                                          code: 0,
                                                                          userInfo: nil)))
                                        return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(Feed.self,
                                                               from: data)
                    
                    guard let status = decodedData.status,
                        let httpStatusCode = HttpStatusCode(rawValue: status) else {
                            return
                    }
                    
                    completionHandler(DataResponse.success(httpStatusCode))
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
    
    func requestScrapDelete(feedIndex: Int,
                            completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.scrap(index: feedIndex).getRequestURL
        
        guard let token
        = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .delete,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        completionHandler(.failed(NSError(domain: "request error",
                                                                          code: 0,
                                                                          userInfo: nil)))
                                        return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(Feed.self,
                                                               from: data)
                    
                    guard let status = decodedData.status,
                        let httpStatusCode = HttpStatusCode(rawValue: status) else {
                            return
                    }
                    
                    completionHandler(DataResponse.success(httpStatusCode))
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
    
    func requestScrapList(completionHandler: @escaping (DataResponse<[FeedData]>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.feed.getRequestURL
        urlComponent?.queryItems = [URLQueryItem(name: "save",
                                                 value: "1")]
        
         guard let token
                    = KeychainWrapper.standard.string(forKey: TokenName.token),
             let url = urlComponent?.url,
             let request
             = requestMaker.makeRequest(url: url,
                                        method: .get,
                                        header: ["Authorization": token],
                                        body: nil) else {
             completionHandler(.failed(NSError(domain: "request error",
                                               code: 0,
                                               userInfo: nil)))
             return
         }
         
         network.dispatch(request: request) { result in
             switch result {
             case .success(let data):
                 do {
                     let decodedData = try JSONDecoder().decode(Feed.self,
                                                                from: data)
                     
                     guard let feedDatas = decodedData.data else {
                         completionHandler(.failed(NSError(domain: "request error",
                                                           code: 0,
                                                           userInfo: nil)))
                         return
                     }
                     
                     completionHandler(.success(feedDatas))
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
    
    func requestFeedLookUp(posterIndex: Int,
                           completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.feedLookUp(posterIndex: posterIndex).getRequestURL
        
         guard let token
                    = KeychainWrapper.standard.string(forKey: TokenName.token),
             let url = urlComponent?.url,
             let request
             = requestMaker.makeRequest(url: url,
                                        method: .get,
                                        header: ["Authorization": token],
                                        body: nil) else {
             completionHandler(.failed(NSError(domain: "request error",
                                               code: 0,
                                               userInfo: nil)))
             return
         }
         
         network.dispatch(request: request) { result in
             switch result {
             case .success(let data):
                 do {
                     let decodedData = try JSONDecoder().decode(FeedLookUp.self,
                                                                from: data)
                     
                     guard let status = decodedData.status,
                         let httpStatusCode = HttpStatusCode(rawValue: status) else {
                             return
                     }
                     
                     completionHandler(DataResponse.success(httpStatusCode))
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
