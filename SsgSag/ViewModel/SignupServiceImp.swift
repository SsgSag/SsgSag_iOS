//
//  SignupServiceImp.swift
//  SsgSag
//
//  Created by admin on 19/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class SignupServiceImp: SignupService {
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestValidateEmail(urlString: String,
                             completionHandler: @escaping (DataResponse<HttpStatusCode>, Bool) -> Void) {
        
        guard let url
            = UserAPI.sharedInstance.getURL(urlString),
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
                    let decodedData
                        = try JSONDecoder().decode(EmailValidate.self,
                                                   from: data)
                    
                    guard let httpStatusCode = decodedData.status,
                        let status = HttpStatusCode(rawValue: httpStatusCode),
                        let isValidate = decodedData.data else {
                            return
                    }
                    
                    completionHandler(.success(status), isValidate)
                } catch let error {
                    completionHandler(.failed(error), false)
                    return
                }
            case .failure(let error):
                completionHandler(.failed(error), false)
                return
            }
        }
    }
    
    func requestSingup(_ userInfo: Data,
                       completionHandler: @escaping (DataResponse<Signup>) -> Void) {
        guard let url
            = UserAPI.sharedInstance.getURL(RequestURL.signUp.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .post,
                                       header: ["Content-Type": "application/json"],
                                       body: nil) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(Signup.self,
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

