//
//  NoticeServiceImp.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol NoticeService: class {
    func requestNotice(completionHandler: @escaping (DataResponse<[NoticeData]>) -> Void)
}

class NoticeServiceImp: NoticeService {
    func requestNotice(completionHandler: @escaping (DataResponse<[NoticeData]>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.notice.getRequestURL) else {return}
        
//        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.addValue(key, forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
                let dataByNetwork = try JSONDecoder().decode(Notice.self, from: data)
                
                guard let noticeList = dataByNetwork.data else { return }
                
                completionHandler(DataResponse.success(noticeList))
            } catch {
                print("AcitivityDelete Json Parsing")
            }
        }
    }
}
