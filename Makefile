# setup tools macros
CLANG_FORMAT := clang-format-12
CPPCHECK   	 := cppcheck
CLANG_TIDY   := clang-tidy-10

# Check tools
ifeq (, $(shell which $(CLANG_FORMAT)))
$(error "No $(CLANG_FORMAT) installed, please proceed to the instalation.")
endif
ifeq (, $(shell which $(CPPCHECK )))
$(error "No $(CPPCHECK ) installed, please proceed to the instalation.")
endif
ifeq (, $(shell which $(CLANG_TIDY)))
$(error "No $(CLANG_TIDY) installed, please proceed to the instalation.")
endif

# set current dir
base_dir := $(abspath .)
fenxi_dir := $(base_dir)/fenxi

.PHONY: all
all:
	intercept-build make -f bao.mk

.PHONY: clean
clean:
	make -f bao.mk clean

.PHONY: format
format:
	@echo "Running $(shell $(CLANG_FORMAT) --version) ..."
	@find src/ -name \*.c -o -name \*.cc -o -name \*.h | xargs -r $(CLANG_FORMAT) -style file -i
	@find configs/ -name \*.c -o -name \*.cc -o -name \*.h | xargs -r $(CLANG_FORMAT) -style file -i
	@echo "$(shell $(CLANG_FORMAT) --version) is finished."

.PHONY: cppcheck
cppcheck:
	@echo "Running $(shell $(CPPCHECK) --version) ..."
	@find . -type f -name "*.c" | xargs cppcheck --dump
#retirei o parametro de retorno de retorno de erro
	@find . -type f -name "*.c.dump" | xargs $(fenxi_dir)/scripts/misra.py --rule-texts=$(fenxi_dir)/scripts/rules.txt --cli
# --cli -> Addon is executed from cppcheck
	@find . -type f -name "*.dump" -print0 | xargs -I {} -0 rm -v "{}"
	@echo "$(shell $(CPPCHECK) --version) is finished."


#clang-tidy is a clang-based C++ “linter” tool.
#Its purpose is to provide an extensible framework for diagnosing and fixing typical programming errors, like style violations,
#interface misuse, or bugs that can be deduced via static analysis. clang-tidy is modular and provides a convenient interface
#writing new checks.

.PHONY: tidy
tidy:
	@echo "Running $(shell $(CLANG_TIDY) --version) ..."
	@$(CLANG_TIDY) --list-checks
	@find src/core/ -name \*.c -o -name \*.h | xargs $(CLANG_TIDY) -p ./
	@echo "$(shell $(CLANG_TIDY) --version) is finished."
	

.PHONY: coverity
tidy:
	@echo "Coveritying..."
	
