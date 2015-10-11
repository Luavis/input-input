//
//  AppDelegate.m
//  InputInput
//
//  Created by Luavis Kang on 10/11/15.
//  Copyright © 2015 Luavis Kang. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>


NSArray * textInputArray;
EventHotKeyRef num1KeyRef;
EventHotKeyRef num2KeyRef;
EventHotKeyRef num3KeyRef;

pascal OSStatus NumberKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData);


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    textInputArray = (__bridge NSArray *)
        (TISCreateInputSourceList(
            (__bridge CFDictionaryRef)([NSDictionary new]),
            NO)
        );

    for (int i = 0; i < [textInputArray count]; i++) {
        TISInputSourceRef source = (__bridge TISInputSourceRef)(textInputArray[i]);

        NSString* localizedName =
        (__bridge NSString *)
            (TISGetInputSourceProperty(source, kTISPropertyLocalizedName));

        CFBooleanRef isSourceEnabled  = (CFBooleanRef)(TISGetInputSourceProperty(source, kTISPropertyInputSourceIsEnabled));

        if(isSourceEnabled == kCFBooleanTrue) {
            NSLog(@"%@", localizedName);
        }
    }

    EventTypeSpec keyTypeId;

    EventHandlerUPP keyDownHandler = NewEventHandlerUPP(NumberKeyHandler);
    keyTypeId.eventClass = kEventClassKeyboard;
    keyTypeId.eventKind  = kEventHotKeyPressed;

    InstallApplicationEventHandler(
                                   keyDownHandler,
                                   1,
                                   &keyTypeId,
                                   (void *)CFBridgingRetain(self),
                                   NULL
                                   );

    EventHotKeyID number1KeyId;
    number1KeyId.signature = 'lnm1';
    number1KeyId.id = 1;

    RegisterEventHotKey(
                        18,
                        controlKey,
                        number1KeyId,
                        GetApplicationEventTarget(),
                        0,
                        &num1KeyRef
                        ); // register number 1

    EventHotKeyID number2KeyId;
    number2KeyId.signature = 'lnm2';
    number2KeyId.id = 2;

    RegisterEventHotKey(
                        19,
                        controlKey,
                        number2KeyId,
                        GetApplicationEventTarget(),
                        0,
                        &num2KeyRef
                        ); // register number 2

    EventHotKeyID number3KeyId;
    number3KeyId.signature = 'lnm3';
    number3KeyId.id = 3;

    RegisterEventHotKey(
                        20,
                        controlKey,
                        number3KeyId,
                        GetApplicationEventTarget(),
                        0,
                        &num3KeyRef
                        ); // register number 1
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

pascal OSStatus NumberKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData) {

    EventHotKeyID keyCode;
    EventParamType realType;
    ByteCount realSize;

    GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, &realType, sizeof(keyCode), &realSize, &keyCode);

    switch (keyCode.id) {
        case 1:
            TISSelectInputSource((__bridge TISInputSourceRef)textInputArray[0]);
            break;
        case 2:
            TISSelectInputSource((__bridge TISInputSourceRef)textInputArray[8]);
            break;
        case 3:
            TISSelectInputSource((__bridge TISInputSourceRef)textInputArray[2]);
            break;
        default:
            break;
    }

    return noErr;
}
