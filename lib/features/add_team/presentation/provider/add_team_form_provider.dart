import 'package:flutter/material.dart';
import '../../domain/entities/player_entity.dart';

class AddTeamFormProvider extends ChangeNotifier {
  String teamName = '';
  String? ageCategory;
  List<String> trainingDays = [];
  TimeOfDay? trainingTime;
  List<PlayerEntity> players = [];

  void setTeamName(String value) {
    teamName = value;
    notifyListeners();
  }

  void setAgeCategory(String? value) {
    ageCategory = value;
    notifyListeners();
  }

  void setTrainingDays(List<String> days) {
    trainingDays = days;
    notifyListeners();
  }

  void setTrainingTime(TimeOfDay time) {
    trainingTime = time;
    notifyListeners();
  }

  void setPlayers(List<PlayerEntity> list) {
    players = list;
    notifyListeners();
  }

  bool isValid() {
    return teamName.isNotEmpty &&
        ageCategory != null &&
        trainingDays.isNotEmpty &&
        trainingTime != null &&
        players.isNotEmpty;
  }
}
