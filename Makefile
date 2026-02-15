SHELL := /bin/bash

CARGO ?= cargo
MAKE ?= make

.PHONY: check fmt fmt-check clippy test deny doc machete ci clean docker-up docker-down

check:
	$(CARGO) check --workspace --all-features --all-targets

fmt:
	$(CARGO) fmt --all

fmt-check:
	$(CARGO) fmt --all -- --check

clippy:
	$(CARGO) clippy --workspace --all-features --all-targets -- -D warnings

test:
	$(CARGO) nextest run --workspace --all-features --all-targets

doc:
	$(CARGO) doc --workspace --all-features --no-deps

deny:
	$(CARGO) deny check

clean:
	$(CARGO) clean

machete:
	@if ! $(CARGO) --list | grep -q 'machete'; then \
		echo "Installing cargo-machete..."; \
		$(CARGO) install cargo-machete --locked; \
	fi
	$(CARGO) machete --with-metadata

ci:
	$(MAKE) fmt-check
	$(MAKE) clippy
	$(MAKE) test
	$(MAKE) doc
	$(MAKE) deny
	$(MAKE) machete

docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-down:
	docker compose down -v
