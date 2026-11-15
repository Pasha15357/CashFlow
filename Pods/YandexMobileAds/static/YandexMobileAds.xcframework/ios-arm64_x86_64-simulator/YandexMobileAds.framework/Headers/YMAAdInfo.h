#import "YMAAdSize.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A class with information data for ad.
 */
@interface YMAAdInfo : NSObject

/**
 The AdUnit ID is a unique identifier in the R-M-XXXXXX-Y format, which is assigned in the Partner interface.
 */
@property (nonatomic, strong, readonly) NSString *adUnitId;

/**
 Size of downloaded ad.
 */
@property (nonatomic, strong, readonly, nullable) YMAAdSize *adSize;

- (instancetype)initWithAdUnitId:(NSString *)adUnitId adSize:(nullable YMAAdSize *)adSize;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
