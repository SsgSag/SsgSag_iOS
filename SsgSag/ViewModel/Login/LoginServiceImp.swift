//
//  LoginServiceImp.swift
//  SsgSag
//
//  Created by admin on 21/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class LoginServiceImp: LoginService {
    func requestSnsLogin(using accessToken: String, type login: Int,
                         completionHandler: @escaping ((DataResponse<TokenResponse>) -> Void)) {
        
        //0 카톡 로그인, 1은 네이버 로그인(업데이트 예정)
        let json: [String: Any] = [ "accessToken": accessToken,
                                    "loginType" : login ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.snsLogin.getRequestURL()) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            guard let data = data else { return }
            
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                
                completionHandler(DataResponse.success(tokenResponse))
            } catch {
                print("LoginService Parsing Error")
            }
        }
    }
    
    
    func requestLogin(send data: [String : Any], completionHandler: @escaping (DataResponse<LoginStruct>) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.login.getRequestURL()) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, err, res) in
            guard let data = data else { return }
            do {
                let login = try JSONDecoder().decode(LoginStruct.self, from: data)
                
                completionHandler(DataResponse.success(login))
                
            } catch {
                print("LoginStruct Parsing Error")
            }
        }
    }
    
    
    
    
}
