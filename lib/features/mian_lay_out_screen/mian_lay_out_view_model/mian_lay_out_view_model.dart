import 'dart:ui';

import 'package:blue_bird/features/home/presentation/views/home_view.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../utils/assets_manager.dart';

class MainLayoutViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  String _currentLanguage;

  static const String _languageKey = 'selected_language';

  MainLayoutViewModel() : _currentLanguage = _getDeviceLocale() {
    _loadLanguage();
  }

  int get selectedIndex => _selectedIndex;
  String get currentLanguage => _currentLanguage;

  List<TabItem> _getTabs(BuildContext context) {
    return [
      TabItem(
        icon: SVGAssets.homeTab,
        label: Text(
          StringsManager.home,
          style: AppTextStyles.font14W800White(context),
        ),
        screen: const HomeScreen(),
      ),
      TabItem(
        icon: SVGAssets.statistics,
        label: Text(
          StringsManager.statisticis,
          style: AppTextStyles.font14W800White(context),
        ),
        screen: const HomeScreen(),
      ),
    ];
  }

  List<TabItem> tabs(BuildContext context) => _getTabs(context);

  void onItemTapped(int index) {
    if (index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void setLanguage(String language) async {
    if (language != _currentLanguage) {
      _currentLanguage = language;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
    }
  }

  Widget currentScreen(BuildContext context) =>
      tabs(context)[_selectedIndex].screen;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    if (savedLanguage != null) {
      _currentLanguage = savedLanguage;
      notifyListeners();
    }
  }

  static String _getDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    return deviceLocale.languageCode;
  }
}

class TabItem {
  final String icon;
  final Text label;
  final Widget screen;

  TabItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}
