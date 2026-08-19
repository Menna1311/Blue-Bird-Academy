import 'package:easy_localization/easy_localization.dart';

import '../../../../utils/assets_manager.dart';

class OnBoardingData {
  static final List<Map<String, String>> onboardingData = [
    {
      "image": ImageAssets.onBoarding3,
      "title": "Discipline Builds\nChampions".tr(),
      "description":
          "Consistent attendance creates strong teams. Track presence, build commitment, and shape future champions."
              .tr()
    },
    {
      "image": ImageAssets.onBoarding2,
      "title": "Attendance Made\nSimple".tr(),
      "description":
          "Mark player attendance in seconds. Stay organized, save time, and focus on coaching."
              .tr()
    },
    {
      "image": ImageAssets.onBoarding1,
      "title": "Every Session\nMatters".tr(),
      "description":
          "Monitor player commitment across all sessions. Clear records help you lead your team with confidence."
              .tr()
    },
  ];
}
