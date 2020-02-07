//
//  ProjectColor.swift
//  SsgSag
//
//  Created by bumslap on 30/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

extension UIColor {
    static let cornFlower = UIColor(red: 101/255,
                                    green: 110/255,
                                    blue: 240/255,
                                    alpha: 1)
    
    static let unselectedTextGray = UIColor(red: 153/255,
                                            green: 153/255,
                                            blue: 153/255,
                                            alpha: 1)
    
    static let unselectedGray = UIColor(red: 170/255,
                                        green: 170/255,
                                        blue: 170/255,
                                        alpha: 1)
    
    static let unselectedButtonDefault = UIColor(red: 193/255,
                                                 green: 193/255,
                                                 blue: 193/255,
                                                 alpha: 1)
    
    static let unselectedBorderGray = UIColor(red: 231/255,
                                              green: 231/255,
                                              blue: 231/255,
                                              alpha: 1)

    @nonobjc class var reviewDeselectGray: UIColor {
      return UIColor(white: 187.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var reviewDeselectLineGray: UIColor {
        return UIColor(white: 238.0 / 255.0, alpha: 1.0)
    }
}
