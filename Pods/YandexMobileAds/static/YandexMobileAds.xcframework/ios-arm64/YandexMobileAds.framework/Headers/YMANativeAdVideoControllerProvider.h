#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMANativeAdVideoController;

/**
 This protocol allows to get NativeAdVideoController from NativeAd
 */
@protocol YMANativeAdVideoControllerProvider <NSObject>

/**
 VideoController provides playback control for ad video.
 */
@property (nonatomic, strong, readonly, nullable) YMANativeAdVideoController *videoController;

@end

NS_ASSUME_NONNULL_END
