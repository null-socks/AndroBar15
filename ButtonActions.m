#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
        if (handle) {
            void (*SBSLaunchApp)(CFStringRef, BOOL) = dlsym(handle, "SBSLaunchApplicationWithIdentifier");
            if (SBSLaunchApp) {
                SBSLaunchApp(CFSTR("com.apple.springboard"), YES);
            }
            dlclose(handle);
        }
    });
}

+ (void)performRecentsAction {
    AudioServicesPlaySystemSound(1519);
    [[UIApplication sharedApplication] _handleOpenAppSwitcherShortcut:nil];
}

@end