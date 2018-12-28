//
//  SwipeModel.swift
//  SsgSag
//
//  Created by CHOMINJI on 2018. 12. 28..
//  Copyright © 2018년 wndzlf. All rights reserved.
//

//import Foundation
//
//struct SwipeModel: Codable {
//    let eventName: String
//    let imageName: String
//    let textName: String
//
//    var imageURL: String {
//        return self.imageName + ".png"
//    }
//
//    var textContent: String {
//        return self.textName + ".txt"
//    }
//}


import Foundation

struct UserDetails {
    var name: String = ""
    var imageUrl: String = ""
    var content: [Content] = []
    
    init(userDetails: [String: Any]) {
        name = userDetails["name"] as? String ?? ""
        imageUrl = userDetails["imageUrl"] as? String ?? ""
        let aContent = userDetails["content"] as? [[String : Any]] ?? []
        for element in aContent {
            content += [Content(element: element)]
        }
    }
}

struct Content {
    var type: String
    var url: String
    init(element: [String: Any]) {
        type = element["type"] as? String ?? ""
        url = element["url"] as? String ?? ""
    }
}
