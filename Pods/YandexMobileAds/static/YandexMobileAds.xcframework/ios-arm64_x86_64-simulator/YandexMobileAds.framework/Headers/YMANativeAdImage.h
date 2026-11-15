#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 This class describes an image as a native ad asset.
 @discussion The image sizes are always available, but the images themselves are only available after loading.
 */
@interface YMANativeAdImage : NSObject




/**
 Image size.
 */
@property (nonatomic, assign, readonly) CGSize size;

/**
 Loaded image. The image is available only after loading.
 */
@property (nonatomic, strong, readonly, nullable) UIImage *imageValue;




@end

NS_ASSUME_NONNULL_END
