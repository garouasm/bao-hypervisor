export BASEDIR=$(pwd)

.PHONY: all
all:
	intercept-build make -f bao.mk

.PHONY: clean
clean:
	make -f bao.mk clean

.PHONY: format
format:
	@echo "Formatting..."
	@find src/ -name \*.c -o -name \*.cc -o -name \*.h | xargs -r clang-format-12 -style file -i
	@find configs/ -name \*.c -o -name \*.cc -o -name \*.h | xargs -r clang-format-12 -style file -i

.PHONY: cppcheck
cppcheck:
	@echo "Checking..."
	@find src/ \(-name \*.c \)| xargs cppcheck --error-exitcode=1 --dump 
	@find src/ \(-name \*.c.dump\) | xargs python $(BASEDIR)/fenxi/scripts/misra.py --rule-texts=$(BASEDIR)/fenxi/scripts/rules.txt
	@find . \(-name \*.c.dump\) | xargs rm
	@find . \(-name \*.c.dump.dump\) | xargs rm
	@find . \(-name \*.c.dump.dump.dump\) | xargs rm
	@find . \(-name \*.c.dump.dump.dump.dump\) | xargs rm
#@find src/ \( -name \*.c.dump \) | xargs -r0 mv -t $(BASEDIR)/fenxi/
#-t means target directory

#cppcheck --error-exitcode=1 --dump --cppcheck-build-dir=.  *.c
#python $BASEDIR/misra.py --rule-texts=$BASEDIR/rules.txt ./$(BASEDIR)/lsl.xml

#clang-tidy is a clang-based C++ “linter” tool.
#Its purpose is to provide an extensible framework for diagnosing and fixing typical programming errors, like style violations,
#interface misuse, or bugs that can be deduced via static analysis. clang-tidy is modular and provides a convenient interface
#writing new checks.

.PHONY: tidy
tidy:
	@echo "Tidying..."
	@clang-tidy-10 --list-checks
	@find src/core/ -name \*.c -o -name \*.h | xargs clang-tidy-10 -p ./
	

.PHONY: coverity
tidy:
	@echo "Coveritying..."
	
