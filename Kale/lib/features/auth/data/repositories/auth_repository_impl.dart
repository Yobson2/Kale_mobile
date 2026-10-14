import 'package:dartz/dartz.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/core/sync/sync_engine.dart';
import 'package:kale/core/sync/sync_puller.dart';
import 'package:kale/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kale/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kale/features/auth/data/models/tokens_model.dart';
import 'package:kale/features/auth/data/models/user_model.dart';
import 'package:kale/features/auth/domain/entities/account_link.dart';
import 'package:kale/features/auth/domain/entities/user.dart';
import 'package:kale/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] that coordinates between
/// remote and local data sources.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an [AuthRepositoryImpl].
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required AppDatabase appDatabase,
    required SyncEngine syncEngine,
    required SyncPuller syncPuller,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo,
        _appDatabase = appDatabase,
        _syncEngine = syncEngine,
        _syncPuller = syncPuller;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final NetworkInfo _networkInfo;
  final AppDatabase _appDatabase;
  final SyncEngine _syncEngine;
  final SyncPuller _syncPuller;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.login(email: email, password: password);
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(result.user.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.register(name: name, email: email, password: password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> verifyOtp({
    required String email,
    required String code,
    bool isRecovery = false,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.verifyOtp(
        email: email,
        code: code,
        isRecovery: isRecovery,
      );
      if (result != null) {
        await _local.cacheTokens(result.tokens);
        await _local.cacheUser(result.user);
        return Right(result.user.toEntity());
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp({required String email}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.resendOtp(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.updatePassword(newPassword: newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, int>> backUpPendingChanges() async {
    try {
      final status = await _syncEngine.backUpNow();
      return Right(status.pendingCount + status.stuckCount);
    } on Exception catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await _networkInfo.isConnected) {
        await _remote.logout();
      }
    } on Exception {
      // Signing out on the server is best effort: the user asked to leave,
      // so the session and data on this phone go regardless.
    }
    try {
      await _local.clearAll();
      await _appDatabase.clearAllData();
      await _syncEngine.onLocalDataCleared();
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final model = await _local.getCachedUser();
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<bool> get isAuthenticated => _local.hasToken();

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.signInWithGoogle();
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(result.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.signInWithApple();
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(result.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInAnonymously() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.signInAnonymously();
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(result.user.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  // ── Guest upgrade ─────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, LinkResult>> linkSocialAccount(
    SocialProvider provider,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.linkSocialAccount(provider);
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(AccountLinked(result.user.toEntity()));
    } on IdentityInUseException catch (e) {
      return Right(IdentityInUse(e.credential));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, LinkResult?>> startEmailLink(String email) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.startEmailLink(email);
      return const Right(null);
    } on IdentityInUseException catch (e) {
      return Right(IdentityInUse(e.credential));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> confirmEmailLink({
    required String email,
    required String code,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.confirmEmailLink(
        email: email,
        code: code,
        password: password,
      );
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(result.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendSignInCode(String email) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.sendSignInCode(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, int>> countGuestEntries() async {
    try {
      return Right(await _appDatabase.countEntries());
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> switchToExistingAccount({
    required AccountCredential credential,
    required bool keepGuestData,
    String? code,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    // Sign in first: if it fails, the guest session and its data are
    // untouched.
    final ({UserModel user, TokensModel tokens}) result;
    try {
      result = await _remote.signInWithCredential(credential, code: code);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
    try {
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      if (keepGuestData) {
        // Every entry becomes a new entry of this account, pushed as a
        // create; then the account's own data is pulled in alongside.
        await _appDatabase.rekeyForAnotherAccount();
        for (final handler in _syncEngine.handlers) {
          await handler.requeueAllAsCreates();
        }
        await _syncEngine.processQueue();
        await _syncPuller.pull();
      } else {
        await _appDatabase.clearAllData();
        await _syncEngine.onLocalDataCleared();
        await _syncPuller.restoreIfNeeded();
      }
      return Right(result.user.toEntity());
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
