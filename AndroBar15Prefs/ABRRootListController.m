#import <Foundation/Foundation.h>
#import <spawn.h>
#import "ABRRootListController.h"

@implementation ABRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

- (void)restartSpringBoard {
	pid_t pid;
	const char *killallPath = THEOS_PACKAGE_INSTALL_PREFIX "/usr/bin/killall";
	const char *args[] = {"killall", "-9", "SpringBoard", NULL};
	posix_spawn(&pid, killallPath, NULL, NULL, (char *const *)args, NULL);

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
				   dispatch_get_main_queue(), ^{
		exit(0);
	});
}

@end