ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AndroBar15

AndroBar15_FILES = Tweak.x NavBarView.m ButtonActions.m
AndroBar15_CFLAGS = -fobjc-arc
AndroBar15_FRAMEWORKS = SpringBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk
