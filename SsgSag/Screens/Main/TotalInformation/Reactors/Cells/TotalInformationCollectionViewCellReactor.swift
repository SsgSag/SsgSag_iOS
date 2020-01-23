//
//  TotalInformationCollectionViewCell.swift
//  SsgSag
//
//  Created by bumslap on 09/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class TotalInformationCollectionViewCellReactor: Reactor {
    
    private let imageLoader: ImageLoader = ImageLoader()
    enum Action {
        case set(TotalInformation)
        case requestImage
    }

    enum Mutation {
        case setTitle(String)
        case setDday(String)
        case setHashTags(String)
        case setImage(UIImage?)
    }

    struct State {
        var title: String = ""
        var thumbnailImageUrl: String
        var thumbnailImage: UIImage? = nil
        var hashTags: String
        var day: String = ""
    }

   let initialState: State
   
    init(title: String, thumbnailImageUrl: String, hashTags: String) {
       self.initialState = State(title: title,
                                 thumbnailImageUrl: thumbnailImageUrl, thumbnailImage: nil,
                                 hashTags: hashTags, day: "") // thumbnailImage, day가 비어있어서 임시로 추가했습니다.
   }

   func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .set(let info):
            return Observable.concat([.just(Mutation.setTitle(info.posterName ?? "")),
                                      .just(Mutation.setDday("D-\(info.dday ?? 0)")),
                                      .just(Mutation.setHashTags(trimHashTags(string: info.keyword ?? "")))
            ])
        case .requestImage:
            return imageLoader.load(with: currentState.thumbnailImageUrl).map { Mutation.setImage($0) }
        }
   }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setTitle(let title):
            state.title = title
        case .setImage(let image):
            state.thumbnailImage = image
        case .setDday(let day):
            state.day = day
        case .setHashTags(let hashTags):
            state.hashTags = hashTags
        }
        return state
    }
    
    private func trimHashTags(string: String) -> String {
        let hashTagWidthLimit: CGFloat = 130
        let hashTags = string
            .components(separatedBy: "#")
            .filter { !$0.isEmpty }
            .map { $0.replacingOccurrences(of: " ", with: "") }
            .reduce("#") { prev, current in
                let mergedString = prev + " #\(current)"
                if prev == "#" {
                    return "#\(current)"
                } else if mergedString.estimatedFrame(font: .systemFont(ofSize: 10, weight: .regular)).width > hashTagWidthLimit {
                    return prev
                } else {
                    return mergedString
                }
            }
        return hashTags
    }
}
