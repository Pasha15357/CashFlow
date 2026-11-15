#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A protocol with impression-level revenue data.
 */
@protocol YMAImpressionData <NSObject, NSCoding>

/**
 A raw impression-level revenue data, string with json.
 */
@property (nonatomic, strong, readonly) NSString *rawData;

@end

NS_ASSUME_NONNULL_END
