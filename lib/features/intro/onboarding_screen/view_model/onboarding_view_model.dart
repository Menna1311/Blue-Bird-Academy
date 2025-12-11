import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> implements OnboardingCubitOutPut {
  final PageController _pageController = PageController();

  OnboardingCubit() : super(0);

  void updatePage(int index) => emit(index);

  @override
  PageController get getPageController => _pageController;

  @override
  Future<void> close() {
    _pageController.dispose();
    return super.close();
  }
}

abstract class OnboardingCubitOutPut {
  PageController get getPageController;
}
