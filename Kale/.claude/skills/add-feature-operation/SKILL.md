---
name: add-feature-operation
description: Add a new operation (action or query) to an existing Kalé feature through every Clean Architecture layer, from repository and datasources through the use case, notifier, page, and tests. Use when asked to add the ability to do something in a feature, add a repository method, or wire a new backend call to the UI.
---

# Add a feature operation

One operation is a **vertical slice**: domain → data → presentation → tests, built in that order so each layer
compiles against the one below it. Reference slice: `resendOtp` in `lib/features/auth/` (commit `f4f369c`).

Canonical shape (the project's decision): **notifiers call use cases, never repositories.** Some existing
notifiers still call repositories directly; they are legacy and you should not copy them.

## 0. Classify the operation

- **Syncable mutation** (create, update, or delete of transactions, budgets, savings…): the repository writes to Drift
  and enqueues a sync entry. Follow `docs/offline_sync.md` § "Lifecycle of a write". There's no remote call here; the
  `SyncHandler` pushes later. A delete is a soft delete (`markDeleted`) queued as an `update`; see § "Deletes".
  Money parameters are `int` minor units. If the entity is not syncable yet, use the `add-syncable-entity` skill first.
- **Local read**: the repository reads from the local datasource (`watch*` stream or `get*`). It never pulls from the
  server: pulling is restore and pull-to-refresh only (`SyncPuller`).
- **Remote-only call** (auth, one-off server actions): the repository checks `NetworkInfo.isConnected` first and returns
  `Left(NetworkFailure())` when offline.

## 1. Domain

- Add the method to the abstract repository in `domain/repositories/`, returning `Future<Either<Failure, T>>`
  (or `Stream<…>` for watches).
- Create `domain/usecases/<verb>_<noun>_usecase.dart`: a class extending `UseCase<T, Params>` that only delegates to the
  repository, plus a `<Name>Params` class with `const` constructor (use `NoParams` when empty). One use case per file.

## 2. Data

- **Remote datasource**: add the method to the abstract class, to the Supabase implementation (scoped by `user_id`,
  catching `PostgrestException`/`AuthException` and throwing `ServerException(message, statusCode)`), **and to the
  `Mock…RemoteDataSource` twin** (simulated delay, plausible data).
- **Local datasource** (if it touches Drift): add the method and wrap Drift errors in `CacheException`.
- **Repository implementation**: catch every exception the datasources can throw and map it:
  `ServerException`→`ServerFailure`, `CacheException`→`CacheFailure`, `NetworkException`→`NetworkFailure`,
  `UnauthorizedException`→`UnauthorizedFailure`. Nothing escapes as an exception.

## 3. Presentation

- In `presentation/providers/<feature>_providers.dart`, add a `@riverpod` provider for the use case:
  `<Name>UseCase <name>UseCase(Ref ref) => <Name>UseCase(ref.watch(<feature>RepositoryProvider));`
- In the notifier, add a method: set `loading`, call `ref.read(<name>UseCaseProvider).call(Params(...))`, then `fold`
  into `error(failure.message)` or `success()`/`loaded(...)`.
- If the outcome needs a new state variant, add a factory to the Freezed sealed `<Feature>State`.
- **Leave localization to the page**: emit `success()` with no message. The page picks the localized text
  (`message ?? l10n.<key>`, as in `add_transaction_page.dart`).
- In the page, `ref.listen` the notifier and react with `showAppSnackBar` / navigation. New strings go in **both**
  ARB files, then `make l10n`.

## 4. Generate

`make gen` (new providers, Freezed state). Then run `flutter analyze` until it is clean.

## 5. Test

Mirror `lib/` under `test/`. Copy the setup from the auth tests: mocks from `test/helpers/mock_providers.dart`
(add `class Mock<X> extends Mock implements <X> {}` there), `registerFallbackValue` for params/models in `setUpAll`.

- **Use case** (`domain/usecases/<name>_usecase_test.dart`): it delegates to the repository with the right arguments.
- **Repository** (`data/repositories/…_impl_test.dart`): one test for success, one per exception → failure mapping,
  and for remote-only calls, one for offline → `NetworkFailure`.
- **Notifier** (`presentation/providers/…_notifier_test.dart`): a `ProviderContainer` with use case providers overridden
  (`overrideWithValue`), asserting the state sequence for success and failure.

## Done when

- Every layer has the method, and the Supabase and mock remote datasources both implement it.
- The notifier reaches the repository only through the new use case provider.
- No user-facing English string in the notifier, and EN/FR ARB keys match.
- `make gen` has run, `flutter analyze` is clean, and `flutter test` passes, including the new tests above.
