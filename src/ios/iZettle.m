//
//  iZettle.m
//  iZettle
//
//  Created by Mobile Star on 25/9/17.
//
//

#import <Cordova/CDVAvailability.h>
#import "iZettle.h"

@import iZettleSDK;
#import <iZettleSDK/iZettleSDK.h>


@interface iZettle()

@property (retain) NSString* callbackId;

@end

@implementation iZettle{
    iZettleSDKPaymentInfo *_lastPaymentInfo;
    NSString *_lastReference;
    NSDate *_timestamp;
    NSError *_lastError;
    NSNumberFormatter *_numberFormatter;
}

- (void)dealloc
{
    
}

/*
 *  pluginInitialize
 */
- (void)pluginInitialize
{
}

- (void)onAppTerminate
{
   
}

- (void)init_iZettle:(CDVInvokedUrlCommand*)command
{
    NSLog(@"pluginInitialize");
    __block NSString* apiKey = command.arguments[0];
    [[iZettleSDK shared] startWithAPIKey:apiKey];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)charge:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    _lastReference = [self _uniqueReference];

    __block double amount = [command.arguments[0] doubleValue];
    __block NSString* currency = command.arguments[1];

    NSDecimalNumber *floatDecimal = [[NSDecimalNumber alloc] initWithDouble:amount];
    [[iZettleSDK shared] chargeAmount:floatDecimal currency:currency reference:_lastReference presentFromViewController:self.viewController completion:^(iZettleSDKPaymentInfo *paymentInfo, NSError *error) {
        _lastPaymentInfo = paymentInfo;
        _lastError = error;
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
        _timestamp = [NSDate date];
        NSString *nsstr = [format stringFromDate:_timestamp];
        
        NSDictionary *dic;
        if(_lastPaymentInfo != nil)
            dic = @{@"time":nsstr,
                    @"amount": (_lastPaymentInfo.amount == nil ? @"" : [NSString stringWithFormat:@"%.2f", [_lastPaymentInfo.amount doubleValue]]),
                    @"referenceNumber":(_lastPaymentInfo.referenceNumber == nil?@"":_lastPaymentInfo.referenceNumber),
                    @"entryMode":(_lastPaymentInfo.entryMode== nil ? @"" : _lastPaymentInfo.entryMode),
                    @"authorizationCode":(_lastPaymentInfo.authorizationCode== nil ? @"" : _lastPaymentInfo.authorizationCode),
                    @"obfuscatedPan":(_lastPaymentInfo.obfuscatedPan== nil ? @"" :_lastPaymentInfo.obfuscatedPan) ,
                    @"panHash":(_lastPaymentInfo.panHash== nil ? @"" : _lastPaymentInfo.panHash),
                    @"cardBrand":(_lastPaymentInfo.cardBrand== nil ? @"" : _lastPaymentInfo.cardBrand),
                    @"AID":(_lastPaymentInfo.AID== nil ? @"" : _lastPaymentInfo.AID),
                    @"TSI":(_lastPaymentInfo.TSI== nil ? @"" : _lastPaymentInfo.TSI),
                    @"TVR": (_lastPaymentInfo.TVR== nil ? @"" :_lastPaymentInfo.TVR) ,
                    @"applicationName":(_lastPaymentInfo.applicationName== nil ? @"" : _lastPaymentInfo.applicationName),
                    @"status":@"OK"
                };
        else
        {
            dic = @{@"time":nsstr, @"status":@"FALSE"};
        }
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }];
}

- (void)settings:(CDVInvokedUrlCommand*)command
{
    [[iZettleSDK shared] presentSettingsFromViewController:self.viewController];
}

