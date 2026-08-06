# SynapticFour Showcase — orchestrated multi-repo demo lifecycle

.PHONY: help up down destroy golden-path golden-path-with-solum solum-stage \
	evidence-pack evidence-pack-fixtures consent-gate consent-gate-deny consent-gate-fixtures \
	gatk-rs-smoke gatk-rs-smoke-fixtures s4mp-evidence s4mp-evidence-fixtures preflight

help:
	@echo "SynapticFour Showcase — local lifecycle"
	@echo ""
	@echo "  make up                     Run golden path (Ferrum-GA4GH-Demo + HELIOS audit)"
	@echo "  make golden-path            Same as make up"
	@echo "  make golden-path-with-solum Golden path + Solum-Demo Stage-1"
	@echo "  make solum-stage            Solum-Demo Stage-1 only"
	@echo "  make consent-gate           PhenoFlow purpose → Solum grant (allow)"
	@echo "  make consent-gate-deny      Deny path (WES must not proceed)"
	@echo "  make consent-gate-fixtures  CI fixtures for consent gate"
	@echo "  make gatk-rs-smoke          Optional gatk-rs HC smoke (soft-fail)"
	@echo "  make gatk-rs-smoke-fixtures CI fixtures for gatk-rs smoke"
	@echo "  make s4mp-evidence          Optional S4MP port-diff sidecar (soft-fail)"
	@echo "  make s4mp-evidence-fixtures CI fixtures for S4MP sidecar"
	@echo "  make evidence-pack          Build Evidence Pack from latest/local artefacts"
	@echo "  make evidence-pack-fixtures Evidence Pack from committed fixtures"
	@echo "  make preflight              Local environment checks"
	@echo "  make down / make destroy    Stop stacks"
	@echo ""
	@echo "Consent before WES: SHOWCASE_ENABLE_CONSENT_GATE=1 make golden-path"
	@echo "Deny demo: SHOWCASE_ENABLE_CONSENT_GATE=1 SHOWCASE_CONSENT_GATE_MODE=deny make golden-path"
	@echo "W4 opt-in: SHOWCASE_ENABLE_GATK_RS=1 SHOWCASE_ENABLE_S4MP=1 make golden-path"
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

consent-gate:
	@chmod +x scripts/run-consent-gate.sh 2>/dev/null || true
	./scripts/run-consent-gate.sh --allow

consent-gate-deny:
	@chmod +x scripts/run-consent-gate.sh 2>/dev/null || true
	./scripts/run-consent-gate.sh --deny

consent-gate-fixtures:
	@chmod +x scripts/run-consent-gate.sh 2>/dev/null || true
	./scripts/run-consent-gate.sh --fixtures --publish-examples

gatk-rs-smoke:
	@chmod +x scripts/run-gatk-rs-smoke.sh 2>/dev/null || true
	./scripts/run-gatk-rs-smoke.sh

gatk-rs-smoke-fixtures:
	@chmod +x scripts/run-gatk-rs-smoke.sh 2>/dev/null || true
	./scripts/run-gatk-rs-smoke.sh --fixtures --publish-examples

s4mp-evidence:
	@chmod +x scripts/attach-s4mp-evidence.sh 2>/dev/null || true
	./scripts/attach-s4mp-evidence.sh

s4mp-evidence-fixtures:
	@chmod +x scripts/attach-s4mp-evidence.sh 2>/dev/null || true
	./scripts/attach-s4mp-evidence.sh --fixtures --publish-examples

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
