//
//  UserInfoService.swift
//  SsgSag
//
//  Created by bumslap on 08/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import SwiftKeychainWrapper

protocol UserInfoService {
    func fetchUserInfo() -> Observable<UserInfomation>
}

class UserInfoServiceImp: UserInfoService {
    var disposeBag = DisposeBag()
    private let network: RxNetwork = RxNetworkImp(session: URLSession.shared)
    private let requestMaker: RequestMakerProtocol = RequestMaker()
    
    func fetchUserInfo() -> Observable<UserInfomation> {
        guard let token
            = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.signUp.getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        return .empty()
        }
        
        return network
            .dispatch(request: request)
            .flatMapLatest { (data) -> Observable<UserInfomation> in
                if let info = try? JSONDecoder().decode(UserInfomationResponse.self,
                                                        from: data).data {
                    return Observable.just(info)
                } else {
                    return .empty()
                }
        }
    }
    
}
