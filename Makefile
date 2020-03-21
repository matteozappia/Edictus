include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

all::
	xcodebuild CODE_SIGN_IDENTITY="" AD_HOC_CODE_SIGNING_ALLOWED=YES -scheme EdictusOBJC archive -archivePath EdictusOBJC.xcarchive PACKAGE_VERSION='@\"$(THEOS_PACKAGE_BASE_VERSION)\"' | xcpretty && exit ${PIPESTATUS[0]}

after-stage::
	mv EdictusOBJC.xcarchive/Products/Applications $(THEOS_STAGING_DIR)/Applications
	rm -rf EdictusOBJC.xcarchive
	$(MAKE) -C edictusroot LEAN_AND_MEAN=1
	mkdir -p $(THEOS_STAGING_DIR)/usr/bin
	mv $(THEOS_OBJ_DIR)/edictusroot $(THEOS_STAGING_DIR)/usr/bin
	ldid -S $(THEOS_STAGING_DIR)/Applications/EdictusOBJC.app/EdictusOBJC
	ldid -SEdictusOBJC.entitlements $(THEOS_STAGING_DIR)/Applications/EdictusOBJC.app/EdictusOBJC

after-install::
	install.exec "killall \"EdictusOBJC\" || true"