//
//  UnivService.swift
//  SsgSag
//
//  Created by 남수김 on 2020/03/13.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

struct UnivService {
    private let requestMaker: RequestMakerProtocol = RequestMaker()
    private let network: Network = NetworkImp()
    
    func requestUnivInfoList(completion: @escaping ([UnivListModel]?) -> Void) {
        let component = URLComponents(string: "http://13.209.77.133:8082/validUnivList")
        guard let url = component?.url else {
            return
        }
        
        guard let request = requestMaker.makeRequest(url: url, method: .get, header: nil, body: nil) else {
            return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                if let object = try? JSONDecoder().decode(ResponseArrayResult<UnivListModel>.self, from: data) {
                    
                    if object.status == 200 {
                        guard let data = object.data else {
                            completion(nil)
                            return
                        }
                        completion(data)
                    } else {
                        completion(nil)
                    }
                }
            case .failure(let err):
                print(err)
                completion(nil)
            }
            
        }
    }
}
