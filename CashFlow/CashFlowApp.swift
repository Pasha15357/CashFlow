//
//  CashFlowApp.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI
import FirebaseCore
import UserNotifications
import GoogleMobileAds



class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
        UserDefaults.standard.set(["ru"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        return true
    }
}


@main
struct CashFlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
