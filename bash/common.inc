# Fail on any error.
set -e
# Fail on any part of a pipeline failing.
set -o pipefail
# Treat unset variables as an error.
set -u
# Display commands being run.
set -x

# Returns absolute path to a file or a directory. The path must exist.
function abs_path() {
	local rel_path="$1"
	if [ -d "$rel_path" ]
	then
		# Parameter is a directory
		local rel_dir="$rel_path"
		local rel_base=""
	elif [ -f "$rel_path" ]
	then
		# Parameter is a regular file
		local rel_dir="$(dirname "$rel_path")"
		local rel_base="/$(basename "$rel_path")"
	else
		# File does not exist
		echo "File not found: $rel_path" >&2
		exit 1
	fi
	echo "$(cd $rel_dir && pwd)$rel_base"
	return 0
}

# Returns true if the environment contains Fenxi build variables.
function is_fenxi_build() {
	[ -v FENXI_JOB_NAME ]
	return $?
}

# Returns true if the environment contains Jenkins build variables.
function is_jenkins_build() {
	[ -v JENKINS_HOME ]
	return $?
}

# Returns true if the `.repo_manifest` folder exists. The folder should contain
# the manifest and be present in all Repo builds. Eventually this should be
# obsolete as we switch exclusively to Repo.
function is_repo_build() {
	[ -d "${ROOT_DIR}/.repo_manifest" ]
	return $?
}

# Returns absolute path to the directory containing the source file that called
# this function.
function get_script_dir() {
	local caller_path="${BASH_SOURCE[1]}"
	local caller_abs_path="$(abs_path $caller_path)"
	dirname "$caller_abs_path"
}

function init_build() {
	ROOT_DIR="$(abs_path $(get_script_dir)/..)"
	CLANG="${ROOT_DIR}/fenxi/clang"
	REPO="${ROOT_DIR}/fenxi/CPPcheck"

	if is_fenxi_build
	then
		export HAFNIUM_IGNORE_SUBMODULE_STATUS=true
	fi
}

