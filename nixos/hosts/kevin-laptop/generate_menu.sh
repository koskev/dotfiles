#!/bin/bash

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

    echo "$entry|elf|kernel $kernel|initrd $initrd|append init=$init root=/dev/mapper/ssd_arch-root quiet"
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
        new_line="$(create_kexec_line "${entries[i]}" "${kernels[i]}" "${initrds[i]}" "${inits[i]}")"
        if [ -z "$output" ]; then
            output=$new_line
        else
            output="$output\n$new_line"
        fi
    done
    echo -e "$output" | sudo dd of=kexec_menu.txt

    create_kexec_line "${entries[0]}" "${kernels[0]}" "${initrds[0]}" "${inits[0]}" | sudo dd of=kexec_default.1.txt
    pushd /boot || exit 1
    sha256sum ".${kernels[0]}" ".${initrds[0]}" | sudo dd of="$WORKDIR/kexec_default_hashes.txt"
    popd || exit 1
}


pushd "$WORKDIR" || exit 1
write_entries
pushd /boot || exit 1
print_tree | sudo dd of="$WORKDIR/kexec_tree.txt"
popd || exit 1
# TODO: Is this correct?
cp /boot/kexec_rollback.txt "$WORKDIR/"
pushd /boot || exit 1
sudo find ./ -type f ! -path './kexec*' -print0 | xargs -0 sudo sha256sum | sudo dd of="$WORKDIR/kexec_hashes.txt"
popd || exit 1
# No quotes since we want splitting
sign_content="$(sha256sum $(find ./kexec*.txt) | sed "s/ \./ \/boot/g")"
echo "Signing: ##$sign_content##  With hash $(echo "$sign_content" | sha256sum -)"
echo "$sign_content" | gpg --detach-sign -a | sudo dd of=kexec.sig
sudo cp "$WORKDIR"/* /boot/
popd || exit 1
