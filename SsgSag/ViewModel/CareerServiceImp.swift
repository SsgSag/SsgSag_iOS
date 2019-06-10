//
//  CareerServiceImp.swift
//  SsgSag
//
//  Created by admin on 21/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol CareerService {
    func requestCareer(careerType:Int, completionHandler: @escaping (DataResponse<Career>) -> Void)
}

class CareerServiceImp: CareerService {
    
    func requestCareer(careerType: Int, completionHandler: @escaping (DataResponse<Career>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.career(careerType: careerType).getRequestURL) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(key, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            guard let data = data else {return}
            
            do {
                let networkData = try JSONDecoder().decode(Career.self, from: data)
                
                completionHandler(DataResponse.success(networkData))
                
            } catch {
                print("requestCareer Json Parsing Error")
            }
        }
    }
    
}
