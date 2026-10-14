import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/core/network/network_info.dart';
import 'package:kale/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:kale/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:kale/features/profile/data/models/profile_model.dart';
import 'package:kale/features/profile/domain/repositories/profile_repository.dart';

/// Offline-first [ProfileRepository]: writes go to Drift and the sync queue.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo;

  final ProfileRemoteDataSource _remote;
  final ProfileLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Stream<Currency?> watchBaseCurrency() =>
      _local.watchProfile().map(_currencyOf);

  @override
  Future<Either<Failure, Currency?>> getBaseCurrency() async {
    try {
      return Right(_currencyOf(await _local.getProfile()));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Currency>> setBaseCurrency(Currency currency) async {
    try {
      final model = ProfileModel(
        baseCurrency: currency.code,
        updatedAt: DateTime.now(),
      );
      await _local.saveProfile(model);
      await _local.enqueueSync(
        operation: 'update',
        payload: jsonEncode(model.toJson()),
      );
      return Right(currency);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> refreshFromServer() async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      final remote = await _remote.getProfile();
      if (remote != null) await _local.applyServerProfile(remote);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  static Currency? _currencyOf(ProfileModel? profile) =>
      profile == null ? null : Currencies.byCode(profile.baseCurrency);
}
