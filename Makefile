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
	@find . -type f -name "*.c" | xargs cppcheck --dump
#retirei o parametro de retorno de retorno de erro
	@find . -type f -name "*.c.dump" | xargs ./fenxi/scripts/misra.py --rule-texts=./fenxi/scripts/rules.txt --cli
# --cli -> Addon is executed from cppcheck
	@find . -type f -name "*.dump" -print0 | xargs -I {} -0 rm -v "{}"


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
	
