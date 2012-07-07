
DIRS = . ./info ./download ./project ./document
SRCS = $(foreach dir, $(DIRS), $(wildcard $(dir)/*.html))

.PHONY: all test validate

all:
	@echo "Do nothing."

test: validate

validate: $(patsubst %.html, validate/%.xml, $(SRCS))

validate/%.xml: %.html
	@test -d `dirname $@` || mkdir -p `dirname $@`
	@curl --output $@ --fail --silent --form "uploaded_file=@$<" --form "output=soap12" http://validator.w3.org/check
	@test -f $@ && xsltproc --stringparam filename $< style/soap2txt.xslt $@

clean:
	$(RM) -r validate
