//
//  ViewCareerService.swift
//  SsgSag
//
//  Created by CHOMINJI on 31/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import Alamofire

struct ViewCareerService: APIManager, Requestable{
    typealias NetworkData = ResponseObject<Token>
    static let shared = ViewCareerService()
    var subscribeURL = url("/career/info")
    let header: HTTPHeaders = [
        "Content-Type" : "application/json",
        "Authorization" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
    ]
    
    func viewCareer(careerType: Int, completion: @escaping () -> Void) {
        let body = [
            "careerType" : careerType
        ]
        
        postable(subscribeURL, body: body, header: header) { res in
            switch res {
            case .success( _):
                completion()
            case .error(let error):
                print(error)
            }
        }
        
    }
    
}

