//
//  LoginService.swift
//  SsgSag
//
//  Created by CHOMINJI on 2018. 12. 31..
//  Copyright © 2018년 wndzlf. All rights reserved.
//

import Alamofire

struct LoginService: APIManager, Requestable {
    
    typealias NetworkData = ResponseObject<Token>
    static let shared = LoginService()
    let loginURL = url("/login")
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json"
    ]
    
    //로그인 api
    func login(email: String, password: String, completion: @escaping (Token?,Int?) -> Void) {
        let body = [
            "userEmail" : email,
            "userPw" : password,
            ]
        
        postable(loginURL, body: body, header: headers) { res in
            switch res {
            case .success(let value):
                print("ㅇ마너임ㄴ")
                print(value)
                print("1234123512351235123515")
                
                guard let statusValue = value.status else {return}
                if value.status == 200 {
                    print("로그인 성공2")
                }else if value.status == 400{
                    print("로그인 실패2")
                }else if value.status == 500{
                    print("서버 내부 에러")
                }
                
                //guard let token = value.data else {return}
                print(value.data)
                print(value.status)
                completion(value.data,value.status)
            case .error(let error):
                print(error)
                print("전송 실패")
            }
        }
        
        
        
        
    }
    
}
