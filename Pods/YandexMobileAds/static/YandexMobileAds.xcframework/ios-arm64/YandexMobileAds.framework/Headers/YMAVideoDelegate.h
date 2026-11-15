#import <Foundation/Foundation.h>

@class YMAVideoController;

NS_ASSUME_NONNULL_BEGIN

@protocol YMAVideoDelegate <NSObject>

@optional

/**
 Notifies delegate when video finished playing.
 @param videoController Video controller related to video.
 */
- (void)videoControllerDidFinishPlayingVideo:(YMAVideoController *)videoController;

@end

NS_ASSUME_NONNULL_END
