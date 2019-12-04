//
//  MyFilterFooterCollectionReusableView.swift
//  SsgSag
//
//  Created by bumslap on 25/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift

class MyFilterFooterCollectionReusableView: UICollectionReusableView {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    @IBOutlet weak var confirmButton: UIButton!
}
