//
//  TotalInformationService.swift
//  SsgSag
//
//  Created by bumslap on 08/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import SwiftKeychainWrapper

protocol TotalInformationServiceProtocol {
    func fetchTotalInformations(category: TotalInfoCategoryType) -> Observable<[TotalInformation]>
    func fetchAllTotalInformations(categories: [TotalInfoCategoryType]) -> Observable<[TotalInfoCategoryType: [TotalInformation]]>
}

enum TotalInfoCategoryType: Int, CaseIterable {
    case contest = 0
    case activity = 1
    case internship = 4
    case etc = 5
    case lecture = 7
    
    static func getType(by numberingOrder: Int) -> TotalInfoCategoryType {
        let maxNumber = TotalInfoCategoryType.allCases.count
        guard maxNumber > numberingOrder else { return .contest }
        switch numberingOrder {
        case 0:
            return .contest
        case 1:
            return .activity
        case 2:
            return .internship
        case 3:
            return .lecture
        case 4:
            return .etc
        default:
            return .contest
        }
    }
}

class TotalInformationService: TotalInformationServiceProtocol {
    var disposeBag = DisposeBag()
    private let netowrk: RxNetwork = RxNetworkImp(session: URLSession.shared)
    private let requestMaker: RequestMakerProtocol = RequestMaker()
    
    func fetchTotalInformations(category: TotalInfoCategoryType) -> Observable<[TotalInformation]> {
        let totalInfosObservable = Observable<[TotalInformation]>.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            guard let token = KeychainWrapper.standard.string(forKey: TokenName.token),
                let url = UserAPI.sharedInstance.getURL(RequestURL.posterWhat(category: category.rawValue).getRequestURL),
                let request = self.requestMaker.makeRequest(url: url,
                                                          method: .get,
                                                          header: ["Authorization": token],
                                                          body: nil) else {
                observer.onError(NSError(domain: "building failed",
                code: -1,
                userInfo: nil))
                                                            return Disposables.create()
            }
            self.netowrk.dispatch(request: request)
                .flatMapLatest { data -> Observable<[TotalInformation]> in
                do {
                    let response = try JSONDecoder().decode(TotalInformationResponse.self, from: data)
                    return Observable.just(response.data ?? [])
                } catch let error {
                    observer.onError(error)
                    return .empty()
                }
            }
            .subscribe(onNext: { infos in
                observer.onNext(infos)
                observer.onCompleted()
            },
            onError: { error in
                observer.onError(error)
            })
            .disposed(by: self.disposeBag)
            return Disposables.create()
        }
        return totalInfosObservable
    }
    
    func fetchAllTotalInformations(categories: [TotalInfoCategoryType]) -> Observable<[TotalInfoCategoryType: [TotalInformation]]> {
        
        let results = categories.map { [weak self] type -> Observable<[TotalInfoCategoryType: [TotalInformation]]> in
            guard let self = self else { return .empty() }
            return self.fetchTotalInformations(category: type).map { [type: $0] }
        }
        return Observable.combineLatest(results) { val in
            val.reduce([TotalInfoCategoryType: [TotalInformation]]()) { (prev, currentDict) -> [TotalInfoCategoryType: [TotalInformation]] in
                prev.merging(currentDict) { (_, new) in new }
                }
            }
        }
    
}
