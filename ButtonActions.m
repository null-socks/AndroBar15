#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <dlfcn.h>

@interface UIApplication (Private)
- (void)_handleOpenAppSwitcherShortcut:(id)arg1;

@end

@interface ButtonActions : NSObject
+ (void)performBackAction;
+ (void)performHomeAction;
+ (void)performRecentsAction;
@end

@implementation ButtonActions

+ (void)performBackAction {
    AudioServicesPlaySystemSound(1519);
}

+ (void)performHomeAction {
    AudioServicesPlaySystemSound(1519);
    Class SBLSClass = objc_getClass("SBLockScreenManager");
    id lockManager = nil;
    if ([SBLSClass respondsToSelector:@selector(sharedInstance)]) {
        lockManager = ((id (*)(id, SEL))objc_msgSend)(SBLSClass, @selector(sharedInstance));
    }
    
    BOOL isLocked = NO;
    if (lockManager && [lockManager respondsToSelector:@selector(isLockScreenVisible)]) {
        isLocked = ((BOOL (*)(id, SEL))objc_msgSend)(lockManager, @selector(isLockScreenVisible));
    }
    
    if (isLocked) {
        Class AXSBClass = objc_getClass("AXSpringBoardServer");
        id axServer = nil;
        if ([AXSBClass respondsToSelector:@selector(sharedInstance)]) {
            axServer = ((id (*)(id, SEL))objc_msgSend)(AXSBClass, @selector(sharedInstance));
        }
        if (!axServer) axServer = [[AXSBClass alloc] init];
        if ([axServer respondsToSelector:@selector(unlockDevice)]) {
            ((void (*)(id, SEL))objc_msgSend)(axServer, @selector(unlockDevice));
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
        if (handle) {
            void (*SBSLaunchApp)(CFStringRef, BOOL) = dlsym(handle, "SBSLaunchApplicationWithIdentifier");
            if (SBSLaunchApp) SBSLaunchApp(CFSTR("com.apple.springboard"), YES);
            dlclose(handle);
        }
    });
}

+ (void)performRecentsAction {
    AudioServicesPlaySystemSound(1519);
    [[UIApplication sharedApplication] _handleOpenAppSwitcherShortcut:nil];
}

@end