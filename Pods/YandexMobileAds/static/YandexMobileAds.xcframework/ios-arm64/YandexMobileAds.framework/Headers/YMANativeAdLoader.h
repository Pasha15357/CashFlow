#import <Foundation/Foundation.h>


@protocol YMANativeAd;
@protocol YMANativeAdLoaderDelegate;
@class YMANativeAdRequestConfiguration;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is responsible for loading native ads.
 */
@interface YMANativeAdLoader : NSObject

/**
 Monitors the process of loading native ads.
 */
@property (nonatomic, weak, nullable) id<YMANativeAdLoaderDelegate> delegate;

/**
 Loads an ad with the specified targeting data.
 @param requestConfiguration Request configuration for targeting.
 */
- (void)loadAdWithRequestConfiguration:(YMANativeAdRequestConfiguration *)requestConfiguration;



@end

/**
 The protocol defines the methods of a delegate that monitors the ad loading process.
 @discussion The methods are invoked by an object of the YMANativeAdLoader class.
 */
@protocol YMANativeAdLoaderDelegate <NSObject>

@optional

/**
 Notifies that a native ad is loaded.
 @param loader The loader that sends the message.
 @param ad Native ad that is loaded and ready to be displayed.
 */
- (void)nativeAdLoader:(YMANativeAdLoader *)loader didLoadAd:(id<YMANativeAd>)ad;



/**
 Notifies that the ad failed to load.
 @param loader The loader that sends the message.
 @param error Information about the error (for details, see YMAAdErrorCode).
 */
- (void)nativeAdLoader:(YMANativeAdLoader *)loader didFailLoadingWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
