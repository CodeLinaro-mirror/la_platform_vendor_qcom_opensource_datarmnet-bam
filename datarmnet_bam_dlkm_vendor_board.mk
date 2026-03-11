TARGET_DATARMNET_BAM_ENABLE := false

ifeq ($(TARGET_KERNEL_DLKM_DISABLE), true)
	ifeq ($(TARGET_KERNEL_DLKM_DATARMNET_BAM_OVERRIDE), true)
		TARGET_DATARMNET_BAM_ENABLE := true
	endif
else
	TARGET_DATARMNET_BAM_ENABLE := true
endif

ifeq ($(TARGET_DATARMNET_BAM_ENABLE), true)
	#Build rmnet core
	DATARMNET_BAM_DLKM_BOARD_PLATFORMS_LIST := shikra

	ifneq ($(TARGET_BOARD_AUTO),true)
		ifneq (,$(call is-board-platform-in-list2,$(DATARMNET_BAM_DLKM_BOARD_PLATFORMS_LIST)))
			BOARD_VENDOR_KERNEL_MODULES += $(KERNEL_MODULES_OUT)/rmnet_bam.ko
		endif
	endif
endif
