//
//  MyClubService.swift
//  SsgSag
//
//  Created by bumslap on 07/03/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class MyClubService: MyClubServiceProtocol {
    private let requestMaker: RequestMakerProtocol = RequestMaker()
    private let network: RxNetwork = RxNetworkImp(session: URLSession.shared)
    
    func requestMyClubComments(page: Int) -> Observable<[MyClubComment]> {
        guard let token
                    = KeychainWrapper.standard.string(forKey: TokenName.token),
            let url = UserAPI.sharedInstance.getURL(RequestURL.myClub(curPage: page).getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .get,
                                       header: ["Authorization": token],
                                       body: nil) else {
                                        
                                        return .empty()
        }
                   
       return network
        .dispatch(request: request)
        .flatMapLatest { (data) -> Observable<[MyClubComment]> in
                if let comments = try? JSONDecoder().decode(MyClubCommentResponsee.self,
                                                            from: data).data {
                    return .just(comments)
                } else {
                    return .just([])
                }
        }
    }
}
