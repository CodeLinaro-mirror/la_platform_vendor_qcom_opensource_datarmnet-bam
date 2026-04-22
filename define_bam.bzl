# SPDX-License-Identifier: BSD-3-Clause
load("@rules_pkg//pkg:install.bzl", "pkg_install")
load("@rules_pkg//pkg:mappings.bzl", "pkg_files", "strip_prefix")
load("//build/kernel/kleaf:kernel.bzl", "ddk_module")
def define_bam(target, variant):
    kernel_build_variant = "{}_{}".format(target, variant)
    include_base = "../../../{}".format(native.package_name())
    deps = select({
        "//build/qcom_build_extensions:qtisocrepo_true": ["//soc-repo:all_headers"],
        "//build/qcom_build_extensions:qtisocrepo_false": ["//msm-kernel:all_headers"],
    })
    kernel_build = select({
        "//build/qcom_build_extensions:qtisocrepo_true": "//soc-repo:{}_base_kernel".format(kernel_build_variant),
        "//build/qcom_build_extensions:qtisocrepo_false": "//msm-kernel:{}".format(kernel_build_variant),
    })
 
    ddk_module(
        name = "{}_bam".format(kernel_build_variant),
        out = "bam/rmnet_bam.ko",
        srcs = [
            "bam/msm_rmnet_bam.c",
        ],
        kernel_build = kernel_build,
        deps = deps + [
            ":include_headers",
	] + select({
		"//build/qcom_build_extensions:qtisocrepo_true": ["//soc-repo:{}/drivers/soc/qcom/bam_dmux".format(kernel_build_variant)],
		"//build/qcom_build_extensions:qtisocrepo_false": [],
	}),
        copts = ["-Wno-misleading-indentation"],
    )
    pkg_files(
        name = "{}_datarmnet-bam_dist_files".format(kernel_build_variant),
        srcs = [":{}_bam".format(kernel_build_variant)],
        strip_prefix = strip_prefix.files_only(),
        visibility = ["//visibility:private"],
    )
    pkg_install(
        name = "{}_datarmnet-bam_dist".format(kernel_build_variant),
        srcs = [":{}_datarmnet-bam_dist_files".format(kernel_build_variant)],
        destdir = "out/target/product/{}/dlkm/lib/modules/".format(target),
    )
