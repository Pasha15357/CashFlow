#import <Foundation/Foundation.h>

@class YMARewardedAdLoader;
@class YMARewardedAd;
@class YMAAdRequestError;

NS_ASSUME_NONNULL_BEGIN

@protocol YMARewardedAdLoaderDelegate <NSObject>

/**
 Notifies that the ad loaded successfully.
 @param adLoader A reference to an object of the YMARewardedAdLoader class that invoked the method.
 @param rewardedAd A reference to an object of the YMARewardedAd class that invoked the method.
 */
- (void)rewardedAdLoader:(YMARewardedAdLoader *)adLoader
                 didLoad:(YMARewardedAd *)rewardedAd;

/**
 Notifies that the ad failed to load.
 @param adLoader A reference to an object of the YMARewardedAdLoader class that invoked the method.
 @param error Information about the error (for details, see YMAAdErrorCode).
 */
- (void)rewardedAdLoader:(YMARewardedAdLoader *)adLoader
  didFailToLoadWithError:(YMAAdRequestError *)error;

@end

NS_ASSUME_NONNULL_END
