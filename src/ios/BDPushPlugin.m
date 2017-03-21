#import "BDPushPlugin.h"
#import "BPush.h"

@implementation CDVBDPush{
    NSNotificationCenter *_observer;
}

- (void)registerNotifications:(CDVInvokedUrlCommand*)command {
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:CDVRemoteNotification
                  object:nil
                  queue:[NSOperationQueue mainQueue]
                  usingBlock:^(NSNotification *note) {
                        NSData *deviceToken = [note object];
                        [BPush registerDeviceToken:deviceToken];
                        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
                            NSLog(@"%@", result);
                            // "app_id" = 123456;
                            // "channel_id" = 222222222;
                            // "error_code" = 0;
                            // "request_id" = 43214321432;
                            // "response_params" =     {
                            //     appid = 123456;
                            //     "channel_id" = 222222222;
                            //     "user_id" = 111111111;
                            // };
                            // "user_id" = 111111111;
                            if ([self checkResult:result]) {
                                self.result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
                            }
                            else {
                                self.result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:result];
                            }
                            [[NSNotificationCenter defaultCenter] removeObserver:_observer];
                            [self.commandDelegate sendPluginResult:self.result callbackId:command.callbackId];
                      }];
                  }];

    UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)unregisterNotifications:(CDVInvokedUrlCommand*)command {
    [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
        if ([self checkResult:result]) {
            self.result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        else{
            self.result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:self.result callbackId:command.callbackId];
    }];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (BOOL)checkResult:(id)result {
    NSString *resultStr = result[@"error_code"];
    if (!resultStr || [[resultStr description] isEqualToString:@"0"]){
        return YES;
    }
    return NO;
}

@end