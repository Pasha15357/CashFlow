#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMAAdRequestConfiguration;

@protocol YMAInterstitialAdLoaderDelegate;
/**
 This class is responsible for loading an interstitial ad.
 */
@interface YMAInterstitialAdLoader : NSObject

/**
 Tracks ad lifecycle events.
 */
@property (nonatomic, weak, nullable) id<YMAInterstitialAdLoaderDelegate> delegate;

/**
 Loads an ad with the specified targeting data.
 @param requestConfiguration Request configuration for targeting.
 */
- (void)loadAdWithRequestConfiguration:(YMAAdRequestConfiguration *)requestConfiguration;

/**
 Cancel the ad loading, that launched in loadAdWithRequestConfiguration:requestConfiguration.
 */
- (void)cancelLoading;

@end

NS_ASSUME_NONNULL_END
