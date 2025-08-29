#import <UIKit/UIKit.h>      // for UIWindow, UIView
#import "NavBarView.h"

static NavBarView *persistentNavBar = nil;

%hook UIWindow
- (void)layoutSubviews {
    %orig;

    if (!persistentNavBar) {
        CGFloat navHeight = 60;
        CGFloat padding = 20;
        CGRect frame = CGRectMake(
            20,
            CGRectGetHeight(self.bounds) - navHeight - padding,
            CGRectGetWidth(self.bounds) - 40,
            navHeight
        );

        persistentNavBar = [[NavBarView alloc] initWithFrame:frame];
        persistentNavBar.onBack = ^{};
        persistentNavBar.onHome = ^{};
        persistentNavBar.onRecents = ^{};
        [self addSubview:persistentNavBar];
    } else if (persistentNavBar.superview != self) {
        [persistentNavBar removeFromSuperview];
        [self addSubview:persistentNavBar];
    }

    CGFloat navHeight = CGRectGetHeight(persistentNavBar.bounds);
    CGFloat padding = 20;
    persistentNavBar.frame = CGRectMake(
        20,
        CGRectGetHeight(self.bounds) - navHeight - padding,
        CGRectGetWidth(self.bounds) - 40,
        navHeight
    );
}
%end
