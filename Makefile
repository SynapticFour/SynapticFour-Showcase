# SynapticFour Showcase — orchestrated multi-repo demo lifecycle

.PHONY: help up down destroy golden-path golden-path-with-solum solum-stage \
	evidence-pack evidence-pack-fixtures consent-gate consent-gate-deny consent-gate-fixtures \
	h21-teeth h22-org-cap \
	gatk-rs-smoke gatk-rs-smoke-fixtures gatk-rs-wes s4mp-evidence s4mp-evidence-fixtures \
	integration-suite integration-suite-fixtures verification-publish preflight

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
	@echo "  make h21-teeth              H2.1: Solum revoke → Ferrum WES/DRS 403"
	@echo "  make h22-org-cap            H2.2: org-IAM mapping artefact gate"
	@echo "  make gatk-rs-smoke          Optional gatk-rs HC smoke (soft-fail)"
	@echo "  make gatk-rs-smoke-fixtures CI fixtures for gatk-rs smoke"
	@echo "  make gatk-rs-wes            Optional Ferrum --gatk-rs WES path (soft-fail)"
	@echo "  make s4mp-evidence          Optional S4MP port-diff sidecar (soft-fail)"
	@echo "  make s4mp-evidence-fixtures CI fixtures for S4MP sidecar"
	@echo "  make integration-suite      Customer verification suite (fixtures + optional live)"
	@echo "  make integration-suite-fixtures  Fixtures only + publish demo/verification/"
	@echo "  make verification-publish   Re-publish demo/verification/ from fixtures"
	@echo "  make evidence-pack          Build Evidence Pack from latest/local artefacts"
	@echo "  make evidence-pack-fixtures Evidence Pack from committed fixtures"
	@echo "  make preflight              Local environment checks"
	@echo "  make down / make destroy    Stop stacks"
	@echo ""
	@echo "Customer start: docs/for-customers/overview.md"
	@echo "Consent before WES: SHOWCASE_ENABLE_CONSENT_GATE=1 make golden-path"
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

h21-teeth:
	@chmod +x scripts/run-h21-teeth.sh 2>/dev/null || true
	./scripts/run-h21-teeth.sh

h22-org-cap:
	@chmod +x scripts/run-h22-org-cap.sh 2>/dev/null || true
	./scripts/run-h22-org-cap.sh

gatk-rs-smoke:
	@chmod +x scripts/run-gatk-rs-smoke.sh 2>/dev/null || true
	./scripts/run-gatk-rs-smoke.sh

gatk-rs-smoke-fixtures:
	@chmod +x scripts/run-gatk-rs-smoke.sh 2>/dev/null || true
	./scripts/run-gatk-rs-smoke.sh --fixtures --publish-examples

gatk-rs-wes:
	@chmod +x scripts/run-gatk-rs-wes.sh 2>/dev/null || true
	./scripts/run-gatk-rs-wes.sh

s4mp-evidence:
	@chmod +x scripts/attach-s4mp-evidence.sh 2>/dev/null || true
	./scripts/attach-s4mp-evidence.sh

s4mp-evidence-fixtures:
	@chmod +x scripts/attach-s4mp-evidence.sh 2>/dev/null || true
	./scripts/attach-s4mp-evidence.sh --fixtures --publish-examples

integration-suite:
	@chmod +x scripts/run-integration-suite.sh 2>/dev/null || true
	./scripts/run-integration-suite.sh --fixtures --publish-verification

integration-suite-fixtures: integration-suite

verification-publish:
	@chmod +x scripts/run-integration-suite.sh 2>/dev/null || true
	./scripts/run-integration-suite.sh --fixtures --publish-verification

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
