//
//  ViewModel.swift
//  SsgSag
//
//  Created by 이혜주 on 23/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol ViewModelType {}

class ViewModel: ViewModelType {
    let backgroundColor: Dynamic<UIColor> = Dynamic<UIColor>(.black)
    
    func changeColor() {
        backgroundColor.value = .blue
    }
    
}

class testView: UIView {
    let viewModel = ViewModel()
    func setUp() {
        viewModel.backgroundColor.addObserver { [weak self] (color) in
            self?.backgroundColor = color
        }
    }
}



