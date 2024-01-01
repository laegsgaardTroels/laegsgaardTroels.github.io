SHELL := /bin/bash

PANDOC_OPTIONS := --include-in-header=src/templates/head.html \
	--include-before-body=src/templates/navigation.html \
	--css /assets/css/bootstrap.min.css \
	--metadata=document-css:true \
	--metadata=monobackgroundcolor:\#f5f5f5 \
	--highlight-style src/templates/highlight_style.theme \
	--mathjax

COMMON_TEMPLATES := src/templates/head.html src/templates/navigation.html src/templates/styles.html

COURSES_MD := $(wildcard src/courses/*.md)
COURSES_HTML := $(COURSES_MD:src/courses/%.md=posts/%.html)
COURSES_META := $(COURSES_MD:src/courses/%.md=meta/%.json)

POSTS_MD := $(wildcard src/posts/*.md)
POSTS_HTML := $(POSTS_MD:src/posts/%.md=posts/%.html)
POSTS_META := $(POSTS_MD:src/posts/%.md=meta/%.json)

.PHONY: all
all: index.html about.html courses.html $(POSTS_HTML) $(COURSES_HTML)

.PHONY: serve
serve:
	python3 -m http.server --directory $(shell pwd) --bind 127.0.0.1

.PHONY: clean
clean:
	rm -f index.html
	rm -f about.html
	rm -f $(POSTS_HTML)
	rm -f $(POSTS_META)
	rm -f $(COURSES_HTML)
	rm -f $(COURSES_META)
	rm -f meta/index.json

$(POSTS_HTML): posts/%.html: src/posts/%.md meta/%.json $(COMMON_TEMPLATES) src/templates/post.html
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/post.html \
		--metadata-file ${@:posts/%.html=meta/%.json} \
		--from markdown+backtick_code_blocks+inline_code_attributes \
		--to html \
		-o $@ $<

$(POSTS_META): meta/%.json: src/posts/%.md src/meta.py
	python3 src/meta.py post -i $< -o $@

about.html: src/about.md $(COMMON_TEMPLATES) src/templates/about.html
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/about.html \
		--from markdown \
		--to html \
		-o $@ $<

index.html: meta/index.json $(COMMON_TEMPLATES) src/templates/index.html
	echo '' | pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/index.html \
		--metadata-file meta/index.json \
		--from markdown \
		--to html \
		-o $@

meta/index.json: src/meta.py $(POSTS_MD)
	python3 src/meta.py index -i $(POSTS_MD) -o $@

$(COURSES_HTML): posts/%.html: src/courses/%.md meta/%.json $(COMMON_TEMPLATES) src/templates/post.html
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/post.html \
		--metadata-file ${@:posts/%.html=meta/%.json} \
		--from markdown+backtick_code_blocks+inline_code_attributes \
		--to html \
		-o $@ $<

$(COURSES_META): meta/%.json: src/courses/%.md src/meta.py
	python3 src/meta.py post -i $< -o $@

courses.html: meta/courses.json $(COMMON_TEMPLATES) src/templates/index.html
	echo '' | pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/index.html \
		--metadata-file meta/courses.json \
		--from markdown \
		--to html \
		-o $@

meta/courses.json: src/meta.py $(COURSES_MD)
	python3 src/meta.py index -i $(COURSES_MD) -o $@
