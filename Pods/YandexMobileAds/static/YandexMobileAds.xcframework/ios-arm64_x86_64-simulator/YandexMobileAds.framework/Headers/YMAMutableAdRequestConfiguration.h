#import "YMAAdRequestConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An editable version of the YMAAdRequestConfiguration class configuring native ad loading.
 */
@interface YMAMutableAdRequestConfiguration : YMAAdRequestConfiguration

/**
 User age.
 */
@property (nonatomic, strong, nullable) NSNumber *age;

/**
 The search query that the user entered in the app.
 */
@property (nonatomic, copy, nullable) NSString *contextQuery;

/**
 List of tags. Matches the context in which the ad will be displayed.
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *contextTags;

/**
 The gender of the user. For a list of values, see the YMAGender section.
 */
@property (nonatomic, copy, nullable) NSString *gender;

/**
 User location.
 */
@property (nonatomic, copy, nullable) CLLocation *location;

/**
 Preferred ad theme.
 */
@property (nonatomic, assign) YMAAdTheme adTheme;

/**
 Bidding data for ad loading from mediation.
 */
@property (nonatomic, copy, nullable) NSString *biddingData;

/**
 A set of arbitrary input parameters.
 */
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString*> *parameters;

@end

NS_ASSUME_NONNULL_END
