//
//  CommentServiceImp.swift
//  SsgSag
//
//  Created by 이혜주 on 09/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class CommentServiceImp: CommentService {
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestAddComment(index: Int,
                           comment: String,
                           completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
        let body: [String: Any] = ["posterIdx" : index,
                                   "commentContent" : comment]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.comment.getRequestURL),
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
                        = try JSONDecoder().decode(Career.self,
                                                   from: data)
                    
                    guard let httpStatusCode
                        = HttpStatusCode(rawValue: decodedData.status) else {
                            completionHandler(.failed(NSError(domain: "status error",
                                                              code: 0,
                                                              userInfo: nil)))
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
    
    func requestCommentLike(index: Int,
                            like: Int,
                            completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.commentLike(index: index, like: like).getRequestURL
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .post,
                                       header: ["Authorization": token],
                                       body: nil) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(Career.self,
                                                               from: data)
                    
                    guard let httpStatusCode
                        = HttpStatusCode(rawValue: decodedData.status) else {
                            completionHandler(.failed(NSError(domain: "status error",
                                                              code: 0,
                                                              userInfo: nil)))
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
    
    func requestCommentDelete(index: Int,
                              completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.commentDelete(index: index).getRequestURL
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url = urlComponent?.url,
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
                    let decodedData = try JSONDecoder().decode(Career.self,
                                                               from: data)
                    
                    guard let httpStatusCode
                        = HttpStatusCode(rawValue: decodedData.status) else {
                            completionHandler(.failed(NSError(domain: "status error",
                                                              code: 0,
                                                              userInfo: nil)))
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
    
    func requestCommentReport(index: Int,
                              completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        var urlComponent = URLComponents(string: UserAPI.sharedInstance.getBaseString())
        urlComponent?.path = RequestURL.commentReport(index: index).getRequestURL
        
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url = urlComponent?.url,
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .post,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(Career.self,
                                                               from: data)
                    
                    guard let httpStatusCode
                        = HttpStatusCode(rawValue: decodedData.status) else {
                            completionHandler(.failed(NSError(domain: "status error",
                                                              code: 0,
                                                              userInfo: nil)))
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
