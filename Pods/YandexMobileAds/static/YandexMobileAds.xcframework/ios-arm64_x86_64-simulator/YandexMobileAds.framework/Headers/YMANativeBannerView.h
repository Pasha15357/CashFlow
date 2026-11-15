#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <YandexMobileAds/YMANativeImageLoadingObserver.h>

@protocol YMANativeAd;
@class YMANativeTemplateAppearance;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is a template for native advertising layout.
 */
@interface YMANativeBannerView : UIView

/**
 Loaded ad.
 */
@property (nonatomic, strong, nullable) id<YMANativeAd> ad;

/**
 Applies the appearance settings from the template.
 @param appearance Appearance of the ad.
 */
- (void)applyAppearance:(YMANativeTemplateAppearance *)appearance;

/**
 Calculates the height of the ad.
 @param ad Loaded ad.
 @param width The width of the ad.
 @param appearance Appearance of the ad.
 @return Returns the height of the ad.
 */
+ (CGFloat)heightWithAd:(id<YMANativeAd>)ad
                  width:(CGFloat)width
             appearance:(nullable YMANativeTemplateAppearance *)appearance;

@end

NS_ASSUME_NONNULL_END
