SHELL := /bin/bash
VPATH := src/

PANDOC_OPTIONS := --include-in-header=src/templates/head.html \
	--include-before-body=src/templates/navigation.html \
	--css /assets/css/bootstrap.min.css \
	--metadata=document-css:true \
	--metadata=monobackgroundcolor:\#f5f5f5 \
	--highlight-style src/templates/highlight_style.theme \
	--mathjax

COMMON_TEMPLATES := src/templates/head.html src/templates/navigation.html src/templates/styles.html

MD := $(shell find src/posts -type f -name '*.md' ! -name README.md -maxdepth 2 -mindepth 2)
IPYNB := $(shell find src/posts -type f -name '*.ipynb' -maxdepth 2 -mindepth 2)
HTML := $(MD:src/posts/%.md=posts/%.html) $(IPYNB:src/posts/%.ipynb=posts/%.html)
YAML := $(MD:%.md=%.yaml) $(IPYNB:%.ipynb=%.yaml)

.PHONY: all
all: $(HTML) index.html about.html courses.html

.PHONY: serve
serve:
	python3 -m http.server --directory $(shell pwd) --bind 127.0.0.1

.PHONY: clean
clean:
	rm -f index.md
	rm -f index.html
	rm -f about.html
	rm -rf posts

posts/%.html: posts/%.md posts/%.yaml $(COMMON_TEMPLATES) templates/post.html
	mkdir -p $(@D)
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/post.html \
		--from markdown+backtick_code_blocks+inline_code_attributes \
		--to html \
		-o $@ $<

posts/%.html: posts/%.ipynb posts/%.yaml $(COMMON_TEMPLATES) templates/post.html
	mkdir -p $(@D)
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/post.html \
		--to html \
		--metadata-file ${<:%.ipynb=%.yaml} \
		-o $@ $<

about.html: about.md $(COMMON_TEMPLATES) templates/about.html
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/about.html \
		--from markdown \
		--to html \
		-o $@ $<

index.html: index.md $(COMMON_TEMPLATES) templates/index.html
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/index.html \
		--from markdown \
		--to html \
		-o $@ $<

courses.html: courses.md $(COMMON_TEMPLATES) templates/index.html
	pandoc \
		$(PANDOC_OPTIONS) \
		--template=src/templates/index.html \
		--from markdown \
		--to html \
		-o $@ $<

index.md: util.py $(YAML)
	python3 util.py build_index_md $(YAML) > index.md
