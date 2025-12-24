import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/add_team/domain/entities/team_entity.dart';
import 'package:blue_bird/features/auth/login/domain/entities/user_entity.dart';

import 'package:blue_bird/features/home/domain/entities/session_entity.dart';
import 'package:blue_bird/features/home/domain/repos/home_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepo) : super(HomeInitial());
  final HomeRepo _homeRepo;

  // Add user property
  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  // Add method to get current user
  Future<void> getCurrentUser() async {
    emit(UserLoading());
    final result = await _homeRepo.getLoggedInUser();
    switch (result) {
      case Success<UserEntity>():
        _currentUser = result.data;
        emit(UserLoaded(result.data!));
        break;
      case Fail<UserEntity>():
        emit(UserError(result.exception!));
        break;
    }
  }

  Future<void> getSession(
      String trainerId, String teamId, String sessionId) async {
    emit(SessionLoading());
    final result = await _homeRepo.getSession(trainerId, teamId, sessionId);
    switch (result) {
      case Success<SessionEntity>():
        emit(SessionLoaded(result.data!));
        break;
      case Fail<SessionEntity>():
        emit(SessionError(result.exception!));
        break;
    }
  }

  Future<void> getSessions(String trainerId, String teamId) async {
    emit(SessionLoading());
    final result = await _homeRepo.getSessions(trainerId, teamId);

    if (result is Success<List<SessionEntity>>) {
      emit(SessionsLoaded(result.data!));
    } else if (result is Fail<List<SessionEntity>>) {
      emit(SessionError(result.exception!));
    }
  }

  Future<void> getTeams(String trainerId) async {
    emit(TeamsLoading());

    final result = await _homeRepo.getTeams(trainerId);

    if (result is Success<List<TeamEntity>>) {
      emit(TeamsLoaded(result.data!));
    } else if (result is Fail<List<TeamEntity>>) {
      emit(TeamsError(result.exception!));
    }
  }
}
