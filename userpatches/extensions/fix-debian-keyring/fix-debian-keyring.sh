#!/usr/bin/env bash

# Extension: fix-debian-keyring
# Ensures that Debian 12 (bookworm) and Debian 13 (trixie) release signing keys
# are present in /usr/share/keyrings/debian-archive-keyring.gpg on the host/container.
# This prevents debootstrap from failing with:
# "E: Release signed by unknown key (key id F8D2585B8783D481)"

function host_dependencies_ready__fix_debian_keyring() {
	display_alert "Checking" "Debian archive release keys for debootstrap" "info"

	mkdir -p /usr/share/keyrings
	local keyring="/usr/share/keyrings/debian-archive-keyring.gpg"
	[[ ! -f "${keyring}" ]] && touch "${keyring}"

	# Check if Debian 12 (Bookworm) release key (F8D2585B8783D481) is present
	if ! gpg --no-default-keyring --keyring "${keyring}" --list-keys F8D2585B8783D481 > /dev/null 2>&1; then
		display_alert "Debian 12 Bookworm key missing in host keyring" "importing from Debian ftp-master" "wrn"
		local keys=(
			"release-12.asc"
			"archive-key-12.asc"
			"archive-key-12-security.asc"
			"release-13.asc"
			"archive-key-13.asc"
			"archive-key-13-security.asc"
		)
		for k in "${keys[@]}"; do
			curl -fsSL --retry 3 "https://ftp-master.debian.org/keys/${k}" | gpg --no-default-keyring --keyring "${keyring}" --import 2>/dev/null || true
		done
		display_alert "Debian archive keyring updated successfully" "" "info"
	else
		display_alert "Debian 12 Bookworm key is already present in host keyring" "" "info"
	fi
}
