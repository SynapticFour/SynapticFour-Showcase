# SynapticFour Showcase — orchestrated multi-repo demo lifecycle

.PHONY: help up down destroy golden-path

help:
	@echo "SynapticFour Showcase — local lifecycle"
	@echo ""
	@echo "  make up            Run golden path (Ferrum-GA4GH-Demo + HELIOS audit)"
	@echo "  make golden-path   Same as make up"
	@echo "  make down          Stop demo + BRA stacks (keep volumes)"
	@echo "  make destroy       Stop stacks + remove volumes (--hard)"
	@echo ""
	@echo "Requires sibling repos: Ferrum-GA4GH-Demo, HELIOS (optional: bioresearch-assistant)"
	@echo "Scripts: scripts/run-golden-path.sh, scripts/stop-showcase.sh"

up: golden-path

golden-path:
	@chmod +x scripts/run-golden-path.sh scripts/stop-showcase.sh 2>/dev/null || true
	./scripts/run-golden-path.sh

down:
	@chmod +x scripts/stop-showcase.sh 2>/dev/null || true
	./scripts/stop-showcase.sh

destroy:
	@chmod +x scripts/stop-showcase.sh 2>/dev/null || true
	./scripts/stop-showcase.sh --hard