- (void)lastPaymentInfo:(CDVInvokedUrlCommand*)command
{
    [[iZettleSDK shared] retrievePaymentInfoForReference:_lastReference presentFromViewController:self.viewController completion:^(iZettleSDKPaymentInfo *paymentInfo, NSError *error) {
        _lastPaymentInfo = paymentInfo;
        _lastError = error;
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
        _timestamp = [NSDate date];
        NSString *nsstr = [format stringFromDate:_timestamp];
        
        NSDictionary *dic;
        if(_lastPaymentInfo != nil)
            dic = @{@"time":nsstr,
                    @"amount": (_lastPaymentInfo.amount == nil ? @"" : [NSString stringWithFormat:@"%.2f", [_lastPaymentInfo.amount doubleValue]]),
                    @"referenceNumber":(_lastPaymentInfo.referenceNumber == nil?@"":_lastPaymentInfo.referenceNumber),
                    @"entryMode":(_lastPaymentInfo.entryMode== nil ? @"" : _lastPaymentInfo.entryMode),
                    @"authorizationCode":(_lastPaymentInfo.authorizationCode== nil ? @"" : _lastPaymentInfo.authorizationCode),
                    @"obfuscatedPan":(_lastPaymentInfo.obfuscatedPan== nil ? @"" :_lastPaymentInfo.obfuscatedPan) ,
                    @"panHash":(_lastPaymentInfo.panHash== nil ? @"" : _lastPaymentInfo.panHash),
                    @"cardBrand":(_lastPaymentInfo.cardBrand== nil ? @"" : _lastPaymentInfo.cardBrand),
                    @"AID":(_lastPaymentInfo.AID== nil ? @"" : _lastPaymentInfo.AID),
                    @"TSI":(_lastPaymentInfo.TSI== nil ? @"" : _lastPaymentInfo.TSI),
                    @"TVR": (_lastPaymentInfo.TVR== nil ? @"" :_lastPaymentInfo.TVR) ,
                    @"applicationName":(_lastPaymentInfo.applicationName== nil ? @"" : _lastPaymentInfo.applicationName),
                    @"status":@"OK"
                };
        else
        {
            dic = @{@"time":nsstr, @"status":@"FALSE"};
        }
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }];
}

- (void)refundLastPayment:(CDVInvokedUrlCommand*)command
{
    NSString *paymentReference = _lastReference;
    _lastReference = [self _uniqueReference];
    
    [[iZettleSDK shared] refundAmount:nil ofPaymentWithReference:paymentReference refundReference:_lastReference presentFromViewController:self.viewController completion:^(iZettleSDKPaymentInfo * _Nullable paymentInfo, NSError * _Nullable error) {
        _lastPaymentInfo = paymentInfo;
        _lastError = error;

        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
        _timestamp = [NSDate date];
        NSString *nsstr = [format stringFromDate:_timestamp];
        
        NSDictionary *dic;
        if(_lastPaymentInfo != nil)
            dic = @{@"time":nsstr,
                    @"amount": (_lastPaymentInfo.amount == nil ? @"" : [NSString stringWithFormat:@"%.2f", [_lastPaymentInfo.amount doubleValue]]),
                    @"referenceNumber":(_lastPaymentInfo.referenceNumber == nil?@"":_lastPaymentInfo.referenceNumber),
                    @"entryMode":(_lastPaymentInfo.entryMode== nil ? @"" : _lastPaymentInfo.entryMode),
                    @"authorizationCode":(_lastPaymentInfo.authorizationCode== nil ? @"" : _lastPaymentInfo.authorizationCode),
                    @"obfuscatedPan":(_lastPaymentInfo.obfuscatedPan== nil ? @"" :_lastPaymentInfo.obfuscatedPan) ,
                    @"panHash":(_lastPaymentInfo.panHash== nil ? @"" : _lastPaymentInfo.panHash),
                    @"cardBrand":(_lastPaymentInfo.cardBrand== nil ? @"" : _lastPaymentInfo.cardBrand),
                    @"AID":(_lastPaymentInfo.AID== nil ? @"" : _lastPaymentInfo.AID),
                    @"TSI":(_lastPaymentInfo.TSI== nil ? @"" : _lastPaymentInfo.TSI),
                    @"TVR": (_lastPaymentInfo.TVR== nil ? @"" :_lastPaymentInfo.TVR) ,
                    @"applicationName":(_lastPaymentInfo.applicationName== nil ? @"" : _lastPaymentInfo.applicationName),
                    @"status":@"OK"
                };
        else
        {
            dic = @{@"time":nsstr, @"status":@"FALSE"};
        }
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }];
}

- (void)enforceAccount:(CDVInvokedUrlCommand*)command
{
    __block NSString* email = command.arguments[0];
    [iZettleSDK shared].enforcedUserAccount = email.length > 0 ? email : nil;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}
   
- (NSString *)_uniqueReference {
    return [[NSUUID UUID] UUIDString];
}
    
@end
