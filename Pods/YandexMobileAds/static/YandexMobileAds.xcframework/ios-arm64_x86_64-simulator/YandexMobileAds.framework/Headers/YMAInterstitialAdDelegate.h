#import <Foundation/Foundation.h>

@protocol YMAImpressionData;

@class YMAInterstitialAd;

NS_ASSUME_NONNULL_BEGIN

@protocol YMAInterstitialAdDelegate <NSObject>

@optional

/**
 Notifies that the ad can't be displayed.
 @param interstitialAd A reference to an object of the YMAInterstitialAd class that invoked the method.
 @param error Information about the error (for details, see YMAAdErrorCode).
 */
- (void)interstitialAd:(YMAInterstitialAd *)interstitialAd didFailToShowWithError:(NSError *)error;

/**
 Called after the interstitial ad shows.
 @param interstitialAd A reference to an object of the YMAInterstitialAd class that invoked the method.
 */
- (void)interstitialAdDidShow:(YMAInterstitialAd *)interstitialAd;

/**
 Called after dismissing the interstitial ad.
 @param interstitialAd A reference to an object of the YMAInterstitialAd class that invoked the method.
 */
- (void)interstitialAdDidDismiss:(YMAInterstitialAd *)interstitialAd;

/**
 Notifies that the user has clicked on the ad.
 @param interstitialAd A reference to an object of the YMAInterstitialAd class that invoked the method.
 */
- (void)interstitialAdDidClick:(YMAInterstitialAd *)interstitialAd;

/**
 Notifies delegate when an impression was tracked.
 @param interstitialAd A reference to an object of the YMAInterstitialAd class that invoked the method.
 @param impressionData Ad impression-level revenue data.
 */
- (void)interstitialAd:(YMAInterstitialAd *)interstitialAd
didTrackImpressionWithData:(nullable id<YMAImpressionData>)impressionData;

@end

NS_ASSUME_NONNULL_END
