//
//  ReviewService.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/07.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class ReviewService: ReviewServiceProtocol {
    private let requestMaker: RequestMakerProtocol = RequestMaker()
    private let network: Network = NetworkImp()
    
    func requestExistClubReviewPost(model: ClubActInfoModel, completion: @escaping (ReviewRegister?) -> Void) {
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.registerReview.getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        
        let header: [String : String] = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        let body: [String : Any] = [
            "clubStartDate": model.startRequestDate,
            "clubEndDate": model.endRequestDate,
            "score0": model.recommendScore,
            "score1": model.proScore,
            "score2": model.funScore,
            "score3": model.hardScore,
            "score4": model.friendScore,
            "oneLine": model.oneLineString,
            "advantage": model.advantageString,
            "disadvantage": model.disadvantageString,
            "honeyTip": model.honeyString,
            "clubIdx": model.clubIdx
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        guard let request = requestMaker.makeRequest(url: url, method: .post, header: header, body: jsonData) else {return}
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseSimpleResult<ReviewRegister>.self, from: data) {
                    
                    if object.status == 200 {
                        guard let data = object.data else {
                            completion(nil)
                            return
                        }
                        completion(data)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func requestNonExistClubReviewPost(model: ClubActInfoModel, completion: @escaping (ReviewRegister?) -> Void) {
        
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.registerReview.getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        
        let header: [String : String] = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        let type = model.clubType == .Union ? 0 : 1
        let univOrLocation: String = model.clubType == .Union ? model.location.value : model.univName
        let body: [String : Any] = [
            "clubType": type,
            "univOrLocation": univOrLocation,
            "clubName": model.clubName,
            "categoryList": model.categoryListToString(),
            "clubStartDate": model.startRequestDate,
            "clubEndDate": model.endRequestDate,
            "score0": model.recommendScore,
            "score1": model.proScore,
            "score2": model.funScore,
            "score3": model.hardScore,
            "score4": model.friendScore,
            "oneLine": model.oneLineString,
            "advantage": model.advantageString,
            "disadvantage": model.disadvantageString,
            "honeyTip": model.honeyString
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        guard let request = requestMaker.makeRequest(url: url, method: .post, header: header, body: jsonData) else {return}
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseSimpleResult<ReviewRegister>.self, from: data) {
                    if object.status == 200 {
                        guard let data = object.data else {
                            completion(nil)
                            return
                        }
                        completion(data)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func requestReviewList(clubIdx: Int, curPage: Int, completion: @escaping ([ReviewInfo]?) -> Void) {
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.searchReviewList(clubIdx: clubIdx, curPage: curPage).getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        
        let header: [String : String] = [
            "Authorization": token
        ]
        
        guard let request = requestMaker.makeRequest(url: url, method: .get, header: header, body: nil) else {return}
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseArrayResult<ReviewInfo>.self, from: data) {
                    if object.status == 200 {
                        completion(object.data)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func requestPostLike(clubPostIdx: Int, completion: @escaping (Bool) -> Void) {
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.reviewLike(clubPostIdx: clubPostIdx).getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        
        let header: [String : String] = [
            "Authorization": token
        ]
        
        guard let request = requestMaker.makeRequest(url: url, method: .post, header: header, body: nil) else {return}
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseSimpleResult<String>.self, from: data) {
                    if object.status == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func requestDeleteLike(clubPostIdx: Int, completion: @escaping (Bool) -> Void) {
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.reviewLike(clubPostIdx: clubPostIdx).getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        
        let header: [String : String] = [
            "Authorization": token
        ]
        
        guard let request = requestMaker.makeRequest(url: url, method: .delete, header: header, body: nil) else {return}
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseSimpleResult<String>.self, from: data) {
                    if object.status == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func requestBlogReviewList(clubIdx: Int, curPage: Int, completion: @escaping ([BlogInfo]?) -> Void) {
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.searchBlogReivewList(clubIdx: clubIdx, curPage: curPage).getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        
        let header: [String : String] = [
            "Authorization": token
        ]
        guard let request = requestMaker.makeRequest(url: url, method: .get, header: header, body: nil) else {return}
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseArrayResult<BlogInfo>.self, from: data) {
                    if object.status == 200 {
                        completion(object.data)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
        
    }
    
    func requestReviewEvent(type: Int, name: String, phone: String, clubIdx: Int, completion: @escaping (Bool) -> Void) {
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.reviewEvent.getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        
        let header: [String : String] = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        
        let body: [String: Any] = [
            "eventType": type,
            "userName": name,
            "userPhone": phone,
            "objectIdx": clubIdx
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        guard let request = requestMaker.makeRequest(url: url, method: .post, header: header, body: jsonData) else {return}
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseSimpleResult<String>.self, from: data) {
                    if object.status == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func requestBlogReviewPost(clubIdx: Int, blogUrl: String, completion: @escaping (Bool) -> Void) {
        
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.registerBlogReview(clubIdx: clubIdx, blogUrl: blogUrl).getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        
        guard let request = requestMaker.makeRequest(url: url, method: .post, header: nil, body: nil) else {return}
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseSimpleResult<String>.self, from: data) {
                    if object.status == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func requestModifyReview(model: ReviewEditViewModel, completion: @escaping (Bool) -> Void) {
        let clubPostIdx = model.reviewInfo.clubPostIdx
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.modifyReview(clubPostIdx: clubPostIdx).getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        let header: [String : String] = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        let body: [String : Any] = [
            "clubStartDate": model.clubActInfo.startRequestDate,
            "clubEndDate": model.clubActInfo.endRequestDate,
            "score0": model.recommendDegreeObservable.value,
            "score1": model.proDegreeObservable.value,
            "score2": model.funDegreeObservable.value,
            "score3": model.hardDegreeObservable.value,
            "score4": model.friendDegreeObservable.value,
            "oneLine": model.oneLineObservable.value,
            "advantage": model.advantageObservable.value,
            "disadvantage": model.disadvantageObservable.value,
            "honeyTip": model.honeyObservable.value,
        ]
        print()
        print(url)
        print(body)
        
        guard let request = requestMaker.makeRequest(url: url, method: .put, header: header, body: nil) else {return}
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseSimpleResult<String>.self, from: data) {
                    print(object)
                    if object.status == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func requestDeleteReview(clubPostIdx: Int, completion: @escaping (Bool) -> Void) {
        let baseURL = UserAPI.sharedInstance.getBaseString()
        let path = RequestURL.modifyReview(clubPostIdx: clubPostIdx).getRequestURL
        guard let url = URL(string: baseURL+path) else {return}
        guard let token = KeychainWrapper.standard.string(forKey: TokenName.token) else {return}
        let header: [String : String] = [
            "Authorization": token
        ]
        print()
        print(url)
        
        guard let request = requestMaker.makeRequest(url: url, method: .delete, header: header, body: nil) else {return}
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseSimpleResult<String>.self, from: data) {
                    print(object)
                    if object.status == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
}
