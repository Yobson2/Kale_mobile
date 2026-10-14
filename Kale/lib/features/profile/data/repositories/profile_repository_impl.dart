import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kale/core/error/exceptions.dart';
import 'package:kale/core/error/failures.dart';
import 'package:kale/core/money/currency.dart';
import 'package:kale/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:kale/features/profile/data/models/profile_model.dart';
import 'package:kale/features/profile/domain/repositories/profile_repository.dart';

/// Offline-first [ProfileRepository]: writes go to Drift and the sync queue.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required ProfileLocalDataSource localDataSource,
  }) : _local = localDataSource;

  final ProfileLocalDataSource _local;

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

  static Currency? _currencyOf(ProfileModel? profile) =>
      profile == null ? null : Currencies.byCode(profile.baseCurrency);
}
