//
//  MyClubServiceProtocol.swift
//  SsgSag
//
//  Created by bumslap on 08/03/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift

protocol MyClubServiceProtocol {
    func requestMyClubComments(page: Int) -> Observable<[MyClubComment]>
}
