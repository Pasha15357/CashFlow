#import <Foundation/Foundation.h>

@protocol YMAReward;
@protocol YMAImpressionData;

@class YMARewardedAd;

NS_ASSUME_NONNULL_BEGIN

@protocol YMARewardedAdDelegate <NSObject>

/**
 Notifies that rewarded ad has rewarded the user.
 @param rewardedAd A reference to an object of the YMARewardedAd class that invoked the method.
 @param reward Reward given to the user.
 */
- (void)rewardedAd:(YMARewardedAd *)rewardedAd didReward:(id<YMAReward>)reward;

@optional

/**
 Notifies that the ad can't be displayed.
 @param rewardedAd A reference to an object of the YMARewardedAd class that invoked the method.
 @param error Information about the error (for details, see YMAAdErrorCode).
 */
- (void)rewardedAd:(YMARewardedAd *)rewardedAd didFailToShowWithError:(NSError *)error;

/**
 Called after the rewarded ad shows.
 @param rewardedAd A reference to an object of the YMARewardedAd class that invoked the method.
 */
- (void)rewardedAdDidShow:(YMARewardedAd *)rewardedAd;

/**
 Called after dismissing the rewarded ad.
 @param rewardedAd A reference to an object of the YMARewardedAd class that invoked the method.
 */
- (void)rewardedAdDidDismiss:(YMARewardedAd *)rewardedAd;

/**
 Notifies that the user has clicked on the ad.
 @param rewardedAd A reference to an object of the YMARewardedAd class that invoked the method.
 */
- (void)rewardedAdDidClick:(YMARewardedAd *)rewardedAd;

/**
 Notifies delegate when an impression was tracked.
 @param rewardedAd A reference to an object of the YMARewardedAd class that invoked the method.
 @param impressionData Ad impression-level revenue data.
 */
- (void)rewardedAd:(YMARewardedAd *)rewardedAd
didTrackImpressionWithData:(nullable id<YMAImpressionData>)impressionData;

@end

NS_ASSUME_NONNULL_END
