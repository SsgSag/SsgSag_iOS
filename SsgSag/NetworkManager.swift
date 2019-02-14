//
//  NetworkManager.swift
//  SsgSag
//
//  Created by CHOMINJI on 13/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class NetworkManager {
    
    private let session: URLSession
    
    static let shared: NetworkManager = NetworkManager()
    
    private init(_ configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    private convenience init() {
        self.init(.default)
    }
    
    func getData(with: URLRequest, completion: @escaping (Data?, Error?, URLResponse?) -> Void) {
        let task = URLSession.shared.dataTask(with: with) { (data, res, error) in
            if error != nil {
                print("network error")
            }
            
            guard let data = data else {
                return
            }
            completion(data, nil, res)
        }
        task.resume()
    }
    
}

