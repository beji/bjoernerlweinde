SITE_FILES := $(shell fd --extension org --extension html)
STATIC_FILES := $(shell fd . ./static)
STATIC_OUT_FILES := $(subst static,public/static,$(STATIC_FILES))

IMAGE_VERSION = 1.0.0

public/static/%: static/%
	mkdir -p $(dir $@)
	cp $< $@

all: public/index.html

public/style.css: style.scss
	mkdir -p $(dir $@)
	sassc $< $@

public/index.html: public/style.css $(STATIC_OUT_FILES) $(SITE_FILES) publish.el
	./publish.doom

##############################
# This is for the dev server #
##############################

server: http-server
	./$< -c=css,html -i ./public

http-server:
	curl -L https://github.com/TheWaWaR/simple-http-server/releases/download/v$(DEVSERVER_VERSION)/x86_64-unknown-linux-musl-simple-http-server -o $@
	chmod +x @

publish:
	rsync -av ./public webserver:/opt/bde

clean:
	-rm -rf public
	-rm -rf tmp
	-rm -rf out
	-rm -rf posts/index.org
	-rm -rf ${HOME}/.org-timestamps/bde-root.cache
	-rm -rf ${HOME}/.org-timestamps/bde-posts.cache
	-rm -rf ${HOME}/.org-timestamps/bde-static.cache

.PHONY: server clean all publish
