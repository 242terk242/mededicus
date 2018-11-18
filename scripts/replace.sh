#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
[[ ${DEBUG:-} == true ]] && set -o xtrace

usage() {
	cat <<END
	sub-key-in-file [-h] old_key new_key file
	Replaces {old_key} with {new_key} in passed in {file}
	Will fail silently if old_key is not found.
	Will validate success after replacing with new_key and exit 1 if not found.
		-h: show this help message
	e.g. ./sub-key-in-file.sh 'AD-AAB-AAC-KYF' 'AD-AAB-AAC-GTS' apps/{appName}/src/index.html
END
}

while getopts ":h" opt; do
	case $opt in
    h)
      usage
      exit 0
      ;;
    *) usage >&2
       exit 1 ;;
	esac
done

[[ -z ${1:-} ]] && echo "Missing first argument for old_key" >&2 && exit 1
[[ -z ${2:-} ]] && echo "Missing second argument for new_key" >&2 && exit 1
[[ -z ${3:-} ]] && echo "Missing third argument for file" >&2 && exit 1

old_key="${1}"
new_key="${2}"
file="${3}"

if grep -q "${old_key}" "${file}"; then
	sed -i -e "s|${old_key}|${new_key}|g" "${file}"
	# validate
	grep -q "${new_key}" "${file}" || (echo "key: ${new_key} not found." && exit 1)
else
	echo "old key: ${old_key} not found. skipping replace ...."
fi