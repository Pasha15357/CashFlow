#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 YMAReward represents reward given to the user.
 */
@protocol YMAReward <NSObject>

/**
 Amount rewarded to the user
 */
@property (nonatomic, assign, readonly) NSInteger amount;

/**
 Type of the reward.
 */
@property (nonatomic, copy, readonly) NSString *type;

@end

NS_ASSUME_NONNULL_END
