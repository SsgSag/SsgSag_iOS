//
//  RegisterPhotoCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/10.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class RegisterPhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: ClubRegisterTwoStepViewModel!
    var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImg(index: Int) {
        self.index = index
        guard let imgData = viewModel.photoURLObservable.value[safe: index] else {return}
        let image = UIImage(data: imgData)
        imageView.image = image
    }

    @IBAction func deleteClick(_ sender: Any) {
        viewModel.deletePhoto(index: index)
    }
}
