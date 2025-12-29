import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/core/week_days.dart';
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
  List<TeamEntity> _allTeams = [];
  WeekDay? _selectedDay;
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
      _allTeams = result.data!;

      // 🔥 Auto select TODAY
      _selectedDay = WeekDayX.fromDateTime(DateTime.now());

      emit(
        TeamsLoaded(
          allTeams: _allTeams,
          filteredTeams: _filterTeamsByDay(_selectedDay!),
          selectedDay: _selectedDay,
        ),
      );
    } else if (result is Fail<List<TeamEntity>>) {
      emit(TeamsError(result.exception!));
    }
  }

  // ================= FILTER =================

  void filterByDay(WeekDay? day) {
    _selectedDay = day;

    emit(
      TeamsLoaded(
        allTeams: _allTeams,
        filteredTeams: day == null ? _allTeams : _filterTeamsByDay(day),
        selectedDay: _selectedDay,
      ),
    );
  }

  List<TeamEntity> _filterTeamsByDay(WeekDay day) {
    return _allTeams
        .where((team) => team.trainingDays.contains(day.key))
        .toList();
  }

  String _getTodayName() {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  Future<void> logout() async {
    final result = await _homeRepo.logout();
    if (result is Success<void>) {
      // Handle successful logout if needed
    } else if (result is Fail<void>) {
      // Handle logout error if needed
    }
  }
}
