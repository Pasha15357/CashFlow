#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


NS_ASSUME_NONNULL_BEGIN

/**
 YMANativeAdMedia represents media asset.
 */
@interface YMANativeAdMedia : NSObject

/**
 Media aspect ratio (width/height).
 */
@property (nonatomic, assign, readonly) CGFloat aspectRatio;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;



@end

NS_ASSUME_NONNULL_END

