#import <Foundation/Foundation.h>

@class YMAAppOpenAd;
@class YMAAppOpenAdLoader;
@class YMAAdRequestError;

NS_ASSUME_NONNULL_BEGIN

@protocol YMAAppOpenAdLoaderDelegate <NSObject>

/**
 Notifies that the ad loaded successfully.
 @param adLoader A reference to an object of the YMAAppOpenAdLoader class that invoked the method.
 @param appOpenAd AppOpenAd ad that is loaded and ready to be displayed.
 */
- (void)appOpenAdLoader:(YMAAppOpenAdLoader *)adLoader
                didLoad:(YMAAppOpenAd *)appOpenAd;

/**
 Notifies that the ad failed to load.
 @param adLoader A reference to an object of the YMAAppOpenAdLoader class that invoked the method.
 @param error Information about the error (for details, see YMAAdErrorCode).
 */
- (void)appOpenAdLoader:(YMAAppOpenAdLoader *)adLoader
 didFailToLoadWithError:(YMAAdRequestError *)error;

@end

NS_ASSUME_NONNULL_END
