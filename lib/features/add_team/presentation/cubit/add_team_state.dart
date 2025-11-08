part of 'add_team_cubit.dart';

@immutable
sealed class AddTeamState {}

final class AddTeamInitial extends AddTeamState {}

final class AddTeamSuccess extends AddTeamState {}

final class AddTeamFailure extends AddTeamState {
  final Exception message;
  AddTeamFailure(this.message);
}

final class AddTeamLoading extends AddTeamState {}
