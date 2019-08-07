//
//  FeedServiceImp.swift
//  SsgSag
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

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
        
        guard let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: nil,
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
                    let decodedData = try JSONDecoder().decode(Feed.self, from: data)
                    
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
    
}
