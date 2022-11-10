//
//  AppDelegate.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit

import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        
        // IQKeyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
        // Default UI Setting
        UINavigationBar.appearance().tintColor = R.color.black()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: R.color.black()]
        UIBarButtonItem.appearance().tintColor = R.color.black()
        
        return true
    }

    
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}




// MARK: - UNUserNotificationCenterDelegate 프로토콜 채택
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Remote Notification이 등록되면 호출
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    // 포그라운드 알림 수신: 로컬/푸시 동일
    // ex카톡: OO님과 채팅방, 푸시마다 설정, 화면마다 설정
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        // 특정 화면에서는 푸시를 보내지 마라! (라는 분기처리도 가능)
//        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
//
//        if viewController is SettingViewController {
//            // return하거나, 특정 요소만 받도록 분거처리도 가능
//            completionHandler([.badge])
//
//        }else {
//            // .banner, .list: iOS 14+
//            completionHandler([.badge, .sound, .banner, .list])
//        }
//
//    }
    
    
    // 푸시 클릭: ex. 호두과자 장바구니에 담는 화면까지 넘어가는...
    // 유저가 푸시를 클릭했을 때에만 수신 확인 가능 (잘 보내졌는지? 확인하는건 불가능)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        print("Body: \(response.notification.request.content.body)")
//        print("userInfo: \(response.notification.request.content.userInfo)")
//
//        let userInfo = response.notification.request.content.userInfo
//
//        if userInfo[AnyHashable("sesac")] as? String == "project" {
//            print("SESAC PROJECT")
//        }else {
//            print("NOTHING")
//        }
//
//
//        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
//
//        if viewController is ViewController {
//            viewController.navigationController?.pushViewController(SettingViewController(), animated: true)
//
//        }else if viewController is ProfileViewController {
//            viewController.dismiss(animated: true)
//
//        }else if viewController is SettingViewController {
//            viewController.navigationController?.popViewController(animated: true)
//        }
//
//        print(viewController)
//    }
}




// MARK: - MessagingDelegate 프로토콜 채택
extension AppDelegate: MessagingDelegate {
    
    // 토큰 갱신 모니터링
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        UserDefaultManager.shared.fcmToken = fcmToken ?? ""
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}

