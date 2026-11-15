#import <Foundation/Foundation.h>

/* Yandex Mobile Native Ads error domain. */
extern NSString *const kYMANativeAdErrorDomain;

/**
 Error description.
 */
typedef NS_ENUM(NSInteger, YMANativeErrorCode) {
    /**
     Occurs when binding an ad if the `UIView` is omitted for a required asset.
     */
    YMANativeAdErrorCodeNoViewForAsset,
    /**
     Occurs when the nil value is passed to the ad binding method as the `View`.
     */
    YMANativeAdErrorCodeInvalidViewForBinding
};
