#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YMANativeVideoPlaybackProgressControl <NSObject>

/**
 Configures a progress control with position and duration.
 @param position Position of current OutStream ad.
 @param duration Duration of current OutStream ad.
 */
- (void)configureWithPosition:(NSTimeInterval)position duration:(NSTimeInterval)duration;

/**
 Resets a video progress.
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
