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
    private init() {}
    static let shared = ClubService()
    
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
        print(url)
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
}

