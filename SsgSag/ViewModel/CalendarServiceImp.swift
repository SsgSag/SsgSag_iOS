//
//  CalendarServiceImp.swift
//  SsgSag
//
//  Created by admin on 23/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol CalendarService: class {
    func requestMonthTodoList(year: String, month: String, completionHandler: @escaping (DataResponse<[MonthTodoData]>) -> Void)
    
    func requestDayTodoList(year: String, month: String, day: String, completionHandler: @escaping (DataResponse<[DayTodoData]>) -> Void)
    
    func requestFavorite(_ favorite: favoriteState, _ posterIdx: Int,completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void)
    
    func requestDelete(_ posterIdx: Int, completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void )
    
    func reqeustComplete(_ posterIdx: Int, completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void)
    
    func requestEachPoster(_ posterIdx: Int, completionHandler: @escaping (DataResponse<networkPostersData>) -> Void)
}

class CalendarServiceImp: CalendarService {
    
    func requestMonthTodoList(year: String,
                              month: String,
                              completionHandler: @escaping (DataResponse<[MonthTodoData]>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.monthTodoList(year: year, month: month).getRequestURL) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(MonthTodoList.self, from: data)

                let posterData = response.data

                completionHandler(DataResponse.success(posterData))

            } catch {
                print("AllTodoList Parsing Error")
            }
        }
    }
    
    func requestDayTodoList(year: String,
                            month: String,
                            day: String,
                            completionHandler: @escaping (DataResponse<[DayTodoData]>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.dayTodoList(year: year, month: month, day: day).getRequestURL) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(DayTodoList.self, from: data)

                let posterData = response.data

                completionHandler(DataResponse.success(posterData))

            } catch {
                print("AllTodoList Parsing Error")
            }
        }
    }
    
    func requestEachPoster(_ posterIdx: Int, completionHandler: @escaping
        (DataResponse<networkPostersData>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.posterDetail(posterIdx: posterIdx).getRequestURL) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            
            guard let data = data else {return}
            
            do {
                let response = try JSONDecoder().decode(networkPostersData.self, from: data)
                
                completionHandler(DataResponse.success(response))
            } catch {
                print("EachPoster Parsing Error")
            }
        }
        
    }
    
    func reqeustComplete(_ posterIdx: Int, completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.completeApply(posterIdx: posterIdx).getRequestURL) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        NetworkManager.shared.getData(with: request) { (data, error, response) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(PosterFavorite.self, from: data)
                
                completionHandler(DataResponse.success(response))
            } catch {
                print("CompleteApplyPoster Parsing Error")
            }
            
        }
    }
    
    func requestDelete(_ posterIdx: Int, completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void) {
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.deletePoster(posterIdx: posterIdx).getRequestURL) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
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
    
    func requestFavorite(_ favorite: favoriteState,
                         _ posterIdx: Int,
                         completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void) {
        
        guard let url = UserAPI.sharedInstance.getURL(RequestURL.favorite(posterIdx: posterIdx).getRequestURL) else {return}
        
        guard let key = UserDefaults.standard.object(forKey: TokenName.token) as? String else { return }
        
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
