
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

#make coverity
#if [[ -z $(git status -s) ]]
#then
#	echo "Run \`make coverity\' locally to fix this."
#	exit 1
#fi

#
# Step 8: make sure all the files have a license.
#

#make license
#if [[ -z $(git status -s) ]]
#then
#	echo "Run \`make license\' locally to fix this."
#	exit 1
#fi