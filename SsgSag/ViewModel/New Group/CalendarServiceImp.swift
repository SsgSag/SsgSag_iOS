//
//  CalendarServiceImp.swift
//  SsgSag
//
//  Created by admin on 23/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class CalendarServiceImp: CalendarService {
    
    func requestDelete(_ posterIdx: Int, completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.deletePoster(posterIdx: posterIdx).getRequestURL()) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else { return }
        
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(PosterFavorite.self, from: data)
                
                completionHandler(DataResponse.success(response))
            } catch {
                print("DeletePoster Parsing Error")
            }
            
        }
    }
    
    
    func requestFavorite(_ favorite: favoriteState, _ posterIdx: Int, completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.favorite(posterIdx: posterIdx).getRequestURL()) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else { return }
        
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "Authorization")
        
        switch favorite {
        case .favorite:
            request.httpMethod = "DELETE"
        case .notFavorite:
            request.httpMethod = "POST"
        }
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(PosterFavorite.self, from: data)
                
                completionHandler(DataResponse.success(response))
            } catch {
                print("PosterFavorite Parsing Error")
            }
            
        }
    }
}

/*
//0 카톡 로그인, 1은 네이버 로그인(업데이트 예정)
let json: [String: Any] = [ "accessToken": accessToken,
                            "loginType" : login ]

let jsonData = try? JSONSerialization.data(withJSONObject: json)

guard let url = UserAPI.sharedInstance.getURL(RequestURL.snsLogin.getRequestURL()) else {return}

var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = jsonData

NetworkManager.shared.getData(with: request) { (data, error, res) in
    guard let data = data else { return }
    
    do {
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        
        completionHandler(DataResponse.success(tokenResponse))
    } catch {
        print("LoginService Parsing Error")
    }
}
*/
