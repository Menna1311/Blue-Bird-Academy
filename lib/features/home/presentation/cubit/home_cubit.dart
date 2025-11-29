import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/home/domain/entities/session_entity.dart';
import 'package:blue_bird/features/home/domain/repos/home_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepo) : super(HomeInitial());
  final HomeRepo _homeRepo;
  late String trainerId;
  late String teamId;
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
}
