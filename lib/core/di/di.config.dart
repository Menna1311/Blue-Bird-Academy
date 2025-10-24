// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/login/data/repos/login_repo_impl.dart' as _i568;
import '../../features/auth/login/domain/repo/login_repod.dart' as _i253;
import '../../features/auth/login/presentation/cubit/login_cubit_cubit.dart'
    as _i768;
import '../providers/user_provider.dart' as _i26;
import '../service/firebase_auth_service.dart' as _i766;
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
    gh.factory<_i26.UserProvider>(() => _i26.UserProvider());
    gh.singleton<_i142.SecureStorageService>(
        () => _i142.SecureStorageService());
    gh.lazySingleton<_i766.FirebaseAuthService>(
        () => _i766.FirebaseAuthService());
    gh.factory<_i253.LoginRepo>(() => _i568.LoginRepoImpl(
          gh<_i766.FirebaseAuthService>(),
          gh<_i142.SecureStorageService>(),
        ));
    gh.factory<_i768.LoginCubitCubit>(
        () => _i768.LoginCubitCubit(gh<_i253.LoginRepo>()));
    return this;
  }
}
