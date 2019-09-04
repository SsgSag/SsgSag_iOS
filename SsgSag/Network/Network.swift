//
//  Network.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

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
