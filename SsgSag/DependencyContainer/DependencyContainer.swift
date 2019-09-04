//
//  DependencyContainer.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class DependencyContainer {
    private let dependencyPool = DependencyPool()
    
    public static let shared: DependencyContainer = DependencyContainer()
    
    private init() {
        let calendarService: CalendarService
            = CalendarServiceImp(requestMaker: RequestMaker(),
                                 network: NetworkImp())
        
        let loginService: LoginService
            = LoginServiceImp(requestMaker: RequestMaker(),
                              network: NetworkImp())
        
        let posterService: PosterService
            = PosterServiceImp(requestMaker: RequestMaker(),
                               network: NetworkImp())
        
        let myPageService: MyPageService
            = MyPageServiceImp(requestMaker: RequestMaker(),
                               network: NetworkImp())
        
        let tabbarService: TabbarService
            = TabbarServiceImp(requestMaker: RequestMaker(),
                               network: NetworkImp())
        
        let activityService: ActivityService
            = ActivityServiceImp(requestMaker: RequestMaker(),
                                 network: NetworkImp())
        
        let interestService: InterestService
            = InterestServiceImp(requestMaker: RequestMaker(),
                                 network: NetworkImp())
        
        let signUpService: SignupService
            = SignupServiceImp(requestMaker: RequestMaker(),
                               network: NetworkImp())
        
        let careerService: CareerService
            = CareerServiceImp(requestMaker: RequestMaker(),
                               network: NetworkImp())
        
        let noticeService: NoticeService
            = NoticeServiceImp(requestMaker: RequestMaker(),
                               network: NetworkImp())
        
        let feedService: FeedService
            = FeedServiceImp(requestMaker: RequestMaker(),
                             network: NetworkImp())
        
        let commentService: CommentService
            = CommentServiceImp(requestMaker: RequestMaker(),
                                network: NetworkImp())
        
        do {
            try dependencyPool.register(key: .calendarService,
                                        dependency: calendarService)
            try dependencyPool.register(key: .loginService,
                                        dependency: loginService)
            try dependencyPool.register(key: .posterService,
                                        dependency: posterService)
            try dependencyPool.register(key: .myPageService,
                                        dependency: myPageService)
            try dependencyPool.register(key: .tabbarService,
                                        dependency: tabbarService)
            try dependencyPool.register(key: .activityService,
                                        dependency: activityService)
            try dependencyPool.register(key: .interestService,
                                        dependency: interestService)
            try dependencyPool.register(key: .signUpService,
                                        dependency: signUpService)
            try dependencyPool.register(key: .careerService,
                                        dependency: careerService)
            try dependencyPool.register(key: .noticeService,
                                        dependency: noticeService)
            try dependencyPool.register(key: .feedService,
                                        dependency: feedService)
            try dependencyPool.register(key: .commentService,
                                        dependency: commentService)
        } catch {
            fatalError("register Fail")
        }
        
    }
    
    public func getDependency<T>(key: DependencyKey) -> T {
        do {
            return try dependencyPool.pullOutDependency(key: key)
        } catch DependencyError.keyAlreadyExistsError {
            fatalError("keyAlreadyExistError")
        } catch DependencyError.unregisteredKeyError {
            fatalError("unregisteredKeyError")
        } catch DependencyError.downcastingFailureError {
            fatalError("downcastingFailureError")
        } catch {
            fatalError("getDependency Fail")
        }
    }
}

enum DependencyKey {
    case calendarService
    case loginService
    case posterService
    case myPageService
    case tabbarService
    case activityService
    case interestService
    case signUpService
    case careerService
    case noticeService
    case feedService
    case commentService
}
