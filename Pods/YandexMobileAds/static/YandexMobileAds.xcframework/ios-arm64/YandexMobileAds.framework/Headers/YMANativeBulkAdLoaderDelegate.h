#import <Foundation/Foundation.h>

@class YMANativeBulkAdLoader;
@protocol YMANativeAd;

NS_ASSUME_NONNULL_BEGIN

@protocol YMANativeBulkAdLoaderDelegate <NSObject>

/**
 Notifies that a native ads are loaded.
 @param nativeBulkAdLoader The loader that sends the message.
 @param ads Loaded native ads.
 */
- (void)nativeBulkAdLoader:(YMANativeBulkAdLoader *)nativeBulkAdLoader didLoadAds:(NSArray<id<YMANativeAd>> *)ads;

/**
 Notifies that the ads failed to load.
 @param nativeBulkAdLoader The loader that sends the message.
 @param error Information about the error (for details, see YMAAdErrorCode).
 */
- (void)nativeBulkAdLoader:(YMANativeBulkAdLoader *)nativeBulkAdLoader didFailLoadingWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
