class AddTeamRequest {
  final String name;
  final String teamAgeCategory;
  final List<String> trainingDays;
  final DateTime trainingTime;
  final List<Players> players;

  AddTeamRequest(this.name, this.teamAgeCategory, this.trainingDays,
      this.trainingTime, this.players);
}

class Players {
  final String name;
  final String jerseyNumber;

  Players(this.name, this.jerseyNumber);
}
