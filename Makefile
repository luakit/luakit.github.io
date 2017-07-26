all: news docs

news:
	@luajit ./build-utils/make-news.lua

docs:
	@luajit ./build-utils/make-docs.lua

clean:
	rm -rf news/ docs/

.PHONY: news docs clean
