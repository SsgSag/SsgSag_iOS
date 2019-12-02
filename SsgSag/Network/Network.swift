//
//  Network.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkImp: Network {
    let session = URLSession.shared
    
    func dispatch(request: URLRequest,
                  completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
        
            guard let data = data else {
                completion(.failure(NSError(domain: "data error",
                                            code: 0,
                                            userInfo: nil)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}

class RxNetworkImp: RxNetwork {
    let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func dispatch(request: URLRequest) -> Observable<Data> {
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                observer.onError(NSError(domain: "failed to track lifecycle",
                                         code: -1,
                                         userInfo: nil))
                return Disposables.create()
            }
                
            let task = self.session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    observer.onError(RxCocoaURLError.unknown)
                    return
                }
                guard response?.isSuccess ?? false else {
                    observer.onError(RxCocoaURLError.unknown)
                    return
                 }
                guard let data = data else {
                    observer.onError(RxCocoaURLError.unknown)
                    return
                }
                observer.onNext(data)
                observer.onCompleted()
            }
            task.resume()
                
            return Disposables.create()
        }
    }
}
    
