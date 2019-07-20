//
//  SignupServiceImp.swift
//  SsgSag
//
//  Created by admin on 19/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol SignupService: class {
    func requestValidateEmail(urlString: String,
                             completionHandler: @escaping (DataResponse<HttpStatusCode>, Bool) -> Void)
    
    func requestSingup(_ userInfo: Data,
                       completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void)
}

class SignupServiceImp: SignupService {
    func requestValidateEmail(urlString: String,
                             completionHandler: @escaping (DataResponse<HttpStatusCode>, Bool) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            
            guard let data = data else {
                return
            }
            
            do {
                let validateNetworkModel
                    = try JSONDecoder().decode(EmailValidate.self,
                                               from: data)
            
                guard let httpStatusCode = validateNetworkModel.status,
                    let status = HttpStatusCode(rawValue: httpStatusCode),
                    let isValidate = validateNetworkModel.data else {
                    return
                }
        
                completionHandler(DataResponse.success(status), isValidate)
            } catch {
                print("Email Duplicate Parsing Error")
            }
        }
    }
    
    func requestSingup(_ userInfo: Data,
                       completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.signUp.getRequestURL) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = userInfo
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else {return}
            
            do {
                let dataByNetwork = try JSONDecoder().decode(BasicNetworkModel.self, from: data)
                
                completionHandler(DataResponse.success(dataByNetwork))
            } catch {
                print("requestSingup Json Parsing")
            }
            
        }
    }
    
}

