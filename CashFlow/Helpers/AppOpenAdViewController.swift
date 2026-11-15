//
//  AppOpenAdViewController.swift
//  CashFlow
//
//  Created by Паша on 1/29/25.
//

import Foundation
import YandexMobileAds


final class AppOpenAdViewController: UIViewController {
    private var observer: NSObjectProtocol?
    private lazy var appOpenAdLoader: YMAAppOpenAdLoader = {
        let loader = YMAAppOpenAdLoader()
        loader.delegate = self
        return loader
    }()
    private var appOpenAd: YMAAppOpenAd?
    private var isAdShownOnColdStart = false
    
    func loadAd() {
        // Replace demo-appopenad-yandex with actual Ad Unit ID
        let configuration = YMAAdRequestConfiguration(adUnitID: "R-M-13895614-1" )
        self.appOpenAdLoader.loadAd(with: configuration)
    }
    
    func showAd() {
        self.appOpenAd?.show (from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            // do whatever you want when the app is brought back to the foreground
            showAd()
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

extension AppOpenAdViewController: YMAAppOpenAdLoaderDelegate {
    func appOpenAdLoader(_ adLoader: YMAAppOpenAdLoader, didLoad appOpenAd: YMAAppOpenAd) {
        //The ad was loaded successfully.Now you can show loaded ad.
        print(">>> YandexMobileAds \(#function)")
        self.appOpenAd = appOpenAd
        self.appOpenAd?.delegate = self
        if (!isAdShownOnColdStart) {
            showAd ()
            isAdShownOnColdStart = true
        }
    }
    func appOpenAdLoader(_ adLoader: YMAAppOpenAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        // Ad failed to load with AdRequestError.
        // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
        print(">>> YandexMobileAds \(#function) \(error)")
    }
}

extension AppOpenAdViewController: YMAAppOpenAdDelegate {
    func appOpenAd(_ appOpenAd: YMAAppOpenAd, didFailToShowWithError error: Error) {
        // Called when an ad failed to show.
        print(">>> YandexMobileAds \(#function) \(error)")
        loadAd()
    }
    func appOpenAdDidShow(_ appOpenAd: YMAAppOpenAd) {
        // Called when ad did shown.
        print (">>> YandexMobileAds \(#function)")
    }
    func appOpenAdDidDismiss(_appOpenAd: YMAAppOpenAd) {
        // Called when ad is dismissаed.
        print (">>> YandexMobileAds \(#function)")
        loadAd()
    }
    func appOpenAdDidClick(_ appOpenAd: YMAAppOpenAd) {
        // Called when a click is recorded for an ad.
        print (">>> YandexMobileAds \(#function)")
    }
    func appOpenAd(_ appOpenAd: YMAAppOpenAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        // Called when an impression is recorded for an ad.
        print(">>> YandexMobileAds \(#function) \(impressionData?.rawData ?? "")")
    }
}
      
      
