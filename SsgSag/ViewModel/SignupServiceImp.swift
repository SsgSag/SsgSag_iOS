//
//  SignupServiceImp.swift
//  SsgSag
//
//  Created by admin on 19/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol SignupService: class {
    func requestSingup(_ userInfo: Data, completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void)
}

class SignupServiceImp: SignupService {
    
    func requestSingup(_ userInfo: Data, completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.signUp.getRequestURL()) else {return}
        
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

