#import <Foundation/Foundation.h>

@class YMAInterstitialAdLoader;
@class YMAInterstitialAd;
@class YMAAdRequestError;

NS_ASSUME_NONNULL_BEGIN

@protocol YMAInterstitialAdLoaderDelegate <NSObject>

/**
 Notifies that the ad loaded successfully.
 @param adLoader A reference to an object of the YMAInterstitialAdLoader class that invoked the method.
 @param interstitialAd Interstitial ad that is loaded and ready to be displayed.
 */
- (void)interstitialAdLoader:(YMAInterstitialAdLoader *)adLoader
                     didLoad:(YMAInterstitialAd *)interstitialAd;

/**
 Notifies that the ad failed to load.
 @param adLoader A reference to an object of the YMAInterstitialAdLoader class that invoked the method.
 @param error Information about the error (for details, see YMAAdErrorCode).
 */
- (void)interstitialAdLoader:(YMAInterstitialAdLoader *)adLoader
      didFailToLoadWithError:(YMAAdRequestError *)error;

@end

NS_ASSUME_NONNULL_END
