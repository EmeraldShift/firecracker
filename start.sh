#!/usr/bin/env sh

arch=`uname -m`
dest_kernel="hello-vmlinux.bin"
image_bucket_url="https://s3.amazonaws.com/spec.ccfc.min/img"

if [ ${arch} = "x86_64" ]; then
	kernel="${image_bucket_url}/hello/kernel/hello-vmlinux.bin"
	rootfs="${image_bucket_url}/hello/fsfiles/hello-rootfs.ext4"
elif [ ${arch} = "aarch64" ]; then
	kernel="${image_bucket_url}/aarch64/ubuntu_with_ssh/kernel/vmlinux.bin"
	rootfs="${image_bucket_url}/aarch64/ubuntu_with_ssh/fsfiles/xenial.rootfs.ext4"
else
	echo "Cannot run firecracker on $arch architecture!"
	exit 1
fi

echo "Downloading $kernel..."
if [ ! -f ${dest_kernel} ]; then
	curl -fsSL -o $dest_kernel $kernel
else
	echo "Already downloaded."
fi

echo "Downloading $rootfs..."
if [ ! -f ${dest_rootfs} ]; then
	curl -fsSL -o $dest_rootfs $rootfs
else
	echo "Already downloaded."
fi


sudo build/cargo_target/x86_64-unknown-linux-musl/debug/firecracker --no-api --config-file hello-config.json
