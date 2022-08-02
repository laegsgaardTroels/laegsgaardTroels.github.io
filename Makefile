SHELL := /bin/bash

PANDOC_OPTIONS := --include-in-header=templates/head.html \
	--include-before-body=templates/navigation.html \
	--css /assets/css/bootstrap.min.css \
	--metadata=document-css:true \
	--metadata=monobackgroundcolor:\#f5f5f5 \
	--highlight-style templates/highlight_style.theme \
	--mathjax

COMMON_TEMPLATES := templates/head.html templates/navigation.html templates/styles.html

COURSES_MD := $(wildcard src/courses/*.md)
COURSES_HTML := $(COURSES_MD:src/courses/%.md=posts/%.html) 
COURSES_META := $(COURSES_MD:src/courses/%.md=meta/%.yaml)

POSTS_MD := $(wildcard src/posts/*.md) 
POSTS_HTML := $(POSTS_MD:src/posts/%.md=posts/%.html) 
POSTS_META := $(POSTS_MD:src/posts/%.md=meta/%.yaml) 

.PHONY: all
all: index.html about.html courses.html $(POSTS_HTML) $(COURSES_HTML)

.PHONY: serve
serve:
	python -m http.server --directory $(shell pwd)

.PHONY: clean
clean:
	rm -f index.html
	rm -f about.html
	rm -f $(POSTS_HTML)
	rm -f $(POSTS_META)
	rm -f $(COURSES_HTML)
	rm -f $(COURSES_META)
	rm -f meta/index.json

$(POSTS_HTML): posts/%.html: src/posts/%.md meta/%.yaml $(COMMON_TEMPLATES) templates/post.html 
	echo "$< -> $@"
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=templates/post.html \
		--metadata-file ${@:posts/%.html=meta/%.yaml} \
		--from markdown+backtick_code_blocks+inline_code_attributes \
		--to html \
		-o $@ $<

$(POSTS_META): meta/%.yaml: src/posts/%.md src/meta.py
	python src/meta.py post -i $< -o $@

about.html: src/about.md $(COMMON_TEMPLATES) templates/about.html 
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=templates/about.html \
		--from markdown \
		--to html \
		-o $@ $<

index.html: src/index.md meta/index.json $(COMMON_TEMPLATES) templates/index.html 
	echo "$< -> $@"
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=templates/index.html \
		--metadata-file meta/index.json \
		--from markdown \
		--to html \
		-o $@ src/index.md

meta/index.json: src/meta.py $(POSTS_MD)
	python src/meta.py index -i $(POSTS_MD) -o $@

$(COURSES_HTML): posts/%.html: src/courses/%.md meta/%.yaml $(COMMON_TEMPLATES) templates/post.html 
	echo "$< -> $@"
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=templates/post.html \
		--metadata-file ${@:posts/%.html=meta/%.yaml} \
		--from markdown+backtick_code_blocks+inline_code_attributes \
		--to html \
		-o $@ $<

$(COURSES_META): meta/%.yaml: src/courses/%.md src/meta.py
	python src/meta.py post -i $< -o $@

courses.html: src/courses.md meta/courses.json $(COMMON_TEMPLATES) templates/index.html 
	echo "$< -> $@"
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=templates/index.html \
		--metadata-file meta/courses.json \
		--from markdown \
		--to html \
		-o $@ src/courses.md

meta/courses.json: src/meta.py $(COURSES_MD)
	python src/meta.py index -i $(COURSES_MD) -o $@
