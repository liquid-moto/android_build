# Configuration for Linux on ARM.
# Generating binaries for the ARMv7-a architecture and higher with NEON
#
ARCH_ARM_HAVE_ARMV7A            := true
ARCH_ARM_HAVE_VFP               := true
ARCH_ARM_HAVE_VFP_D32           := true
ARCH_ARM_HAVE_NEON              := true

ifeq ($(TARGET_CPU_VARIANT),$(filter $(TARGET_CPU_VARIANT),cortex-a15 krait))
	arch_variant_cflags := -mcpu=cortex-a15
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),cortex-a9)
	arch_variant_cflags := -mcpu=cortex-a9
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),cortex-a8)
	arch_variant_cflags := -mcpu=cortex-a8
ifeq ($(USE_ARCH_OPTIMIZATIONS),true)
	arch_variant_ldflags := -Wl,--fix-cortex-a8
endif
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),scorpion)
	arch_variant_cflags := -mcpu=cortex-a8
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),cortex-a7)
	arch_variant_cflags := -mcpu=cortex-a7
else
	arch_variant_cflags := -march=armv7-a
endif
endif
endif
endif
endif

arch_variant_cflags += \
    -mfloat-abi=softfp \
    -mfpu=neon

ifeq ($(USE_ARCH_OPTIMIZATIONS),true)
else
ifneq (,$(findstring cpu=cortex-a9,$(TARGET_EXTRA_CFLAGS)))
arch_variant_ldflags := \
	-Wl,--no-fix-cortex-a8
else
arch_variant_ldflags := \
	-Wl,--fix-cortex-a8
endif
endif
