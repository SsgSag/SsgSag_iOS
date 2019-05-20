//
//  InterestServiceImp.swift
//  SsgSag
//
//  Created by admin on 18/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol InterestService: class {
    func requestInterestSubscribe(completionHandler: @escaping (DataResponse<Subscribe>) -> Void)
    
    func requestInterestSubscribeDelete(_ interedIdx: Int,
                                        completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void)
    
    func requestInterestSubscribeAdd(_ interedIdx: Int,
                                     completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void)
}

class InterestServiceManager: InterestService {
    func requestInterestSubscribeDelete(_ interedIdx: Int,
                                        completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.subscribeAddOrDelete(interestIdx: interedIdx).getRequestURL()) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(key, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else {return}
            
            do {
                let dataByNetwork = try JSONDecoder().decode(BasicNetworkModel.self, from: data)
                
                completionHandler(DataResponse.success(dataByNetwork))
            } catch {
                print("requestInterestSubscribeDelete Json Parsing")
            }
        }
    }
    
    func requestInterestSubscribeAdd(_ interedIdx: Int,
                                     completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.subscribeAddOrDelete(interestIdx: interedIdx).getRequestURL()) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(key, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else {return}
            
            do {
                let dataByNetwork = try JSONDecoder().decode(BasicNetworkModel.self, from: data)
                
                completionHandler(DataResponse.success(dataByNetwork))
            } catch {
                print("requestInterestSubscribeAdd Json Parsing")
            }
        }
    }
    
    func requestInterestSubscribe(completionHandler: @escaping (DataResponse<Subscribe>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.subscribeInterest.getRequestURL()) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(key, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else {return}
            
            do {
                let dataByNetwork = try JSONDecoder().decode(Subscribe.self, from: data)
                
                completionHandler(DataResponse.success(dataByNetwork))
            } catch {
                print("InterestServiceManager Json Parsing")
            }
        }
        
    }
    
    
}
