//
//  TapbarServiceImp.swift
//  SsgSag
//
//  Created by admin on 05/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class TabbarServiceImp: TabbarService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestValidateServer(completionHandler: @escaping (DataResponse<UpdateNetworkModel>) -> Void) {
        guard let url
            = UserAPI.sharedInstance.getURL(RequestURL.isUpdate.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: nil,
                                       body: nil) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(UpdateNetworkModel.self,
                                                   from: data)
                    
                    completionHandler(.success(decodedData))
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
