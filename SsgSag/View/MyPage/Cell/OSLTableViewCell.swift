//
//  OSLTableViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 15/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class OSLTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    
    var OSLData: OSL? {
        didSet {
            guard let OSL = self.OSLData else {
                return
            }
            
            titleLabel?.text = OSL.name
            copyrightLabel?.text = OSL.copyRight
            licenseLabel?.text = OSL.license
            
            let attributedString = NSMutableAttributedString(string: "\(OSL.url)")
            
            linkTextView?.attributedText = attributedString
            linkTextView?.linkTextAttributes
                = [NSAttributedString.Key.foregroundColor: UIColor.blue,
                   NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            linkTextView?.dataDetectorTypes = UIDataDetectorTypes.all
            linkTextView?.textContainer.maximumNumberOfLines = 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        linkTextView.textContainer.lineFragmentPadding = 0
        linkTextView.textContainerInset = UIEdgeInsets(top: 0,
                                                       left: 0,
                                                       bottom: 0,
                                                       right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
