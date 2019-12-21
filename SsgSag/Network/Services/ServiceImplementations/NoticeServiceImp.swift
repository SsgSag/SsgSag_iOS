//
//  NoticeServiceImp.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class NoticeServiceImp: NoticeService {
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestNotice(completionHandler: @escaping (DataResponse<[NoticeData]>) -> Void) {
        
        guard let url
            = UserAPI.sharedInstance.getURL(RequestURL.notice.getRequestURL),
            let requset
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: nil,
                                       body: nil) else {
            return
        }
        
        network.dispatch(request: requset) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(Notice.self, from: data)
                    
                    guard let noticeList = decodedData.data else { return }
                    
                    completionHandler(.success(noticeList))
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
