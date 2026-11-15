#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


NS_ASSUME_NONNULL_BEGIN

/**
 This class is responsible for the banner size.
 */
@interface YMABannerAdSize : NSObject

/**
 The initial size of the banner.
 @discussion The actual size of the banner is determined when
 calling the [YMAAdViewDelegate adViewDidLoad:] method of the YMAAdViewDelegate class.
 */
@property (nonatomic, assign, readonly) CGSize size;



- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/**
 Creates an object of the YMABannerAdSize class with the specified maximum height and width of the banner. The method is available for internal SDK logic. We recommend using inlineSizeWithWidth for the feed and stickySizeWithContainerWidth if you want to anchor the banenr to the top or bottom of the screen.
 @param width Width of the banner.
 @param height Height of the banner.
 @return An object of the YMABannerAdSize class with the fixed size.
 */
+ (instancetype)fixedSizeWithWidth:(CGFloat)width height:(CGFloat)height;

/**
 Creates an object of the YMABannerAdSize class with the specified maximum height and width of the banner.
 @warning If the actual size of the banner is less than the size of the container,
 an adaptive layer is drawn under the banner.
 @param width Width of the banner.
 @param height Maximum height available for an adaptive banner.
 @return An object of the YMABannerAdSize class with the specified maximum size of the banner.
 */
+ (instancetype)inlineSizeWithWidth:(CGFloat)width maxHeight:(CGFloat)height;

/**
 Creates an object of the YMABannerAdSize class with the specified width of the banner.
 @discussion Returns sticky banner size with the given width.
 @param width Width of the banner.
 @return An object of the YMABannerAdSize class with the specified width of the sticky banner.
 */
+ (instancetype)stickySizeWithContainerWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
