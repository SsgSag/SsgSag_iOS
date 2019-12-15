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
        
        gradeSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        gradeSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .highlighted)
        gradeSlider.isContinuous = false
        
    }
    
    func bind(reactor: MyFilterSliderCollectionViewCellReactor) {
        
        guard let layout = gradeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = reactor.itemsSize
        layout.minimumLineSpacing = reactor.spacing

        gradeSlider.maximumValue = Float(reactor.currentState.maxValue)
        gradeSlider.value = Float(reactor.currentState.value)
        // Action
        
        gradeSlider.rx.value
            .distinctUntilChanged()
            .do(onNext: {[weak self] (value) in
                self?.gradeSlider.value = Float(lroundf(value))
            })
            .map { Reactor.Action.set(Int(lroundf($0))) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
       reactor.state.map { $0.grades }
        .bind(to: gradeCollectionView.rx.items(cellIdentifier: "MyFilterGradeCollectionViewCell")) {[weak self] indexPath, grade, cell in
               guard let gradeCell = cell
                as? MyFilterGradeCollectionViewCell else { return }
            gradeCell.reactor = reactor.gradeCellReactors[indexPath]
            self?.gradeSlider.rx.value
                .distinctUntilChanged()
                .map { value in MyFilterGradeCollectionViewCellReactor.Action.select(Int(lroundf(value)) - 1) }
                .bind(to: reactor.gradeCellReactors[indexPath].action)
                .disposed(by: gradeCell.disposeBag)
           }
       .disposed(by: disposeBag)
    }
}

