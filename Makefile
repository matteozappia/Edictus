include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

all::
	xcodebuild CODE_SIGN_IDENTITY="" AD_HOC_CODE_SIGNING_ALLOWED=YES -scheme EdictusOBJC archive -archivePath EdictusOBJC.xcarchive PACKAGE_VERSION='@\"$(THEOS_PACKAGE_BASE_VERSION)\"' | xcpretty && exit ${PIPESTATUS[0]}

after-stage::
	mv EdictusOBJC.xcarchive/Products/Applications $(THEOS_STAGING_DIR)/Applications
	rm -rf EdictusOBJC.xcarchive
	ldid -S $(THEOS_STAGING_DIR)/Applications/EdictusOBJC.app/EdictusOBJC
	ldid -Sentitlements.xml $(THEOS_STAGING_DIR)/Applications/EdictusOBJC.app/EdictusOBJC

after-install::
	install.exec "killall \"EdictusOBJC\" || true"