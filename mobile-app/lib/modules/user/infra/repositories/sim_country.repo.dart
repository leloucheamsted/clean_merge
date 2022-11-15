import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/repositories/either.mixin.dart';

import 'package:tello_social_app/modules/user/domain/repositories/i_sim_country.repo.dart';
import 'package:tello_social_app/modules/user/infra/datasources/i_sim_country.datasource.dart';

class SimCountryRepo with EitherMixin implements ISimCountryRepo {
  final ISimCountryDataSource _dataSource;
  SimCountryRepo(this._dataSource);

  @override
  Future<Either<IFailure, String?>> getSIMCountryCode() {
    return runWithEither(() => _dataSource.getSIMCountryCode());
  }
}
