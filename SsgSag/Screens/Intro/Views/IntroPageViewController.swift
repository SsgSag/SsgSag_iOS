//
//  IntroPageViewController.swift
//  SsgSag
//
//  Created by bumslap on 10/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IntroPageViewController: UIViewController {
    var disposeBag = DisposeBag()
    @IBOutlet weak var introCollectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = IntroPageViewModel()
        viewModel.buildViewModel()
        bind(viewModel: viewModel)
        // Do any additional setup after loading the view.
    }
    
    func bind(viewModel: IntroPageViewModel) {
        introCollectionview.delegate = self
        
        viewModel.cellViewModels
            .bind(to: introCollectionview
                .rx
                .items(cellIdentifier: "IntroPageCollectionViewCell")) { indexPath, cellViewModel, cell  in
                    let cell = cell as? IntroPageCollectionViewCell
                    cell?.bind(viewModel: cellViewModel)
                    cellViewModel.callback = { [weak self] in
                        let splashStoryBoard = UIStoryboard(name: "Splash",
                                                                   bundle: nil)
                        guard let splashVC
                            = splashStoryBoard.instantiateViewController(withIdentifier: "splash") as? SplashVC else {
                                return
                        }
                        guard let window = UIApplication.shared.keyWindow else {
                            return
                        }
                        window.rootViewController = splashVC
                    }
        }
        .disposed(by: disposeBag)
    }
}
extension IntroPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

