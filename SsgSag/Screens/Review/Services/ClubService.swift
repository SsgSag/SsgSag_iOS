//
//  ClubService.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class ClubService: ClubServiceProtocol {
//    private init() {}
//    static let shared = ClubService()
    private let requestMaker: RequestMakerProtocol = RequestMaker()
    private let network: Network = NetworkImp()
    
    //http://13.209.77.133:8082
    func requestClubList(curPage: Int, completion: @escaping (([ClubListData]?) -> Void)) {
        let baseURL = "http://13.209.77.133:8082"
        let path = RequestURL.clubList(curPage: curPage).getRequestURL
        let url = baseURL + path
        let token = TokenName.tokenString
        let header: HTTPHeaders = [
           "Authorization" : token
       ]

        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let object = try decoder.decode(Clubs.self, from: data)
                    
                    if object.status == 200 {
                        completion(object.data)
                    } else {
                        print("ClubListErr: \(object.message ?? "")")
                        completion(nil)
                    }
                    
                } catch (let err) {
                    print(err.localizedDescription)
                    completion(nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func requestClubInfo(clubIdx: Int, completion: @escaping (ClubInfo?) -> Void) {
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.clubInfo(clubIdx: clubIdx).getRequestURL
        let url = baseURL + path
        let token = TokenName.tokenString
        let header: HTTPHeaders = [
            "Authorization" : token
        ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let object = try decoder.decode(Club.self, from: data)
                    
                    if object.status == 200 {
                        completion(object.data)
                    } else {
                        print("ClubInfoErr: \(object.message ?? "")")
                        completion(nil)
                    }
                    
                } catch (let err) {
                    print(err.localizedDescription)
                    completion(nil)
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func requestClubWithName(clubType: ClubType, location: String, keyword: String, curPage: Int, completion: @escaping ([ClubListData]?) -> Void) {
        
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.searchClubWithName(clubType: clubType, location: location, keyword: keyword, curPage: curPage).getRequestURL
        guard let urlString = (baseURL + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string:  urlString) else {return}
        let token = TokenName.tokenString
        let header: HTTPHeaders = [
            "Authorization" : token
        ]
        
        guard let request = requestMaker.makeRequest(url: url, method: .get, header: header, body: nil) else {return}
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(Clubs.self, from: data) {
                    completion(object.data)
                } else {
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func requestNotMemberClubRegister(admin: Int, name: String, phone: String, completion: @escaping (Bool) -> Void) {
        
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.notMemberClubRegister.getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        let token = TokenName.tokenString
        let header: HTTPHeaders = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        let body: Parameters = [
            "isAdmin": admin,
            "adminName": name,
            "adminCallNum": phone
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        guard let request = requestMaker.makeRequest(url: url, method: .post, header: header, body: jsonData) else {return}
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(Club.self, from: data) {
                    if object.status == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
}

