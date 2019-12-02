//
//  MyFilterSliderCollectionViewCell.swift
//  SsgSag
//
//  Created by bumslap on 24/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

class MyFilterSliderCollectionViewCell: UICollectionViewCell, StoryboardView {
 
    var disposeBag = DisposeBag()
    @IBOutlet weak var gradeCollectionView: UICollectionView!
    @IBOutlet weak var gradeSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUiComponnents()
    }
    
    func setUpUiComponnents() {
        let gradeCell = UINib(nibName: "MyFilterGradeCollectionViewCell",
               bundle: nil)
        gradeCollectionView.register(gradeCell,
                                     forCellWithReuseIdentifier: "MyFilterGradeCollectionViewCell")
        
        //gradeSlider
        gradeSlider.maximumValue = 5
        gradeSlider.value = 3
        gradeSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        gradeSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .highlighted)
        gradeSlider.isContinuous = false
        
    }
    
    func bind(reactor: MyFilterSliderCollectionViewCellReactor) {
        
        guard let layout = gradeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = reactor.itemsSize
        layout.minimumLineSpacing = reactor.spacing

        // Action
        gradeSlider.rx.value
            .map { Reactor.Action.set(Int(lroundf($0))) }
            .bind(to: reactor.action)         // Bind to reactor.action
            .disposed(by: disposeBag)
        
        // State
       reactor.state.map { $0.grades }
        .bind(to: gradeCollectionView.rx.items(cellIdentifier: "MyFilterGradeCollectionViewCell")) {[weak self] indexPath, grade, cell in
               guard let gradeCell = cell
                as? MyFilterGradeCollectionViewCell else { return }
            gradeCell.reactor = reactor.gradeCellReactors[indexPath]
            self?.gradeSlider.rx.value
                .map { value in MyFilterGradeCollectionViewCellReactor.Action.select(Int(lroundf(value)) - 1) }
                .bind(to: reactor.gradeCellReactors[indexPath].action)         // Bind to reactor.action
                .disposed(by: gradeCell.disposeBag)
           }
       .disposed(by: disposeBag)
        
        reactor.state.map { Float($0.value) }
            .bind(to: gradeSlider.rx.value)
            .disposed(by: disposeBag)
    
    }
}

