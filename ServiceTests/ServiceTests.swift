//
//  ServiceTests.swift
//  ServiceTests
//
//  Created by admin on 06/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import XCTest
@testable import SsgSag

class ServiceTests: XCTestCase {

    var posterService: PosterService!
    
    override func setUp() {
        posterService = PosterServiceImp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPosterService() {
        
        posterServiceImp.requestPoster { (response) in
            
            guard response.isSuccess, let posters = response.value else { return }
            
            print(response.isSuccess)
            
//            self.posters = posters
//            self.countTotalCardIndex = self.posters.count
//
//            DispatchQueue.main.async {
//                self.loadCardAndSetPageVC()
//                self.countLabel.text = "\(self.countTotalCardIndex)"
//            }
            
        }

    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
