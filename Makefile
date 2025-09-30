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

.PHONY: validate-config
validate-config:
	@echo "Validating configuration..."
	@chmod +x scripts/validate-config
	@find /opt/veraison/config -name "*.yaml" -type f -exec scripts/validate-config {} \;

.PHONY: check-security
check-security: validate-config
	@echo "Running security checks..."
	@scripts/validate-config --security-only /opt/veraison/config/services/config.yaml

.PHONY: install-config-tools
install-config-tools:
	@echo "Installing configuration validation dependencies..."
	@pip3 install pyyaml jsonschema
