#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMANativeVideoPlaybackControls;

/**
 Objects that implement this protocol allow to set custom video playback controls;
 */
@protocol YMANativeVideoControlsCustomizable <NSObject>

/**
 Sets an NativeVideoPlaybackControls
 - Parameter videoPlaybackControls: Video playback controls.
 */
- (void)setVideoPlaybackControls:(YMANativeVideoPlaybackControls *)videoPlaybackControls;

@end

NS_ASSUME_NONNULL_END
