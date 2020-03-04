//
//  ReviewServiceProtocol.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/07.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

protocol ReviewServiceProtocol {
    func requestExistClubReviewPost(model: ClubActInfoModel, completion: @escaping (ReviewRegister?) -> Void)
    
    func requestNonExistClubReviewPost(model: ClubActInfoModel, completion: @escaping (ReviewRegister?) -> Void)
    
    func requestBlogReviewPost(clubIdx: Int, blogUrl: String, completion: @escaping (Bool) -> Void)
    
    func requestReviewList(clubIdx: Int, curPage: Int, completion: @escaping ([ReviewInfo]?) -> Void)
    
    func requestBlogReviewList(clubIdx: Int, curPage: Int, completion: @escaping ([BlogInfo]?) -> Void)
    
    func requestPostLike(clubPostIdx: Int, completion: @escaping (Bool) -> Void)
    
    func requestDeleteLike(clubPostIdx: Int, completion: @escaping (Bool) -> Void)
    
    func requestReviewEvent(type: Int, name: String, phone: String, clubIdx: Int, completion: @escaping (Bool) -> Void)
}
