ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AndroBar15Prefs

AndroBar15Prefs_FILES = ABRRootListController.m
AndroBar15Prefs_FRAMEWORKS = UIKit
AndroBar15Prefs_PRIVATE_FRAMEWORKS = Preferences
AndroBar15Prefs_INSTALL_PATH = /Library/PreferenceBundles
AndroBar15Prefs_CFLAGS = -fobjc-arc
AndroBar15Prefs_RESOURCE_DIRS = Resources

include $(THEOS_MAKE_PATH)/bundle.mk
