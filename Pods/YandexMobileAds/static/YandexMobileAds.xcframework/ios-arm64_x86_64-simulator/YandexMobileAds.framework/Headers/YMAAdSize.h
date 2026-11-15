#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A class with size information for requested ad.
 */
@interface YMAAdSize : NSObject

@property (nonatomic, readonly) CGFloat width;

@property (nonatomic, readonly) CGFloat height;

- (instancetype)initWithSize:(CGSize)size;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
