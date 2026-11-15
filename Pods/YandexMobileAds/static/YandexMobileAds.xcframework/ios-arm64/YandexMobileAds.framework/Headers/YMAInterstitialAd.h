#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMAAdInfo;

@protocol YMAInterstitialAdDelegate;

/**
 This class is responsible for showing an interstitial ad.
 */
@interface YMAInterstitialAd : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/**
 Information data for ad
 */
@property (nonatomic, strong, nullable, readonly) YMAAdInfo *adInfo;

/**
 Tracks ad lifecycle events.
 */
@property (nonatomic, weak, nullable) id<YMAInterstitialAdDelegate> delegate;

/**
 Use this method to display an interstitial ad after preloading.
 @param viewController An object of the `UIViewController` class, which is used to display an interstitial ad.
 */
- (void)showFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
