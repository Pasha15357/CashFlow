#import <Foundation/Foundation.h>

@protocol YMAAppOpenAdLoaderDelegate;

@class YMAAdRequestConfiguration;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is responsible for loading an app open ad.
 */
@interface YMAAppOpenAdLoader : NSObject

/**
 Tracks ad lifecycle events.
 */
@property (nonatomic, weak, nullable) id<YMAAppOpenAdLoaderDelegate> delegate;

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
