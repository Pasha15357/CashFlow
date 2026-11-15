#import <Foundation/Foundation.h>

@protocol YMANativeVideoPlaybackMuteControlDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol YMANativeVideoPlaybackMuteControl <NSObject>

/**
 Delegate is notified about video playback mute control events.
 */
@property (nonatomic, weak, nullable) id<YMANativeVideoPlaybackMuteControlDelegate> delegate;

/**
 Configures a mute control with specified isMuted flag.
 @param isMuted Flag for setting mute/unmute state.
 */
- (void)configureWithIsMuted:(BOOL)isMuted;

@end

NS_ASSUME_NONNULL_END
