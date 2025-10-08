.DEFAULT_TARGET: book

.PHONY: bootstrap
bootstrap:
	scripts/bootstrap

.PHONY: book
book:
	mdbook build
	rm -rf book/submods/services/perf
	find book/submods/ -type f -and -not -name \*.html -delete
	find book/submods/ -type d -and -empty -delete

.PHONY: serve
serve:
	mdbook serve

.PHONY: clean
clean:
	rm -rf book/
