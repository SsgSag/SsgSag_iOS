//
//  FeedServiceTypeImp.swift
//  SsgSag
//
//  Created by bumslap on 29/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import SwiftKeychainWrapper

class FeedServiceTypeImp: FeedServiceProtocolType {
    
    private let requestMaker: RequestMakerProtocol = RequestMaker()
    private let network: RxNetwork = RxNetworkImp(session: URLSession.shared)
    
    func requestFeedData(page: Int) -> Observable<[FeedData]> {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.feed.getRequestURL
        urlComponent?.queryItems = [URLQueryItem(name: "curPage",
                                                        value: "\(page)")]
                  
        guard let token
                    = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        
                                        return .empty()
        }
                   
       return network
            .dispatch(request: request)
            .flatMapLatest { (data) -> Observable<[FeedData]> in
                if let feeds = try? JSONDecoder().decode(Feed.self,
                                                         from: data).data {
                    return .just(feeds)
                } else {
                    return .just([])
                }
        }
    }
    
    func requestScrapStore(feedIndex: Int) -> Observable<DataResponse<HttpStatusCode>> {
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
                                    
                                        return .empty()
        }
        return network
            .dispatch(request: request)
            .flatMapLatest { (data) -> Observable<DataResponse<HttpStatusCode>> in
                if let status = try? JSONDecoder().decode(Feed.self,
                                                         from: data).status {
                    guard let httpStatus = HttpStatusCode(rawValue: status) else { return .empty() }
                    return .just(DataResponse.success(httpStatus))
                } else {
                    return .just(DataResponse.failed(NSError()))
                }
        }
    }
    
    func requestScrapDelete(feedIndex: Int) -> Observable<DataResponse<HttpStatusCode>> {
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
                                        return .empty()
        }
        return network
        .dispatch(request: request)
        .flatMapLatest { (data) -> Observable<DataResponse<HttpStatusCode>> in
            if let status = try? JSONDecoder().decode(Feed.self,
                                                     from: data).status {
                guard let httpStatus = HttpStatusCode(rawValue: status) else { return .empty() }
                return .just(DataResponse.success(httpStatus))
            } else {
                return .just(DataResponse.failed(NSError()))
            }
        }
    }
    
    func requestScrapList(page: Int) -> Observable<[FeedData]> {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.feed.getRequestURL
        urlComponent?.queryItems = [URLQueryItem(name: "save",
                                                 value: "1"),
                                    URLQueryItem(name: "curPage",
                                                 value: "\(page)")]
        
         guard let token
                    = KeychainWrapper.standard.string(forKey: TokenName.token),
             let url = urlComponent?.url,
             let request
             = requestMaker.makeRequest(url: url,
                                        method: .get,
                                        header: ["Authorization": token],
                                        body: nil) else {
                                            return .empty()
         }
        return network
            .dispatch(request: request)
            .flatMapLatest { (data) -> Observable<[FeedData]> in
                if let feeds = try? JSONDecoder().decode(Feed.self,
                                                         from: data).data {
                    return .just(feeds)
                } else {
                    return .just([])
                }
        }
    }
    
    func requestFeedLookUp(posterIndex: Int) -> Observable<DataResponse<HttpStatusCode>> {
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
                                            return .empty()
         }
        
        return network
        .dispatch(request: request)
        .flatMapLatest { (data) -> Observable<DataResponse<HttpStatusCode>> in
            if let status = try? JSONDecoder().decode(Feed.self,
                                                     from: data).status {
                guard let httpStatus = HttpStatusCode(rawValue: status) else { return .empty() }
                return .just(DataResponse.success(httpStatus))
            } else {
                return .just(DataResponse.failed(NSError()))
            }
        }
    }
}
