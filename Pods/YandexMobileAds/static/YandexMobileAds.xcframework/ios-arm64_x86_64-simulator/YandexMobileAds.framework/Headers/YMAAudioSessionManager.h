#import <Foundation/Foundation.h>


@protocol YMAAudioSessionManagerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 This class allows you to manipulate with an audio session.
 */
@interface YMAAudioSessionManager : NSObject

/**
 An object implementing the YMAAudioSessionManagerDelegate protocol
 that receives events triggered by the audio session events.
 */
@property (nonatomic, weak, nullable) id<YMAAudioSessionManagerDelegate> delegate;

/**
 Indicates whether the application will manage audio session.
 */
@property (nonatomic, assign) BOOL isAutomaticallyManaged;



+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;



@end

NS_ASSUME_NONNULL_END
