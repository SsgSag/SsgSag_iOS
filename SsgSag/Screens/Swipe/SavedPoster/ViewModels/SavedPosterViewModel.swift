//
//  SavedPosterViewModel.swift
//  SsgSag
//
//  Created by bumslap on 09/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SavedPosterViewModel {
    private let posterService: PosterService
      = DependencyContainer.shared.getDependency(key: .posterService)
    
    let cellViewModels = BehaviorRelay<[SavedPosterCellViewModel]>(value: [])
    
    func buildCellViewModels() {
        posterService.requestStoredPoster(index: 0, type: .liked) { [weak self] (response) in
            switch response {
            case .success(let posterdata):
                guard let self = self else { return }
                guard let posters = posterdata.posters else { return }
                self.cellViewModels.accept(posters.compactMap { SavedPosterCellViewModel(isLiked: true, poster: $0) })
            case .failed(let error):
                return
            }
        }
    }
    
}
