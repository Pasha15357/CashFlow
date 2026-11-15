#import <Foundation/Foundation.h>

/**
 Device types.
 */
typedef NS_OPTIONS(NSUInteger, YMADeviceType) {
/**
 The device is not defined.
 */
    YMADeviceTypeNone = 0,
/**
 Real device.
 */
    YMADeviceTypeHardware = 1 << 0,
/**
 A device simulator.
 */
    YMADeviceTypeSimulator  = 1 << 1
};
