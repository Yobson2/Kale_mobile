.PHONY: help get gen watch test analyze format l10n clean run run-local run-staging run-prod build-staging build-prod icons splash integration db-start db-stop db-reset db-diff-live

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

get: ## Install dependencies
	flutter pub get

gen: ## Run code generation (freezed, json_serializable, riverpod)
	dart run build_runner build --delete-conflicting-outputs

watch: ## Watch mode for code generation
	dart run build_runner watch --delete-conflicting-outputs

test: ## Run all unit and widget tests
	flutter test

integration: ## Run integration tests
	flutter test integration_test

analyze: ## Run static analysis
	flutter analyze

format: ## Format all Dart files
	dart format .

l10n: ## Generate localization files
	flutter gen-l10n

clean: ## Clean build artifacts
	flutter clean
	flutter pub get

run: ## Run the app with every datasource mocked (no backend needed)
	flutter run --flavor staging --dart-define-from-file=config/mock.json

run-local: ## Run against the local Supabase stack (config/local.json)
	flutter run --flavor staging --dart-define-from-file=config/local.json

run-staging: ## Run against the staging Supabase project (config/staging.json)
	flutter run --flavor staging --dart-define-from-file=config/staging.json

run-prod: ## Run against the production Supabase project (config/production.json)
	flutter run --flavor production --dart-define-from-file=config/production.json

build-staging: ## Build a staging release APK
	flutter build apk --flavor staging --dart-define-from-file=config/staging.json

build-prod: ## Build a production release app bundle
	flutter build appbundle --flavor production --dart-define-from-file=config/production.json

db-start: ## Start the local Supabase stack (needs Docker)
	npx supabase start

db-stop: ## Stop the local Supabase stack
	npx supabase stop

db-reset: ## Recreate the local database from supabase/migrations
	npx supabase db reset

db-diff-live: ## Diff the linked (live) project against supabase/migrations
	npx supabase db diff --linked --schema public,auth,storage > supabase/live_drift.sql

icons: ## Generate app icons (requires flutter_launcher_icons)
	dart run flutter_launcher_icons

splash: ## Generate native splash screen (requires flutter_native_splash)
	dart run flutter_native_splash:create
