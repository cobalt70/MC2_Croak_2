

//
//  CroakAppDelegatge.swift
//  Croak
//
//  Created by Giwoo Kim on 5/18/24.


import BackgroundTasks
import CoreMotion
import CoreLocation
import Foundation
import SwiftData
import UIKit
import SwiftUI
import FirebaseCore

import FirebaseMessaging

// ...

class CroakAppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    var window: UIWindow?
    var granted : Bool = false
  
    var accelData : [AccelData ] = []
    var posturePer10m : [PosturePer10m] = []
    var postureSnapShotFromGravity : [PostureSnapShotFromGravity] = []
    var postureSnapShotFromAngle : [PostureSnapShotFromAngle] = []
    var sharedModelContainer: ModelContainer

    var fcmRegTokenMessage : String = ""
    var fcmToken : String = ""
    var accessToken: String = ""
    let localNotificanManager = LocalNotificationManager.shared
    let fcmNotificationManager = FCMNotificationManager.shared
    
    override init() {
        self.sharedModelContainer = CroakApp().modelContainer
        
    
        super.init()
       
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 토큰 등록 오류: \(error)")
    }
    // Query는 swiftUI에서만 되나????
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
           print("APNs Device Token: \(tokenString)")
        
        // FCM 토큰 요청
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 오류: \(error)")
            } else if let token = token {
                print("FCM 토큰: \(token)")
                
                self.fcmToken = token
                self.localNotificanManager.fcmToken = token
                self.fcmNotificationManager.fcmToken = token
                // 토큰을 서버로 전송하는 등 필요한 작업 수행
            }
        }
       
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
      print("Firebase registration token: \(String(describing: fcmToken ?? ""))")
      let localNotificationManager = LocalNotificationManager.shared
      localNotificationManager.fcmToken = fcmToken ?? ""
        
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
      
        self.fcmToken = fcmToken ?? ""
        self.localNotificanManager.fcmToken = fcmToken ?? ""
        self.fcmNotificationManager.fcmToken = fcmToken ?? ""
        print("FCMToken : \(String(describing: fcmToken))")
       
        
    }

    

    
    func applicationWillTerminate(_ application: UIApplication) {
            // 앱 종료 시 수행할 작업
        print("App will be terminated soon")
        LocalNotificationManager.shared.removeAllNotifications()
       
        }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          
        FirebaseApp.configure()
        
        LocalNotificationManager.shared.setAuthorization()
        
        Messaging.messaging().delegate = self
      
        UNUserNotificationCenter.current().delegate = self
        
        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
                   // Firebase Console에서 보낸 원격 알림을 받았을 때 실행되는 메서드
                   print("Received remote notification on app launch: \(userInfo)")
                   // 알림 처리 로직 추가
               }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        
        print("Received remote notification in the background:  IN THE APPLICATION DELEGATE \(userInfo)")
        Messaging.messaging().appDidReceiveMessage(userInfo)
    
        
        // 백그라운드에서 알림 처리하는 코드 추가
        // 예: 데이터베이스에서 읽고 쓰기 작업 수행
        
        completionHandler(.newData) // 처리가 완료되면 핸들러를 호출하여 시스템에 알림합니다.
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        //for test purpose
        print("application Did Enter Background---")
        BGTaskScheduler.shared.getPendingTaskRequests(completionHandler: { taskRequests in
            for taskRequest in taskRequests {
                print("we have \(taskRequest.identifier)  pending BGTask ")
            }
        })
        
        
        
    }

}
    
 
extension CroakAppDelegate:  UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTime = Date()
        let koreanTime = dateFormatter.string(from: currentTime)
        print("notification willPresent :\(notification.request.identifier) | \(koreanTime)" )
        let userInfo = notification.request.content.userInfo
        print("willPresent UserInfo: ", userInfo)
        
//        여기서는 하지 체크하지 말고..그냥 DID Receive에서만 체크하기 중복되니까..
//        let postureFind = PostureFind()
//        
//        postureFind.handleMotionData(){ print( "handle Motion Data is finished") }
//        
        // 나중에    Messaging.messaging().appDidReceiveMessage(userInfo) 이건 왜 필요하지?? FIREBASE 용인데..역할이 뭐지???
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler([[.banner, .sound ]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTime = Date()
        let koreanTime = dateFormatter.string(from: currentTime)
        print("notification didReceive :\(response.notification.request.identifier) \(koreanTime)")
        let userInfo = response.notification.request.content.userInfo
        print("didReceive: userInfo: ", userInfo)
      
        let postureFind = PostureFind()
    
       
        postureFind.handleMotionData(){ print( "handle Motion Data is finished") }
        //FireBase 참고 왜 ?
        // 나중에    Messaging.messaging().appDidReceiveMessage(userInfo) 이건 왜 필요하지?? FIREBASE 용인데..역할이 뭐지???
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler()
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print("didReceiveRemoteNotification: \(userInfo)")
        // Silent push 알림을 처리하는 코드 추가
        // 예: 데이터베이스에서 읽고 쓰기 작업 수행
        print("사일런트 접수 완료")
        handleSilentPushNotification() { success in
            if success {
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }
    }
    
    private func handleSilentPushNotification(completionHandler: @escaping (Bool) -> Void ) {
        // 여기에 데이터베이스 읽기/쓰기 작업을 추가
        // 예시로 네트워크 호출 후 데이터베이스 업데이트
        print("handleSilentPushNotification")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let currentTime = Date()
        let koreanTime = dateFormatter.string(from: currentTime)
        print("핸들링 타임 " ,koreanTime)
    
        let postureFind = PostureFind()
        
        postureFind.handleMotionData(){ print( "handle Motion Data is finished" )}
        
        DispatchQueue.global().async {
            // 네트워크 요청 또는 데이터베이스 작업
            // 여기다 뭘넣지?? UIupdate
            
            let success = true // 작업 결과에 따라 true 또는 false 설정
            completionHandler(success)
        }
        
        
        
    }
}

