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
import CoreData
import YandexMobileAds



class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    @Environment(\.managedObjectContext) var managedObjectContext

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AppOpenAdManager.shared.loadAd()
        
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
    
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(isDarkModeOn ? .dark : .light) // Установите явную тему
        }
    }
    
    init() {
        YMAMobileAds.setUserConsent(true)
        YMAMobileAds.initializeSDK(completionHandler: completionHandler)
    }
    func completionHandler() {
        print(">>> Yandex Mobile Ads SDK initialized successfully")
    }
}
