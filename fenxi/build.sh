#source "$(dirname ${BASH_SOURCE[0]})/../bash/common.inc"

# Initialize global variables, prepare repo for building.
#init_build

# Assign default values to variables.
#if is_fenxi_build
#then
#	# Default config for Fenxi builds.
#	default_value HAFNIUM_HERMETIC_BUILD true
#	default_value HAFNIUM_SKIP_LONG_RUNNING_TESTS false
#	default_value HAFNIUM_RUN_ALL_QEMU_CPUS true
#	default_value USE_TFA true
#elif is_jenkins_build
#then
#	# Default config for Jenkins builds.
#	default_value HAFNIUM_HERMETIC_BUILD false
#	default_value HAFNIUM_SKIP_LONG_RUNNING_TESTS false
#	default_value HAFNIUM_RUN_ALL_QEMU_CPUS true
#	default_value USE_TFA true
#else
#	# Default config for local builds.
#	default_value HAFNIUM_HERMETIC_BUILD false
#	default_value HAFNIUM_SKIP_LONG_RUNNING_TESTS true
#	default_value HAFNIUM_RUN_ALL_QEMU_CPUS false
#	default_value USE_TFA false
#fi

#
# Step 1: make sure it builds.
#

# make PROJECT=reference

#
# Run static analysis.
#

#
# Step 2: runs clang-format
#

make format
if [[ -n $(git status -s) ]];
then
	echo "Run \`make format\' locally to fix this."
	exit 1
fi

#
# Step 3: checks for bugs and makes misrac checks
#

make cppcheck
if ! [ -s ./cppcheck_report.xml ] || ! [ -s ./misrac_report.xml ];
then
	echo "Cppcheck failed. See cppcheck_report.xml and misrac_report.xml for more information."
	exit 1
fi

#
# Step 4: make sure there's not lint.
#

make tidy
if [[ -n $(git status -s) ]];
then
	echo "Run \`make tidy\' locally to fix this."
	exit 1
fi

#
# Step 5: runs coverity
#

make coverity
if [[ -z $(git status -s) ]]
then
	echo "Run \`make coverity\' locally to fix this."
	exit 1
fi

#
# Step 8: make sure all the files have a license.
#

make license
if [[ -z $(git status -s) ]]
then
	echo "Run \`make license\' locally to fix this."
	exit 1
fi