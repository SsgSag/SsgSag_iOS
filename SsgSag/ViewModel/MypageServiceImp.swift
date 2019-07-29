//
//  MypageServiceImp.swift
//  SsgSag
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class MyPageServiceImp: MyPageService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func reqeuestStoreJobsState(_ selectedJson: [String : Any],
                                completionHandler: @escaping ((DataResponse<ReInterest>) -> Void)) {
        
        let json = try? JSONSerialization.data(withJSONObject: selectedJson)
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.registerInterestJobs.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
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
                        = try JSONDecoder().decode(ReInterest.self,
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
    
    func requestStoreAddActivity(_ jsonData: [String : Any],
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

    func requestStoreSelectedField(_ selectedJson: [String : Any],
                                   completionHandler: @escaping ((DataResponse<ReInterest>) -> Void)) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: selectedJson)
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.reIntersting.getRequestURL),
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
                        = try JSONDecoder().decode(ReInterest.self,
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
    
    func requestSelectedState(completionHandler: @escaping ((DataResponse<Interests>) -> Void)) {
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.interestingField.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
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
                        = try JSONDecoder().decode(Interests.self,
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
    
    func requestUserInformation(completionHandler: @escaping (DataResponse<UserNetworkModel>) -> Void) {
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.signUp.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
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
                        = try JSONDecoder().decode(UserNetworkModel.self,
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
    
    // 회원탈퇴
    func requestMembershipCancel(completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.signUp.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .delete,
                                       header: ["Authorization": token],
                                       body: nil) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(UserNetworkModel.self,
                                                   from: data)
                    
                    guard let status = decodedData.status,
                        let httpStatusCode = HttpStatusCode(rawValue: status) else {
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


enum ReadError: Error {
    case JsonError
    
    func printErrorType() {
        switch self {
        case .JsonError:
            print("addActivity Json Parsing Error")
        }
    }
}
