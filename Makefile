# SynapticFour Showcase — orchestrated multi-repo demo lifecycle

.PHONY: help up down destroy golden-path golden-path-with-solum solum-stage evidence-pack evidence-pack-fixtures preflight

help:
	@echo "SynapticFour Showcase — local lifecycle"
	@echo ""
	@echo "  make up                     Run golden path (Ferrum-GA4GH-Demo + HELIOS audit)"
	@echo "  make golden-path            Same as make up"
	@echo "  make golden-path-with-solum Golden path + Solum-Demo Stage-1 (SHOWCASE_ENABLE_SOLUM=1)"
	@echo "  make solum-stage            Solum-Demo Stage-1 only (fail-closed authz + tamper audit)"
	@echo "  make evidence-pack          Build Evidence Pack from latest/local artefacts"
	@echo "  make evidence-pack-fixtures Evidence Pack from committed fixtures (CI / no Docker)"
	@echo "  make preflight              Local environment checks (warn by default)"
	@echo "  make down                   Stop demo + BRA + Solum-Demo stacks (keep volumes)"
	@echo "  make destroy                Stop stacks + remove volumes (--hard)"
	@echo ""
	@echo "Requires sibling repos: Ferrum-GA4GH-Demo, HELIOS"
	@echo "Optional: bioresearch-assistant (M2), Solum-Demo, HelixTest"
	@echo "See: docs/IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md"

up: golden-path

golden-path:
	@chmod +x scripts/run-golden-path.sh scripts/stop-showcase.sh 2>/dev/null || true
	./scripts/run-golden-path.sh

golden-path-with-solum:
	@chmod +x scripts/run-golden-path.sh scripts/run-solum-stage.sh scripts/stop-showcase.sh 2>/dev/null || true
	SHOWCASE_ENABLE_SOLUM=1 ./scripts/run-golden-path.sh

solum-stage:
	@chmod +x scripts/run-solum-stage.sh 2>/dev/null || true
	./scripts/run-solum-stage.sh

evidence-pack:
	@chmod +x scripts/evidence-pack.sh 2>/dev/null || true
	./scripts/evidence-pack.sh

evidence-pack-fixtures:
	@chmod +x scripts/evidence-pack.sh 2>/dev/null || true
	./scripts/evidence-pack.sh --fixtures

preflight:
	@chmod +x scripts/preflight.sh 2>/dev/null || true
	./scripts/preflight.sh

down:
	@chmod +x scripts/stop-showcase.sh 2>/dev/null || true
	./scripts/stop-showcase.sh

destroy:
	@chmod +x scripts/stop-showcase.sh 2>/dev/null || true
	./scripts/stop-showcase.sh --hard
