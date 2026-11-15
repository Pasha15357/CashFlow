#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YMANativeAd;

/**
 This protocol is responsible for sending messages about image loading.
 */
@protocol YMANativeAdImageLoadingObserver <NSObject>

/**
 Notifies that the image is loaded successfully.
 @param ad A reference to the object that invoked the method.
 */
- (void)nativeAdDidFinishLoadingImages:(id<YMANativeAd>)ad;

@end

NS_ASSUME_NONNULL_END
