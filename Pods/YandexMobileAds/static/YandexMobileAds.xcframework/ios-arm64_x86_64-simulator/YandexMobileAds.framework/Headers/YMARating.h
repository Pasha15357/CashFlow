#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The protocol sets and receives the rating value.
 */
@protocol YMARating <NSObject>

/**
 Sets the rating value in the range [0; 5].
 @param rating The rating value in the range [0; 5].
 */
- (void)setRating:(nullable NSNumber *)rating;

/**
 Returns the rating value in the range [0; 5].
 @return Rating value.
 */
- (nullable NSNumber *)rating;

@end

NS_ASSUME_NONNULL_END
