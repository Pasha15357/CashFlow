#import <Foundation/Foundation.h>

@protocol YMANativeBulkAdLoaderDelegate;
@class YMANativeAdRequestConfiguration;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is responsible for loading native ads.
 */
@interface YMANativeBulkAdLoader : NSObject

/**
 An object that implements the YMANativeBulkAdLoaderDelegate protocol that tracks the progress of bulk native ad loading.
 */
@property (nonatomic, weak, nullable) id<YMANativeBulkAdLoaderDelegate> delegate;

/**
 Loads an ad with the specified targeting data.
 @param requestConfiguration Request configuration for targeting.
 @param adsCount Count of requested ads.
 */
- (void)loadAdsWithRequestConfiguration:(YMANativeAdRequestConfiguration *)requestConfiguration
                               adsCount:(NSUInteger)adsCount;

@end

NS_ASSUME_NONNULL_END
