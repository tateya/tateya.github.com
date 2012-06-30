
.PHONY: all test validate validate-top validate-info

all:
	@echo "Do nothing."

test: validate

validate: validate-top validate-info

validate-top: $(patsubst %.html, validate/%.xml, $(wildcard *.html))

validate-info: $(patsubst info/%.html, validate/info/%.xml, $(wildcard info/*.html))

validate/%.xml: %.html
	@test -d `dirname $@` || mkdir -p `dirname $@`
	@curl --output $@ --fail --silent --form "uploaded_file=@$<" --form "output=soap12" http://validator.w3.org/check
	@test -f $@ && xsltproc --stringparam filename $< style/soap2txt.xslt $@

clean:
	$(RM) -r validate
