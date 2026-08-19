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

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  List<TeamEntity> _allTeams = [];
  WeekDay? _selectedDay;

  final Map<String, List<SessionEntity>> _teamSessions = {};

  // ================= USER =================

  Future<void> getCurrentUser() async {
    emit(UserLoading());

    final result = await _homeRepo.getLoggedInUser();

    switch (result) {
      case Success():
        _currentUser = result.data;
        emit(UserLoaded(result.data!));
        break;

      case Fail():
        emit(UserError(result.exception!));
        break;
    }
  }

  // ================= TEAMS =================

  Future<void> getTeams(String trainerId) async {
    emit(TeamsLoading());

    final result = await _homeRepo.getTeams(trainerId);

    if (result is Success<List<TeamEntity>>) {
      _allTeams = result.data!;

      // 🔥 Load sessions for each team
      for (final team in _allTeams) {
        await _loadTeamSessions(trainerId, team.id);
      }

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

  Future<void> _loadTeamSessions(String trainerId, String teamId) async {
    final result = await _homeRepo.getSessions(trainerId, teamId);

    if (result is Success<List<SessionEntity>>) {
      _teamSessions[teamId] = result.data!;
    }
  }

  // ================= GET UPCOMING =================

  SessionEntity? getUpcomingSession(String teamId) {
    final sessions = _teamSessions[teamId];

    if (sessions == null || sessions.isEmpty) return null;

    final now = DateTime.now();

    try {
      return sessions.firstWhere(
        (s) => s.status == 'scheduled' && s.date.isAfter(now),
      );
    } catch (_) {
      return null;
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

  // ================= LOGOUT =================

  Future<void> logout() async {
    await _homeRepo.logout();
  }
}
