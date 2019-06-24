//
//  DetailTodoListTableViewCell.swift
//  SsgSag
//
//  Created by admin on 16/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DetailTodoListTableViewCell: UITableViewCell {
    
    var poster: Posters? {
        didSet {
            guard let posterInfo = poster else {return}
            
            posterName.text = posterInfo.posterName
            guard let urlString = posterInfo.photoUrl else {return}
            guard let url = URL(string: urlString) else {return}
            
            ImageNetworkManager.shared.getImageByCache(imageURL: url ){ [weak self] (image, error) in
                if error == nil {
                    self?.posterImageView.image = image
                }
            }
        }
    }
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var posterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.posterImageView.image = nil
        self.posterName.text = ""
    }
    
}
