# SynapticFour Showcase — orchestrated multi-repo demo lifecycle

.PHONY: help up down destroy golden-path golden-path-with-solum solum-stage \
	evidence-pack evidence-pack-fixtures consent-gate consent-gate-deny consent-gate-fixtures \
	h21-teeth h22-org-cap h23-ops-polish \
	gatk-rs-smoke gatk-rs-smoke-fixtures gatk-rs-wes s4mp-evidence s4mp-evidence-fixtures \
	co-deploy-harvest co-deploy-harvest-fixtures \
	integration-suite integration-suite-fixtures verification-publish preflight \
	path-eplus-smoke check-pins checkout-pins honesty

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
	@echo "  make h23-ops-polish         H2.3: ops polish + second-pass docs gate"
	@echo "  make gatk-rs-smoke          Optional gatk-rs HC smoke (soft-fail)"
	@echo "  make gatk-rs-smoke-fixtures CI fixtures for gatk-rs smoke"
	@echo "  make gatk-rs-wes            Optional Ferrum --gatk-rs WES path (soft-fail)"
	@echo "  make s4mp-evidence          Optional S4MP port-diff sidecar (soft-fail)"
	@echo "  make s4mp-evidence-fixtures CI fixtures for S4MP sidecar"
	@echo "  make co-deploy-harvest      Soft-harvest Demo Passports co_deploy into artefacts"
	@echo "  make co-deploy-harvest-fixtures  CI fixtures for Passports co-deploy harvest"
	@echo "  make integration-suite      Customer verification suite (fixtures + optional live)"
	@echo "  make integration-suite-fixtures  Fixtures only + publish demo/verification/"
	@echo "  make verification-publish   Re-publish demo/verification/ from fixtures"
	@echo "  make evidence-pack          Build Evidence Pack from latest/local artefacts"
	@echo "  make evidence-pack-fixtures Evidence Pack from committed fixtures"
	@echo "  make path-eplus-smoke       Live Path E+ (Solum CDR+subject-link; soft-fail)"
	@echo "  make preflight              Environment checks (strict)"
	@echo "  make check-pins             Compare PINNED_VERSIONS.txt to sibling HEAD (warn)"
	@echo "  make checkout-pins          Detach siblings to pinned SHAs (required for make up)"
	@echo "  make down / make destroy    Stop stacks"
	@echo ""
	@echo "Customer start: docs/for-customers/start-here.md"
	@echo "Pins: make checkout-pins before make up, or SHOWCASE_ALLOW_PIN_DRIFT=1"
	@echo "Solum token: SOLUM_SIDECAR_TOKEN or SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1"
	@echo "Consent before WES: SHOWCASE_ENABLE_CONSENT_GATE=1 make golden-path"
	@echo "W4 opt-in: SHOWCASE_ENABLE_GATK_RS=1 SHOWCASE_ENABLE_S4MP=1 make golden-path"
	@echo "Passports harvest: SHOWCASE_ENABLE_CO_DEPLOY_HARVEST=1 make golden-path"
	@echo "See: docs/for-customers/start-here.md"

up: golden-path

golden-path:
	./scripts/run-golden-path.sh

golden-path-with-solum:
	SHOWCASE_ENABLE_SOLUM=1 ./scripts/run-golden-path.sh

solum-stage:
	./scripts/run-solum-stage.sh

consent-gate:
	./scripts/run-consent-gate.sh --allow

consent-gate-deny:
	./scripts/run-consent-gate.sh --deny

consent-gate-fixtures:
	./scripts/run-consent-gate.sh --fixtures --publish-examples

h21-teeth:
	./scripts/run-h21-teeth.sh

h22-org-cap:
	./scripts/run-h22-org-cap.sh

h23-ops-polish:
	./scripts/run-h23-ops-polish.sh

gatk-rs-smoke:
	./scripts/run-gatk-rs-smoke.sh

gatk-rs-smoke-fixtures:
	./scripts/run-gatk-rs-smoke.sh --fixtures --publish-examples

gatk-rs-wes:
	./scripts/run-gatk-rs-wes.sh

s4mp-evidence:
	./scripts/attach-s4mp-evidence.sh

s4mp-evidence-fixtures:
	./scripts/attach-s4mp-evidence.sh --fixtures --publish-examples

co-deploy-harvest:
	./scripts/harvest-co-deploy.sh

co-deploy-harvest-fixtures:
	./scripts/harvest-co-deploy.sh --fixtures --publish-examples

integration-suite:
	./scripts/run-integration-suite.sh --fixtures --publish-verification

integration-suite-fixtures: integration-suite

verification-publish:
	./scripts/run-integration-suite.sh --fixtures --publish-verification

evidence-pack:
	./scripts/evidence-pack.sh

evidence-pack-fixtures:
	./scripts/evidence-pack.sh --fixtures

path-eplus-smoke:
	./scripts/path-eplus-smoke.sh

preflight:
	./scripts/preflight.sh --strict

check-pins:
	./scripts/check-pins.sh

checkout-pins:
	./scripts/checkout-pins.sh

honesty:
	./scripts/check-honesty.sh

down:
	./scripts/stop-showcase.sh

destroy:
	./scripts/stop-showcase.sh --hard
