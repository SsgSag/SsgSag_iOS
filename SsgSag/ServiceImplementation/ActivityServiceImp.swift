//
//  ActivityServiceImp.swift
//  SsgSag
//
//  Created by admin on 12/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ActivityServiceImp: ActivityService {
    
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
    
    func requestStoreActivity(_ jsonData: [String : Any],
                              completionHandler: @escaping (((DataResponse<Activity>) -> Void))) {
        
        let json = try? JSONSerialization.data(withJSONObject: jsonData)
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.careerActivity.getRequestURL),
            let request = requestMaker.makeRequest(url: url,
                                                   method: .post,
                                                   header: ["Authorization": token,
                                                            "Content-Type": "application/json"],
                                                   body: json) else {
                                                    return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(Activity.self,
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

    func requestEditActivity(_ jsonData: [String : Any],
                             completionHandler: @escaping ((DataResponse<Activity>) -> Void)) {
        let json = try? JSONSerialization.data(withJSONObject: jsonData)
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.careerActivity.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .put,
                                       header: ["Authorization": token,
                                                "Content-Type": "application/json"],
                                       body: json) else {
                                        return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(Activity.self,
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
    
    
    func requestDeleteActivity(contentIdx: Int,
                               completionHandler: @escaping ((DataResponse<Activity>) -> Void)) {
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.deleteAcitivity(careerIdx: contentIdx).getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .delete,
                                       header: ["Authorization": token,
                                                "Content-Type": "application/json"],
                                       body: nil) else {
                return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(Activity.self,
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
