//
//  iZettle.h
//  iZettle
//
//  Created by MobileStar on 24/9/17.
//
//

#import <Cordova/CDVPlugin.h>


@interface iZettle : CDVPlugin
/*
 iZettle Support On/Off
 Detect iZettle connected
 Get Device Name
 Get iZettle Interface Version
 */
    
- (void)init_iZettle:(CDVInvokedUrlCommand*)command;
- (void)charge:(CDVInvokedUrlCommand*)command;
- (void)settings:(CDVInvokedUrlCommand*)command;
- (void)lastPaymentInfo:(CDVInvokedUrlCommand*)command;
- (void)refundLastPayment:(CDVInvokedUrlCommand*)command;
- (void)enforceAccount:(CDVInvokedUrlCommand*)command;
    
@end
