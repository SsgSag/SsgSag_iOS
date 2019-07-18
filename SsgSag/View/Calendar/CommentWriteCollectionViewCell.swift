//
//  CommentWriteCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class CommentWriteCollectionViewCell: UICollectionViewCell {
    // TODO: textField 선택시 textField가 키보드 위로 이동하는 로직 추가
    @IBOutlet weak var commentWriteTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func touchUpRegisterButton(_ sender: UIButton) {
        //TODO: 댓글 등록 및 재로드 로직 추가
    }
}
