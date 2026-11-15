#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMAAdInfo;

@protocol YMARewardedAdDelegate;

/**
 This class is responsible for showing a rewarded ad.
 */
@interface YMARewardedAd : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/**
 Tracks ad lifecycle events.
 */
@property (nonatomic, weak, nullable) id<YMARewardedAdDelegate> delegate;

/**
 Information data for ad
 */
@property (nonatomic, strong, nullable, readonly) YMAAdInfo *adInfo;

/**
 Use this method to display a rewarded ad after preloading.
 @param viewController An object of the `UIViewController` class, which is used to display a rewarded ad.
 */
- (void)showFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
