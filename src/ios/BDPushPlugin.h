#import <Cordova/CDV.h>
#import <CoreLocation/CoreLocation.h>

@interface CDVBDPush : CDVPlugin
@property (nonatomic) CDVPluginResult *result;

- (void)registerNotifications:(CDVInvokedUrlCommand*)command;

- (void)unregisterNotifications:(CDVInvokedUrlCommand*)command;


@end