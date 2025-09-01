#import <UIKit/UIKit.h>
#import "NavBarView.h"

static NavBarView *persistentNavBar = nil;

%hook UIWindow
- (void)layoutSubviews {
    %orig;

    if (!persistentNavBar) {
        CGFloat navHeight = 35;
        CGFloat padding = 10;
        CGRect frame = CGRectMake(
            20,
            CGRectGetHeight(self.bounds) - navHeight - padding,
            CGRectGetWidth(self.bounds) - 25,
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
    persistentNavBar.frame = CGRectMake(
        0,
        CGRectGetHeight(self.bounds) - navHeight,
        CGRectGetWidth(self.bounds) - 0,
        navHeight
    );
}
%end
