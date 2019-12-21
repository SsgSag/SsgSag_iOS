//
//  AllTodoList.swift
//  SsgSag
//
//  Created by admin on 23/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

struct AllTodoList: Codable {
    let status: Int?
    let message: String?
    let data: [TodoList]?
}

struct TodoList: Codable {
    var posterIdx: Int?
    
    var categoryIdx: Int?
    
    var isCompleted: Int?
    
    var isEnded: Int?
    
    var posterName: String?
    
    var outline: String?
    
    var posterStartDate: String?
    
    var posterEndDate: String?
    
    var documentDate: String?
    
    var dday: Int?
    
    var isFavorite: Int?
}

protocol posterProtocol: Codable {
    var posterIdx:Int? { get set }
    var categoryIdx: Int? {get set}
    var isCompleted: Int? {get set}
    var isEnded: Int? {get set}
    var posterName: String? {get set}
    var outline: String? {get set}
    var posterStartDate: String? {get set}
    var posterEndDate: String? {get set}
    var documentDate: String? {get set}
    var dday: Int? {get set}
    var isFavorite: Int? {get set}
}
