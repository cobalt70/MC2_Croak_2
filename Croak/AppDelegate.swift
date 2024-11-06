////
////  AppDelegate.swift
////  Croak
////
////  Created by jeong hyein on 5/14/24.
////
//
//import UIKit
//import BackgroundTasks
//import SwiftData
//import CoreData
//
////@main
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//    
//    var modelContainer: ModelContainer = {
//        let schema = Schema([PosturePer10m.self])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        
//        do {
//            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
//            return container
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Model")
//        container.loadPersistentStores { storeDescription, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
//    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
////        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(saveDataToSwiftData), userInfo: nil, repeats: true)
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.giwoo.andy.Croak", using: nil) { task in
//            self.handleProcessingTask(task: task as! BGProcessingTask)
//        }
//        applicationDidEnterBackground(application)
//        //        handleProcessingTask(task: BGProcessingTask)
////        print("app")
////        
////        for _ in 0...3 {
////                        print("0.5번")
////            
////                saveDataToSwiftData()
////            sleep(3)
////            scheduleProcessingTask()
////        }
//        
//        return true
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        
//        var backgroundTask: UIBackgroundTaskIdentifier  = .invalid
//        print("AA")
//        backgroundTask = application.beginBackgroundTask(withName: "BackgroundTask" ,expirationHandler: {
//            // 백그라운드 작업이 만료되면 코드를 정리하거나 사용자에게 알립니다.\
//            print("AA")
//    //        scheduleProcessingTask()
//            for _ in 0...3 {
//                print("aa")
//                self.saveDataToSwiftData()
//                print("BB")
//                sleep(3)
//            }
//             application.endBackgroundTask( backgroundTask)
//            backgroundTask = .invalid
//        })
//
//         application.endBackgroundTask(backgroundTask)
//        backgroundTask = .invalid
//        
////        print("AA")
//////        scheduleProcessingTask()
////        for _ in 0...3 {
////            print("aa")
////            saveDataToSwiftData()
////            print("BB")
////            sleep(3)
////        }
//    }
//    
//    func handleProcessingTask(task: BGProcessingTask) {
//
//        print("handle")
//        scheduleProcessingTask()
//
////        performDataTask {
////            task.setTaskCompleted(success: $0)
////        }
//    }
//    
//    func scheduleProcessingTask() {
//        print("schedule")
//        let request = BGProcessingTaskRequest(identifier: "com.giwoo.andy.Croak")
//        request.requiresNetworkConnectivity = false
//        request.requiresExternalPower = false
//        request.earliestBeginDate = Date()
//        /*request.earliestBeginDate = Date(timeIntervalSinceNow: 3)*/ // 1분 후
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("BGTaskScheduler 요청 실패: \(error)")
//        }
//    }
//    
//
//    
//    func saveDataToSwiftData() {
//        print("Save")
//        do {
//            print("save2s")
//            let context = modelContainer.mainContext
//            let newItem = PosturePer10m(id: UUID(), date: "Aa", startTime: returnDateToTime(param: Date()), posture: "ww", tempDate: Date())
//            print(Date())
//            context.insert(newItem)
//            try context.save()
////            completion(true)
//        } catch {
//            print("SwiftData 저장 실패: \(error)")
////            completion(false)
//        }
//    }
//    
//
//}

//
//import UIKit
//import FirebaseMessaging
//import UserNotifications
//import Firebase
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    var window: UIWindow?
//    
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//   //     FirebaseApp.configure()
//        UNUserNotificationCenter.current().delegate = self
//        Messaging.messaging().delegate = self
//        
//        // 권한 요청
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            print("Permission granted: \(granted)")
//        }
//        
//        application.registerForRemoteNotifications()
//        return true
//    }
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
//}
//
//@available(iOS 10, *)
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    // 포그라운드 상태에서 알림 처리
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([[.alert, .sound, .badge]])
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        completionHandler()
//    }
//}
//
//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("FCM 등록 토큰: \(String(describing: fcmToken))")
//        // 등록 토큰을 서버로 전송하거나 로그에 출력합니다.
//    }
//}
//

