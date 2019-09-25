//
//  LoginServiceImp.swift
//  SsgSag
//
//  Created by admin on 21/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import AdBrixRM

class LoginServiceImp: LoginService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestSnsLogin(using accessToken: String,
                         type login: Int,
                         completionHandler: @escaping ((DataResponse<TokenResponse>) -> Void)) {
        
        let json: [String: Any] = ["accessToken": accessToken,
                                   "loginType" : login]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard let url
            = UserAPI.sharedInstance.getURL(RequestURL.snsLogin.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
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
    
    func requestSelfLogin(send data: [String : Any],
                      completionHandler: @escaping (DataResponse<LoginStruct>) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        guard let url
            = UserAPI.sharedInstance.getURL(RequestURL.login.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .post,
                                       header: ["Content-Type": "application/json"],
                                       body: jsonData) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let login = try JSONDecoder().decode(LoginStruct.self,
                                                         from: data)
                    
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
    
    func requestTempPassword(email: String,
                             completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.tempPassword.getRequestURL
        urlComponent?.queryItems = [URLQueryItem(name: "userEmail",
                                                 value: email)]

        guard let url = urlComponent?.url,
            let request = requestMaker.makeRequest(url: url,
                                                   method: .post,
                                                   header: nil,
                                                   body: nil) else {
            completionHandler(.failed(NSError(domain: "request Error",
                                              code: 0,
                                              userInfo: nil)))
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(TempPassword.self,
                                                               from: data)
                    
                    guard let status = decodedData.status,
                        let httpStatusCode = HttpStatusCode(rawValue: status) else {
                        completionHandler(.failed(NSError(domain: "status Error",
                                                          code: 0,
                                                          userInfo: nil)))
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
    
    func requestAutoLogin(completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.autoLogin.getRequestURL
        
        let token
            = KeychainWrapper.standard.string(forKey: TokenName.token) ?? ""
        
        guard let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .post,
                                       header: ["Content-Type": "application/json",
                                                "Authorization": token],
                                       body: nil) else {
            completionHandler(.failed(NSError(domain: "request Error",
                                              code: 0,
                                              userInfo: nil)))
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(TempPassword.self,
                                                               from: data)
                    
                    guard let status = decodedData.status,
                        let httpStatusCode = HttpStatusCode(rawValue: status) else {
                            completionHandler(.failed(NSError(domain: "status Error",
                                                              code: 0,
                                                              userInfo: nil)))
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
