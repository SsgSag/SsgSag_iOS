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
    
    var favoritCellViewModels: [SavedPosterCellViewModel] = []
    var disLikeCellViewModels: [SavedPosterCellViewModel] = []
    
    func buildCellViewModels(completion: @escaping (() -> Void)) {
        posterService.requestStoredPoster { [weak self] (response) in
            switch response {
            case .success(let posterdata):
                guard let self = self else { return }
                self.favoritCellViewModels = (posterdata.ssgSummaryPosterList ?? []).compactMap { SavedPosterCellViewModel(poster: $0) }
                self.disLikeCellViewModels = (posterdata.sagSummaryPosterList ?? []).compactMap { SavedPosterCellViewModel(poster: $0) }
                completion()
            case .failed(let error):
                completion()
                return
            }
        }
    }
    
}
