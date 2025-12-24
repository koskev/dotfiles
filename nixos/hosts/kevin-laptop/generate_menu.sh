#!/bin/bash
set -e

INPUT_FILE="/boot/grub/grub.cfg"
WORKDIR=$(mktemp -d)

function fix_path () {
    echo "$1" | sed "s/([^)]*)\///g" | cut -d\  -f2
}

print_tree() {
    # XXX: GNU sort and busybox sort behave differently...
    sudo find ./ ! -path './kexec*' -print0 | busybox sort -z
}

function create_kexec_line() {
    entry=$1
    kernel=$2
    initrd=$3
    init=$4

    echo "$entry|elf|kernel $kernel|initrd $initrd|append init=$init root=/dev/mapper/ssd_arch-root"
}

function write_entries() {
    entries=()
    kernels=()
    initrds=()
    inits=()
    i=-1

    while IFS= read -r line
    do
        if [[ $line =~ ^[[:space:]]*menuentry[[:space:]]+\"([^\"]+)\" ]]; then 
            (( i+=1 ))
            entries[i]="${BASH_REMATCH[1]}"
        fi

        if [[ $line =~ ^[[:space:]]*linux[[:space:]]+([^[:space:]]+) ]]; then
            kernels[i]=$(fix_path "${BASH_REMATCH[1]}")
            if [[ $line =~ init=([^[:space:]]+) ]]; then
                inits[i]="${BASH_REMATCH[1]}"
            fi
        fi

        if [[ $line =~ ^[[:space:]]*initrd[[:space:]]+([^[:space:]]+) ]]; then
            initrds[i]=$(fix_path "${BASH_REMATCH[1]}")
        fi


    done < "$INPUT_FILE"

    output=""
    for i in "${!entries[@]}"; do
        output="$output\n$(create_kexec_line "${entries[i]}" "${kernels[i]}" "${initrds[i]}" "${inits[i]}")"
    done
    echo "$output" | sudo dd of=kexec_menu.txt

    create_kexec_line "${entries[i]}" "${kernels[i]}" "${initrds[i]}" "${inits[i]}" | sudo dd of=kexec_default.1.txt
    sha256sum ".${kernels[0]}" ".${initrds[0]}" | sudo dd of=kexec_default_hashes.txt
}


pushd "$WORKDIR" || exit 1
write_entries
sudo find ./ -type f ! -path './kexec*' -print0 | xargs -0 sudo sha256sum | sudo dd of=kexec_hashes.txt
print_tree | sudo dd of=kexec_tree.txt
param_files=$(find kexec*.txt)
# No quotes since we want splitting
sha256sum $param_files | gpg --detach-sign -a | sudo dd of=kexec.sig
# cp -r $WORKDIR/* /boot/
popd || exit 1
