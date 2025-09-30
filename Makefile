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

# Configuration management targets
.PHONY: validate-config
validate-config:
	@echo "Validating configuration files..."
	@chmod +x scripts/validate-config
	@if [ -f "/opt/veraison/config/services/config.yaml" ]; then \
		python3 scripts/validate-config /opt/veraison/config/services/config.yaml; \
	else \
		echo "No configuration file found at /opt/veraison/config/services/config.yaml"; \
		echo "To validate a specific file, run: python3 scripts/validate-config <path-to-config>"; \
	fi

.PHONY: check-security
check-security: validate-config
	@echo "Running security-specific checks..."
	@chmod +x scripts/validate-config
	@if [ -f "/opt/veraison/config/services/config.yaml" ]; then \
		python3 scripts/validate-config --security-only /opt/veraison/config/services/config.yaml; \
	else \
		echo "No configuration file found for security check"; \
	fi

.PHONY: migrate-config
migrate-config:
	@echo "Migrating configuration to latest version..."
	@chmod +x scripts/migrate-config
	@if [ -f "/opt/veraison/config/services/config.yaml" ]; then \
		python3 scripts/migrate-config /opt/veraison/config/services/config.yaml; \
	else \
		echo "No configuration file found to migrate"; \
		echo "Usage: python3 scripts/migrate-config <path-to-config>"; \
	fi

.PHONY: install-config-tools
install-config-tools:
	@echo "Installing configuration management dependencies..."
	@python3 -m pip install --upgrade pip
	@python3 -m pip install pyyaml jsonschema
	@chmod +x scripts/validate-config scripts/migrate-config
	@echo "Configuration tools installed successfully!"

.PHONY: test-config
test-config: install-config-tools
	@echo "Testing configuration tools with templates..."
	@python3 scripts/validate-config src/services/templates/config.development.yaml
	@echo "Development template validation completed"
	@python3 scripts/validate-config src/services/templates/config.production.yaml
	@echo "Production template validation completed"

.PHONY: help-config
help-config:
	@echo "Configuration Management Commands:"
	@echo "  make install-config-tools  - Install required dependencies"
	@echo "  make validate-config       - Validate current configuration"
	@echo "  make check-security        - Run security checks only"
	@echo "  make migrate-config        - Migrate config to latest version"
	@echo "  make test-config           - Test tools with provided templates"
	@echo ""
	@echo "Manual Usage:"
	@echo "  python3 scripts/validate-config <config-file>"
	@echo "  python3 scripts/migrate-config <config-file> --target-version 2.0"
