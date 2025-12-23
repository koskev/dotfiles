#!/bin/bash

INPUT_FILE="/boot/grub/grub.cfg"


function fix_path () {
    echo "$1" | sed "s/([^)]*)\///g" | cut -d\  -f2
}

print_tree() {
    # XXX: GNU sort and busybox sort behave differently...
	sudo find ./ ! -path './kexec*' -print0 | busybox sort -z
}

function get_entries() {

current_entry=""
current_kernel=""
current_initrd=""
current_init=""

while IFS= read -r line
do
    if [[ $line =~ ^[[:space:]]*menuentry[[:space:]]+\"([^\"]+)\" ]]; then 
        current_entry="${BASH_REMATCH[1]}"
        current_kernel=""
        current_initrd=""
        current_init=""
    fi

    if [[ $line =~ ^[[:space:]]*linux[[:space:]]+([^[:space:]]+) ]]; then
        current_kernel=$(fix_path "${BASH_REMATCH[1]}")
        if [[ $line =~ init=([^[:space:]]+) ]]; then
            current_init="${BASH_REMATCH[1]}"
        fi
    fi

    if [[ $line =~ ^[[:space:]]*initrd[[:space:]]+([^[:space:]]+) ]]; then
        current_initrd=$(fix_path "${BASH_REMATCH[1]}")
    fi

    if [[ -n $current_entry ]] && [[ -n $current_kernel ]] && [[ -n $current_init ]] && [[ -n $current_initrd ]]; then
        echo "$current_entry|elf|kernel $current_kernel|initrd $current_initrd|append init=$current_init root=/dev/mapper/ssd_arch-root"
        current_entry=""
        current_kernel=""
        current_initrd=""
        current_init=""
    fi


done < "$INPUT_FILE"
}


pushd /boot || exit 1
get_entries | sudo dd of=/boot/kexec_menu.txt
cat /boot/kexec_menu.txt | head -n 1 | sudo dd of=/boot/kexec_default.1.txt
sudo find ./ -type f ! -path './kexec*' -print0 | xargs -0 sudo sha256sum | sudo dd of=/boot/kexec_hashes.txt
print_tree | sudo dd of=/boot/kexec_tree.txt
param_files=$(find /boot/kexec*.txt)
# No quotes since we want splitting
sha256sum $param_files | gpg --detach-sign -a | sudo dd of=/boot/kexec.sig
popd || exit 1
