all: news docs contrib

news:
	@luajit ./build-utils/make-news.lua

docs:
	@luajit ./build-utils/make-docs.lua

contrib:
	@luajit ./build-utils/make-contrib.lua

clean:
	rm -rf news/ docs/

.PHONY: news docs clean
