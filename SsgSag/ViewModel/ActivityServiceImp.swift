//
//  ActivityServiceImp.swift
//  SsgSag
//
//  Created by admin on 12/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ActivityServiceImp: ActivityService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestDeleteActivity(contentIdx: Int,
                               completionHandler: @escaping ((DataResponse<Activity>) -> Void)) {
        
        guard let token
            = UserDefaults.standard.object(forKey: TokenName.token) as? String,
            let url
            = UserAPI.sharedInstance.getURL(RequestURL.deleteAcitivity(careerIdx: contentIdx).getRequestURL),
            let request
            = requestMaker.makeRequest(url: url,
                                       method: .delete,
                                       header: ["Authorization": token,
                                                "Content-Type": "application/json"],
                                       body: nil) else {
                return
        }
        
        network.dispatch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData
                        = try JSONDecoder().decode(Activity.self,
                                                   from: data)
                    
                    completionHandler(.success(decodedData))
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
