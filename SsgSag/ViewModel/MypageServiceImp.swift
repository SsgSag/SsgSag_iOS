//
//  MypageServiceImp.swift
//  SsgSag
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol MyPageService: class {
    
    func requestSelectedState(completionHandler: @escaping ((DataResponse<Interests>) -> Void))
    
    func requestStoreSelectedField(_ selectedJson: [String: Any] ,
                                   completionHandler: @escaping ((DataResponse<ReInterest>) -> Void))
    
    func requestStoreAddActivity(_ jsonData: [String: Any],
                                 completionHandler: @escaping ((DataResponse<Activity>) -> Void))
    
    func reqeuestStoreJobsState(_ selectedJson: [String: Any] ,
                                completionHandler: @escaping ((DataResponse<ReInterest>) -> Void))
    
    func requestUserInformation(completionHandler: @escaping (DataResponse<UserNetworkModel>) -> Void)
    
    func requestMembershipCancel(completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void)
}

class MyPageServiceImp: MyPageService {
    
    func reqeuestStoreJobsState(_ selectedJson: [String : Any],
                                completionHandler: @escaping ((DataResponse<ReInterest>) -> Void)) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.registerInterestJobs.getRequestURL) else {
            return
        }
        
        guard let token = UserDefaults.standard.object(forKey: TokenName.token) as? String else {
            return
        }
        
        let json = try? JSONSerialization.data(withJSONObject: selectedJson)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = json
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else {return}
            
            do {
                let responseData = try JSONDecoder().decode(ReInterest.self, from: data)
                
                completionHandler(DataResponse.success(responseData))
            } catch {
                print("ReInterest Parsing Error")
            }
        }
    }
    
    func requestStoreAddActivity(_ jsonData: [String : Any],
                                 completionHandler: @escaping (((DataResponse<Activity>) -> Void))) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.careerActivity.getRequestURL) else {return}
        
        
        guard let token = UserDefaults.standard.object(forKey: TokenName.token) as? String else {
            return
        }
        
        let json = try? JSONSerialization.data(withJSONObject: jsonData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = json
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            
            guard let data = data else {return}
            
            do {
                let responsData = try JSONDecoder().decode(Activity.self, from: data)
                
                completionHandler(DataResponse.success(responsData))
            } catch {
                completionHandler(DataResponse.failed(ReadError.JsonError))
            }

        }
    }

    func requestStoreSelectedField(_ selectedJson: [String : Any],
                                   completionHandler: @escaping ((DataResponse<ReInterest>) -> Void)) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: selectedJson)
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.reIntersting.getRequestURL) else {return}
        
        guard let token = UserDefaults.standard.object(forKey: TokenName.token) as? String else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            
            guard let data = data else {
                return
            }
            
            do {
                let apiRespoonse = try JSONDecoder().decode(ReInterest.self, from: data)
                
                completionHandler(DataResponse.success(apiRespoonse))
            } catch {
                completionHandler(DataResponse.failed(ReadError.JsonError))
            }
        }
    }
    
    func requestSelectedState(completionHandler: @escaping ((DataResponse<Interests>) -> Void)) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.interestingField.getRequestURL) else {
            return print("123123")
        }
        
        guard let token = UserDefaults.standard.object(forKey: TokenName.token) as? String else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            
            guard let data = data else {
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(Interests.self, from: data)
                
                completionHandler(DataResponse.success(apiResponse))
                
            } catch  {
                print("Interests Json Parsing Error")
            }
            
        }
    }
    
    func requestUserInformation(completionHandler: @escaping (DataResponse<UserNetworkModel>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.signUp.getRequestURL) else {
            return
        }
        
        guard let token = UserDefaults.standard.object(forKey: TokenName.token) as? String else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { (data, error, res) in
            
            guard let data = data else {
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(UserNetworkModel.self, from: data)
                
                completionHandler(DataResponse.success(apiResponse))
                
            } catch  {
                print("Interests Json Parsing Error")
            }
            
        }
    }
    
    // 회원탈퇴
    func requestMembershipCancel(completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.signUp.getRequestURL),
            let token = UserDefaults.standard.object(forKey: TokenName.token) as? String else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(UserNetworkModel.self, from: data)
                
                guard let status = response.status,
                    let httpStatusCode = HttpStatusCode(rawValue: status) else { return }
                
                completionHandler(DataResponse.success(httpStatusCode))
            } catch {
                print("membershipCancel Json Parsing Error")
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
