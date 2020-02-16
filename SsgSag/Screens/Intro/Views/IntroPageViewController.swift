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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = IntroPageViewModel()
        viewModel.buildViewModel()
        bind(viewModel: viewModel)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
                    
                        let loginStoryBoard = UIStoryboard(name: StoryBoardName.login,
                                                           bundle: nil)
                        
                         let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "splashVC")
                        
                        guard let window = UIApplication.shared.keyWindow else {
                            return
                        }
                        window.rootViewController = UINavigationController(rootViewController: loginVC)
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

