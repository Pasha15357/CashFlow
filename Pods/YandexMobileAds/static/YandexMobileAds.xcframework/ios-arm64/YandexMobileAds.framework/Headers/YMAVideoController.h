#import <Foundation/Foundation.h>


@protocol YMAVideoDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 YMAVideoController manages video content of the ad.
 */
@interface YMAVideoController : NSObject

/**
 Delegate is notified about video playback events.
 */
@property (nonatomic, weak, nullable) id<YMAVideoDelegate> delegate;



@end

NS_ASSUME_NONNULL_END
