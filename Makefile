include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

all::
	xcodebuild CODE_SIGN_IDENTITY="" AD_HOC_CODE_SIGNING_ALLOWED=YES -scheme EdictusOBJC archive -archivePath Edictus.xcarchive PACKAGE_VERSION='@\"$(THEOS_PACKAGE_BASE_VERSION)\"' | xcpretty && exit ${PIPESTATUS[0]}

after-stage::
	mv Edictus.xcarchive/Products/Applications $(THEOS_STAGING_DIR)/Applications
	rm -rf Edictus.xcarchive
	$(MAKE) -C edictusroot LEAN_AND_MEAN=1
	mkdir -p $(THEOS_STAGING_DIR)/usr/bin
	cp ./edictusroot/LICENSE $(THEOS_STAGING_DIR)/Applications/Edictus.app/LICENSEgizroot
	mv $(THEOS_OBJ_DIR)/edictusroot $(THEOS_STAGING_DIR)/usr/bin
	ldid -S $(THEOS_STAGING_DIR)/Applications/Edictus.app/Edictus
	ldid -SEdictus.entitlements $(THEOS_STAGING_DIR)/Applications/Edictus.app/Edictus

after-install::
	install.exec "killall \"Edictus\" || true"