#import <Foundation/Foundation.h>

@protocol YMANativeVideoPlaybackMuteControl;

NS_ASSUME_NONNULL_BEGIN

@protocol YMANativeVideoPlaybackMuteControlDelegate <NSObject>

/**
 Notifies that the user has clicked on mute control.
 @param muteControl A reference to the object that invoked the method.
 @param isMuted A flag for representing current mute control state.
 */
- (void)muteControl:(id<YMANativeVideoPlaybackMuteControl>)muteControl didChangeIsMuted:(BOOL)isMuted;

@end

NS_ASSUME_NONNULL_END
