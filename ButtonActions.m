#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

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
}

+ (void)performRecentsAction {
    AudioServicesPlaySystemSound(1519);
}

@end

