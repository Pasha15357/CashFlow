#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A class with error for requested ad.
 */
@interface YMAAdRequestError : NSObject

/**
The AdUnit ID is a unique identifier in the R-M-XXXXXX-Y format, which is assigned in the Partner interface.
*/
@property (nonatomic, strong, readonly, nullable) NSString *adUnitId;

/**
Error for  requested ad
 */
@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWithAdUnitId:(nullable NSString *)adUnitId error:(NSError *)error;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
