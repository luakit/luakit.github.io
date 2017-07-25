all: news

news:
	@luajit ./build-utils/make-news.lua

.PHONY: news
