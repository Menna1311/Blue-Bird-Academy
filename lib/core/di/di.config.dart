// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/add_team/data/repos/add_team_repo_impl.dart' as _i129;
import '../../features/add_team/domain/repos/add_team_repo.dart' as _i749;
import '../../features/add_team/presentation/cubit/add_team_cubit.dart'
    as _i326;
import '../../features/attendance/data/repos/attendance_repo_impl.dart'
    as _i530;
import '../../features/attendance/domain/repos/attendance_repo.dart' as _i550;
import '../../features/attendance/presentation/cubit/attendance_cubit.dart'
    as _i518;
import '../../features/auth/login/data/repos/login_repo_impl.dart' as _i568;
import '../../features/auth/login/domain/repo/login_repod.dart' as _i253;
import '../../features/auth/login/presentation/cubit/login_cubit_cubit.dart'
    as _i768;
import '../../features/auth/register/data/register_repo_impl.dart' as _i759;
import '../../features/auth/register/domain/repos/register_repo.dart' as _i369;
import '../../features/auth/register/presentation/cubit/register_cubit.dart'
    as _i805;
import '../../features/auth/reset_password/data/repo/reset_password_repo_impl.dart'
    as _i941;
import '../../features/auth/reset_password/domain/repo/reset_password_repo.dart'
    as _i465;
import '../../features/auth/reset_password/presentation/cubit/reset_password_cubit.dart'
    as _i538;
import '../../features/home/data/repos/home_repo_impl.dart' as _i647;
import '../../features/home/domain/repos/home_repo.dart' as _i130;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../service/auth_service.dart' as _i850;
import '../service/database_service.dart' as _i8;
import '../service/firebase_auth_service.dart' as _i766;
import '../service/firestore_service.dart' as _i908;
import '../service/secure_storage_service.dart' as _i142;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i142.SecureStorageService>(
        () => _i142.SecureStorageService());
    gh.lazySingleton<_i8.DatabaseService>(() => _i908.FirestoreService());
    gh.lazySingleton<_i850.AuthService>(() => _i766.FirebaseAuthService());
    gh.factory<_i465.ResetPasswordRepo>(
        () => _i941.ResetPasswordRepoImpl(gh<_i850.AuthService>()));
    gh.factory<_i550.AttendanceRepo>(() => _i530.AttendanceRepoImpl(
          gh<_i8.DatabaseService>(),
          gh<_i850.AuthService>(),
        ));
    gh.factory<_i130.HomeRepo>(() => _i647.HomeRepoImpl(
          gh<_i8.DatabaseService>(),
          gh<_i850.AuthService>(),
          gh<_i142.SecureStorageService>(),
        ));
    gh.factory<_i9.HomeCubit>(() => _i9.HomeCubit(gh<_i130.HomeRepo>()));
    gh.factory<_i253.LoginRepo>(() => _i568.LoginRepoImpl(
          gh<_i850.AuthService>(),
          gh<_i142.SecureStorageService>(),
        ));
    gh.factory<_i768.LoginCubitCubit>(
        () => _i768.LoginCubitCubit(gh<_i253.LoginRepo>()));
    gh.factory<_i538.ResetPasswordCubit>(
        () => _i538.ResetPasswordCubit(gh<_i465.ResetPasswordRepo>()));
    gh.factory<_i749.AddTeamRepo>(
        () => _i129.AddTeamRepoImpl(gh<_i8.DatabaseService>()));
    gh.factory<_i369.RegisterRepo>(() => _i759.RegisterRepoImpl(
          gh<_i850.AuthService>(),
          gh<_i8.DatabaseService>(),
          gh<_i142.SecureStorageService>(),
        ));
    gh.factory<_i326.AddTeamCubit>(
        () => _i326.AddTeamCubit(gh<_i749.AddTeamRepo>()));
    gh.factory<_i518.AttendanceCubit>(
        () => _i518.AttendanceCubit(gh<_i550.AttendanceRepo>()));
    gh.factory<_i805.RegisterCubit>(
        () => _i805.RegisterCubit(gh<_i369.RegisterRepo>()));
    return this;
  }
}
