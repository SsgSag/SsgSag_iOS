//
//  AppDelegate.swift
//  SsgSag
//
//  Created by admin on 24/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import UserNotifications
import AdBrixRM
import AdSupport
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var posterIndex: Int?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SsgSag")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 에러가 나는 경우
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 */
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        initUUID()
        
        Messaging.messaging().isAutoInitEnabled = true
        
        //FCM 설정
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        setupAdBrix()
//
//        ApplicationDelegate.shared.application(application,
//                                               didFinishLaunchingWithOptions: launchOptions)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions,
                                                                    completionHandler: { _,_ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                           categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // 디바이스 토큰 확인
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
    
//        naverLogin()
        
        window = UIWindow(frame: UIScreen.main.bounds)
    
        let splashStoryBoard = UIStoryboard(name: "Splash",
                                            bundle: nil)
        guard let splashVC
            = splashStoryBoard.instantiateViewController(withIdentifier: "splash") as? SplashVC else {
                return true
        }
        
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        // AdBrixRM 인스턴스 생성
        let adBrix = AdBrixRM.getInstance
        
        // 딥링크 오픈 트래킹 코드 호출
        adBrix.deepLinkOpen(url: url)
        
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        
        if KLKTalkLinkCenter.shared().isTalkLinkCallback(url) {
            guard let params = url.query?.components(separatedBy: "=") else {
                return true
            }
            
            AppDelegate.posterIndex = Int(params[1])
            return true
        }
        return false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard AppDelegate.posterIndex != nil else {
            return
        }
        
        // 재실행
        let splashStoryBoard = UIStoryboard(name: "Splash",
                                            bundle: nil)
        guard let splashVC
            = splashStoryBoard.instantiateViewController(withIdentifier: "splash")
                as? SplashVC else {
                return
        }
        
        guard let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController else {
            return
        }

        splashVC.view.frame = rootViewController.view.frame
        splashVC.view.layoutIfNeeded()

        window.rootViewController = splashVC
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // 푸시 데이터로 받은 것을 보여줍니다.
        print("Push notification received: \(userInfo)")
    }
    
    // 가져올 데이터가 있음을 나타내는 RemoteNotification이 도착했음을 앱에 알린다.
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Convert token to string (디바이스 토큰 값을 가져옵니다.)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console(토큰 값을 콘솔창에 보여줍니다. 이 토큰값으로 푸시를 전송할 대상을 정합니다.)
        print("APNs device token: \(deviceTokenString)")
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // APN 서비스가 등록 프로세스를 성공적으로 완료할 수 없을 때
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    private func initUUID() {
        guard let _ = KeychainWrapper.standard.string(forKey: "UUID") else {
            KeychainWrapper.standard.set(UUID().uuidString, forKey: "UUID")
            return
        }
    }
    
    private func setupAdBrix() {
        // AdBrixRm 인스턴스 생성
        let adBrix = AdBrixRM.getInstance
        
        if ((NSClassFromString("ASIdentifierManager")) != nil) {
            let idfa: UUID = ASIdentifierManager.shared().advertisingIdentifier
            
            // IDFA를 AdBrix SDK에 전달
            adBrix.setAppleAdvertisingIdentifier(idfa.uuidString)
        }
        
        adBrix.setLogLevel(AdBrixRM.AdBrixLogLevel.TRACE)
        adBrix.setEventUploadCountInterval(AdBrixRM.AdBrixEventUploadCountInterval.MIN)
        adBrix.setEventUploadTimeInterval(AdBrixRM.AdBrixEventUploadTimeInterval.NORMAL)
        adBrix.initAdBrix(appKey: ClientKey.adBrixAppKey.getClienyKey,
                          secretKey: ClientKey.adBrixSecretKey.getClienyKey)
        
        adBrix.delegateDeeplink = self
        
    }
    
    private func hasToken() -> Bool {
        guard let _ = KeychainWrapper.standard.string(forKey: TokenName.token) else {
            return false
        }
        
        return true
    }
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {

    // iOS 10 장치에 대해 표시된 알림 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 수신된 메시지
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    // 전달된 알림에 대한 사용자의 응답을 처리하도록 요청
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 각 앱 시작 시와 새 토큰이 생성될 때마다 실행된다.
    func messaging(_ messaging: Messaging,
                   didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"),
                                        object: nil,
                                        userInfo: dataDict)
        
        // TODO: 필요한 경우 서버로 토큰 보내기
    }
    
    // FCM를 통해 수신된 데이터 메시지 처리(APNS를 통해 수신되지 않음)
    func messaging(_ messaging: Messaging,
                   didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}

extension AppDelegate: AdBrixRMDeeplinkDelegate {
    func didReceiveDeeplink(deeplink: String) {
        print("DEEPLINK :: received - \(deeplink)")
        // deeplink 로 전달되는 정보를 사용하여 해당 페이지로 랜딩합니다.
    }
}
