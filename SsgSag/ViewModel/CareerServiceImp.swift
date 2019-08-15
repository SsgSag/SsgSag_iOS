//
//  CareerServiceImp.swift
//  SsgSag
//
//  Created by admin on 21/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class CareerServiceImp: CareerService {
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestCareerWith(careerType: Int,
                           completionHandler: @escaping (DataResponse<Career>) -> Void) {
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.career(careerType: careerType).getRequestURL),
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
                    let decodedData
                        = try JSONDecoder().decode(Career.self,
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
    
    func requestCareerWith(body: [String: Any],
                           completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        // create post request
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.careerActivity.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .post,
                                       header: ["Authorization": token,
                                                "Content-Type": "application/json"],
                                       body: jsonData) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(Career.self,
                                                   from: data)
                    
                    guard let httpStatusCode
                        = HttpStatusCode(rawValue: decodedData.status) else {
                            completionHandler(.failed(NSError(domain: "status error",
                                                              code: 0,
                                                              userInfo: nil)))
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
    
}
