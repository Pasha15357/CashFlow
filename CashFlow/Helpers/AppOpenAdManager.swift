//import Foundation
//import YandexMobileAds
//import UIKit
//
//final class AppOpenAdManager: NSObject {
//    static let shared = AppOpenAdManager()
//    
//    private lazy var appOpenAdLoader: YMAAppOpenAdLoader = {
//        let loader = YMAAppOpenAdLoader()
//        loader.delegate = self
//        return loader
//    }()
//    
//    private var appOpenAd: YMAAppOpenAd?
//    private var isAdShownOnColdStart = false
//    
//    private override init() {
//        super.init()
//        loadAd()
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(showAdIfAvailable), name: UIApplication.willEnterForegroundNotification, object: nil)
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    func loadAd() {
//        let configuration = YMAAdRequestConfiguration(adUnitID: "R-M-13895614-1")
//        appOpenAdLoader.loadAd(with: configuration)
//    }
//    
//    @objc func showAdIfAvailable() {
//        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return }
//        if let ad = appOpenAd {
//            ad.show(from: rootViewController)
//        }
//    }
//}
//
//extension AppOpenAdManager: YMAAppOpenAdLoaderDelegate {
//    func appOpenAdLoader(_ adLoader: YMAAppOpenAdLoader, didLoad appOpenAd: YMAAppOpenAd) {
//        self.appOpenAd = appOpenAd
//        self.appOpenAd?.delegate = self
//        
//        if !isAdShownOnColdStart {
//            showAdIfAvailable()
//            isAdShownOnColdStart = true
//        }
//    }
//    
//    func appOpenAdLoader(_ adLoader: YMAAppOpenAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
//        print(">>> YandexMobileAds didFailToLoadWithError: \(error)")
//    }
//}
//
//extension AppOpenAdManager: YMAAppOpenAdDelegate {
//    func appOpenAd(_ appOpenAd: YMAAppOpenAd, didFailToShowWithError error: Error) {
//        print(">>> YandexMobileAds didFailToShowWithError: \(error)")
//        loadAd()
//    }
//    
//    func appOpenAdDidDismiss(_ appOpenAd: YMAAppOpenAd) {
//        print(">>> YandexMobileAds didDismiss")
//        loadAd()
//    }
//    
//    func appOpenAdDidShow(_ appOpenAd: YMAAppOpenAd) {
//        print(">>> YandexMobileAds didShow")
//    }
//}

import GoogleMobileAds
import UIKit

class AppOpenAdManager: NSObject, GADFullScreenContentDelegate {
    static let shared = AppOpenAdManager()

    private var appOpenAd: GADAppOpenAd?
    private var isLoading = false
    private var isShowing = false
    private var loadTime: Date?

    /// Тестовый ID для App Open Ads
    private let adUnitID = "ca-app-pub-3940256099942544/3419835294"

    // MARK: - Загрузка рекламы
    func loadAd() {
        guard !isLoading else { return }

        isLoading = true
        print("Загрузка App Open Ad...")

        GADAppOpenAd.load(withAdUnitID: adUnitID,
                          request: GADRequest()) { ad, error in
            self.isLoading = false

            if let error = error {
                print("Ошибка загрузки App Open Ad: \(error.localizedDescription)")
                return
            }

            self.appOpenAd = ad
            self.loadTime = Date()
            self.appOpenAd?.fullScreenContentDelegate = self
            print("App Open Ad — загружена ✔")
        }
    }

    // MARK: - Показ рекламы
    func showAdIfAvailable() {
        guard let ad = appOpenAd,
              !isShowing,
              wasLoadTimeValid(4) else {

            print("Реклама недоступна — загружаю новую...")
            loadAd()
            return
        }

        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
            .first else {
            return
        }

        print("Показываю App Open Ad...")
        isShowing = true
        ad.present(fromRootViewController: root)
    }

    // MARK: - Делегаты
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App Open Ad закрыта.")
        isShowing = false
        appOpenAd = nil
        loadAd()   // сразу загружаем новую для будущего показа
    }

    // MARK: - Проверка актуальности
    private func wasLoadTimeValid(_ hours: Int) -> Bool {
        guard let loadTime = loadTime else { return false }
        return Date().timeIntervalSince(loadTime) < Double(hours) * 3600
    }
}
