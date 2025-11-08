import 'package:bloc/bloc.dart';
import 'package:blue_bird/core/common/result.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/add_team/domain/repos/add_team_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'add_team_state.dart';

@injectable
class AddTeamCubit extends Cubit<AddTeamState> {
  AddTeamCubit(this._addTeamRepo) : super(AddTeamInitial());
  final AddTeamRepo _addTeamRepo;

  Future<void> addTeam(String trainerId, TeamModel addTeamRequest) async {
    emit(AddTeamLoading());

    final result = await _addTeamRepo.addTeam(trainerId, addTeamRequest);
    switch (result) {
      case Success<bool>():
        emit(AddTeamSuccess());
        break;
      case Fail<bool>():
        emit(AddTeamFailure(result.exception!));
        break;
    }
    emit(AddTeamSuccess());
  }
}
