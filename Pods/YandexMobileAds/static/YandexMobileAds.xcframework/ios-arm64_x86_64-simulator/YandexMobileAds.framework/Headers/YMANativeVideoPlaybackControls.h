#import <UIKit/UIKit.h>


@protocol YMANativeVideoPlaybackProgressControl;
@protocol YMANativeVideoPlaybackMuteControl;

NS_ASSUME_NONNULL_BEGIN

/**
 Class with playback controls.
 */
@interface YMANativeVideoPlaybackControls : NSObject



- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes an object of the YMANativeVideoPlaybackControls class with progress control and mute control.
 @param progressControl An object of the `UIView` class and conform to protocol `YMANativeVideoPlaybackProgressControl`.
 @param muteControl An object of the `UIView` class and conform to protocol `YMANativeVideoPlaybackMuteControl`.
 @return An object of the YMANativeVideoPlaybackControls class with progress control and mute control.
 */
- (instancetype)initWithProgressControl:(nullable UIView<YMANativeVideoPlaybackProgressControl> *)progressControl
                            muteControl:(nullable UIView<YMANativeVideoPlaybackMuteControl> *)muteControl;

@end

NS_ASSUME_NONNULL_END
