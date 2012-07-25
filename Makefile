
DIRS = . ./info ./download ./project ./document
SRCS = $(foreach dir, $(DIRS), $(wildcard $(dir)/*.xhtml))
OUTS = $(patsubst %.xhtml, %.html, $(SRCS))

.PHONY: all build test validate

all: build

build: $(OUTS)

%.html: %.xhtml ./2012/07/mozilla-gumi.xslt
	xsltproc --param debug "false()" --stringparam page-modified $(shell date -r $< -u +"%Y-%m-%dT%H:%M:%SZ") ./2012/07/mozilla-gumi.xslt $< > $@

test: validate

validate: $(patsubst %.html, validate/%.xml, $(OUTS))

validate/%.xml: %.html ./2012/06/soap2txt.xslt
	@test -d `dirname $@` || mkdir -p `dirname $@`
	@curl --output $@ --fail --silent --form "uploaded_file=@$<" --form "output=soap12" http://validator.w3.org/check
	@test -f $@ && xsltproc --stringparam filename $< ./2012/06/soap2txt.xslt $@

clean:
	$(RM) -r validate
	$(RM) $(OUTS)
