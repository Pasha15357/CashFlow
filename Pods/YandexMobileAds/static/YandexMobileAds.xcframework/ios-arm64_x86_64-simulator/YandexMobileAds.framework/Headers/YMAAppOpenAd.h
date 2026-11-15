#import <UIKit/UIKit.h>


@protocol YMAAppOpenAdDelegate;
@protocol YMAImpressionData;

@class YMAAdRequest;
@class YMAAdInfo;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is responsible for loading an app open ad.
 */
@interface YMAAppOpenAd : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/**
 Information data for ad
 */
@property (nonatomic, strong, readonly, nullable) YMAAdInfo *adInfo;

/**
 Tracks ad lifecycle events.
 */
@property (nonatomic, weak, nullable) id<YMAAppOpenAdDelegate> delegate;

/**
 Use this method to display an app open ad after preloading.
 @param viewController An object of the `UIViewController` class, which is used to display an app open  ad.
 */
- (void)showFromViewController:(UIViewController *)viewController;

@end


NS_ASSUME_NONNULL_END
