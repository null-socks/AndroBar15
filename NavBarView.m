#import "NavBarView.h"
#import <QuartzCore/QuartzCore.h>
#import "ButtonActions.h"

extern NSUserDefaults *prefs;

@implementation NavBarView {
    UIVisualEffectView *_blur;
    UIButton *_back, *_home, *_recents;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterialDark];
        _blur = [[UIVisualEffectView alloc] initWithEffect:effect];
        _blur.frame = self.bounds;
        _blur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _blur.layer.cornerRadius = 16.0;
        _blur.layer.masksToBounds = YES;
        _blur.alpha = 0;
        [self addSubview:_blur];
        
        _back    = [self pill:@"◁"];
        _home    = [self pill:@"●"];
        _recents = [self pill:@"□"];

        [_back addTarget:self action:@selector(tBack) forControlEvents:UIControlEventTouchUpInside];
        [_home addTarget:self action:@selector(tHome) forControlEvents:UIControlEventTouchUpInside];
        [_recents addTarget:self action:@selector(tRecents) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_back]; [self addSubview:_home]; [self addSubview:_recents];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (UIButton *)pill:(NSString *)title {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.backgroundColor = [[UIColor labelColor] colorWithAlphaComponent:0.18];
    b.layer.cornerRadius = 12.5;
    b.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
    b.tintColor = UIColor.labelColor;
    return b;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _blur.frame = self.bounds;
    CGFloat w = CGRectGetWidth(self.bounds), h = CGRectGetHeight(self.bounds);
    CGFloat btnW = 56.0, btnH = MIN(36.0, h - 8.0);
    CGFloat spacing = (w - (btnW * 3)) / 4.0;
    CGFloat y = (h - btnH) / 2.0;
    _back.frame    = CGRectMake(spacing, y, btnW, btnH);
    _home.frame    = CGRectMake(spacing*2 + btnW, y, btnW, btnH);
    _recents.frame = CGRectMake(spacing*3 + btnW*2, y, btnW, btnH);
}

- (void)tBack    { [ButtonActions performBackAction]; }
- (void)tRecents { [ButtonActions performRecentsAction]; }

static NSDate *lastHomePress = nil;
static double doubleTapThreshold = 0.4;

- (void)tHome {
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"socks.null.androbar15prefs"];
    NSDate *now = [NSDate date];
    doubleTapThreshold = [prefs integerForKey:@"dtappinterval"] / 10.0;

    if ([prefs boolForKey:@"doubletappswitcher"]) {
        if (lastHomePress && [now timeIntervalSinceDate:lastHomePress] < doubleTapThreshold) {
            [ButtonActions performRecentsAction];
            lastHomePress = nil;
        } else {
            lastHomePress = now;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(doubleTapThreshold * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (lastHomePress) {
                    [ButtonActions performHomeAction];
                    lastHomePress = nil;
                }
            });
        }
    } else {
        [ButtonActions performHomeAction];
    }
}

@end