#import <Foundation/Foundation.h>

@class YMAAppOpenAd;

NS_ASSUME_NONNULL_BEGIN

@protocol YMAAppOpenAdDelegate <NSObject>

@optional

/**
 Notifies that the ad can't be displayed.
 @param appOpenAd A reference to an object of the YMAAppOpenAd class that invoked the method.
 @param error Information about the error (for details, see YMAAdErrorCode).
 */
- (void)appOpenAd:(YMAAppOpenAd *)appOpenAd didFailToShowWithError:(NSError *)error;

/**
 Called after the app open ad shows.
 @param appOpenAd A reference to an object of the YMAAppOpenAd class that invoked the method.
 */
- (void)appOpenAdDidShow:(YMAAppOpenAd *)appOpenAd;

/**
 Called after dismissing the app open ad.
 @param appOpenAd A reference to an object of the YMAAppOpenAd class that invoked the method.
 */
- (void)appOpenAdDidDismiss:(YMAAppOpenAd *)appOpenAd;

/**
 Notifies that the user has clicked on the ad.
 @param appOpenAd A reference to an object of the YMAAppOpenAd class that invoked the method.
 */
- (void)appOpenAdDidClick:(YMAAppOpenAd *)appOpenAd;

/**
 Notifies delegate when an impression was tracked.
 @param appOpenAd A reference to an object of the YMAAppOpenAd class that invoked the method.
 @param impressionData Ad impression-level revenue data.
 */
- (void)appOpenAd:(YMAAppOpenAd *)appOpenAd
didTrackImpressionWithData:(nullable id<YMAImpressionData>)impressionData;

@end

NS_ASSUME_NONNULL_END
