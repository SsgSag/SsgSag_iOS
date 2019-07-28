//
//  LoginServiceImp.swift
//  SsgSag
//
//  Created by admin on 21/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class LoginServiceImp: LoginService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    private(set) var isFetchStatusCode = false
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestSnsLogin(using accessToken: String,
                         type login: Int,
                         completionHandler: @escaping ((DataResponse<TokenResponse>) -> Void)) {
        
        //0 카톡 로그인, 1은 네이버 로그인(업데이트 예정)
        let json: [String: Any] = ["accessToken": accessToken,
                                   "loginType" : login]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard let url
            = UserAPI.sharedInstance.getURL(RequestURL.snsLogin.getRequestURL),
            let request = requestMaker.makeRequest(url: url,
                                                   method: .post,
                                                   header: ["Content-Type": "application/json"],
                                                   body: jsonData) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponse
                        = try JSONDecoder().decode(TokenResponse.self,
                                                   from: data)
                    
                    completionHandler(DataResponse.success(tokenResponse))
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
    
    func requestLogin(send data: [String : Any],
                      completionHandler: @escaping (DataResponse<LoginStruct>) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        guard let url
            = UserAPI.sharedInstance.getURL(RequestURL.login.getRequestURL),
            let request = requestMaker.makeRequest(url: url,
                                                   method: .post,
                                                   header: ["Content-Type": "application/json"],
                                                   body: jsonData) else {
                return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let login = try JSONDecoder().decode(LoginStruct.self, from: data)
                    
                    completionHandler(DataResponse.success(login))
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
