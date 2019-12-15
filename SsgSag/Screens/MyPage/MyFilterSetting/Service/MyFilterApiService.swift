//
//  MyFilterAPIService.swift
//  SsgSag
//
//  Created by bumslap on 01/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import SwiftKeychainWrapper

protocol MyFilterApiService {
    func save(filterSetting: MyFilterSetting) -> Observable<BasicResponse>
    func fetchMyFilterSetting() -> Observable<MyFilterSetting>
}

class MyFilterApiServiceImp: MyFilterApiService {
    
    var disposeBag = DisposeBag()
    private let network: RxNetwork = RxNetworkImp(session: URLSession.shared)
    private let requestMaker: RequestMakerProtocol = RequestMaker()
    
    func save(filterSetting: MyFilterSetting) -> Observable<BasicResponse> {
        let bodyData = ["userInterest" : filterSetting.map()]
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        let savingObservable = Observable<BasicResponse>.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            guard let token = KeychainWrapper.standard.string(forKey: TokenName.token),
                      let url = UserAPI.sharedInstance.getURL(RequestURL.reIntersting.getRequestURL),
                let request = self.requestMaker.makeRequest(url: url,
                                                          method: .post,
                                                          header: ["Authorization": token,
                                                                   "Content-Type": "application/json" ],
                                                          body: jsonData) else {
                observer.onError(NSError(domain: "building failed",
                code: -1,
                userInfo: nil))
                                                            return Disposables.create()
            }
            self.network.dispatch(request: request)
                .subscribe(onNext: { data in
                    do {
                        let response = try JSONDecoder().decode(BasicResponse.self, from: data)
                        observer.onNext(response)
                    } catch let error {
                        observer.onError(error)
                    }
                },
                onError: { error in
                    observer.onError(error)
                    
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
        return savingObservable
    }
    
    func fetchMyFilterSetting() -> Observable<MyFilterSetting> {
        let fetchObservable = Observable<MyFilterSetting>.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            guard let token = KeychainWrapper.standard.string(forKey: TokenName.token),
                      let url = UserAPI.sharedInstance.getURL(RequestURL.interestingField.getRequestURL),
                let request = self.requestMaker.makeRequest(url: url,
                                                          method: .get,
                                                          header: ["Authorization": token],
                                                          body: nil) else {
                observer.onError(NSError(domain: "building failed",
                code: -1,
                userInfo: nil))
                                                            return Disposables.create()
            }
            self.network.dispatch(request: request)
                .subscribe(onNext: { data in
                    do {
                        let response = try JSONDecoder().decode(Interests.self, from: data)
                        let myFilterSetting = MyFilterSetting().map(interests: response.data?.interests)
                        observer.onNext(myFilterSetting)
                    } catch let error {
                        observer.onError(error)
                    }
                },
                onError: { error in
                    observer.onError(error)
                    
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
        return fetchObservable
    }
}
    
