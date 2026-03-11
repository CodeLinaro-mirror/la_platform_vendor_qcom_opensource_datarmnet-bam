ifeq ($(TARGET_DATARMNET_BAM_ENABLE), true)
ifneq ($(TARGET_BOARD_PLATFORM),qssi)
RMNET_BAM_DLKM_PLATFORMS_LIST := shikra

ifeq ($(call is-board-platform-in-list, $(RMNET_BAM_DLKM_PLATFORMS_LIST)),true)
#Make file to create RMNET_CORE DLKM
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

#Enabling BAZEL
LOCAL_MODULE_DDK_BUILD := true

LOCAL_CFLAGS := -Wno-macro-redefined -Wno-unused-function -Wall -Werror
LOCAL_CLANG :=true
LOCAL_MODULE_PATH := $(KERNEL_MODULES_OUT)
LOCAL_MODULE := rmnet_bam.ko
LOCAL_SRC_FILES   := $(wildcard $(LOCAL_PATH)/**/*) $(wildcard $(LOCAL_PATH)/*)
DLKM_DIR := $(TOP)/device/qcom/common/dlkm
$(warning $(DLKM_DIR))
include $(DLKM_DIR)/Build_external_kernelmodule.mk

endif #End of Check for target
endif #End of Check for qssi target
endif #End of Check for datarmnet
