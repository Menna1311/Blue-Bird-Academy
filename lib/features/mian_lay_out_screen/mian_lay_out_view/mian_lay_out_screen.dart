import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/color_manager.dart';
import '../mian_lay_out_view_model/mian_lay_out_view_model.dart';

class MainLayOutScreen extends StatelessWidget {
  const MainLayOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainLayoutViewModel(),
      child: Builder(
        builder: (context) {
          // 🔥 TEMPORARY FIX UNTIL LOCALIZATION IS ADDED
          String locale = 'en';
          try {
            locale = context.locale.toString();
          } catch (_) {
            // Prevent crash when EasyLocalization is not used yet
          }

          return _MainLayoutBody(
            key: ValueKey(locale),
          );
        },
      ),
    );
  }
}

class _MainLayoutBody extends StatelessWidget {
  const _MainLayoutBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainLayoutViewModel>();

    return WillPopScope(
      onWillPop: () async {
        if (viewModel.selectedIndex != 0) {
          viewModel.onItemTapped(0);
          return false;
        }
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        extendBody:
            false, // Changed from true to false to prevent body from extending behind the navigation bar
        // 🔥 FIXED — pass context
        body: viewModel.currentScreen(context),
        bottomNavigationBar: const _MainBottomNavigationBar(),
      ),
    );
  }
}

class _MainBottomNavigationBar extends StatelessWidget {
  const _MainBottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainLayoutViewModel>();
    final selectedIndex = viewModel.selectedIndex;

    // 🔥 FIXED — now requires context
    final tabs = viewModel.tabs(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.015;
    final iconSize = screenWidth * 0.07;
    final fontSize = screenWidth * 0.03;

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: screenHeight * 0.02,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.grey,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (index) {
              final isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () => viewModel.onItemTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.006,
                  ),
                  decoration: isSelected
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.05),
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        tabs[index].icon,
                        colorFilter: ColorFilter.mode(
                          isSelected ? ColorManager.primary : Colors.white,
                          BlendMode.srcIn,
                        ),
                        width: iconSize,
                      ),
                      if (isSelected)
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.004),
                          child: Text(
                            tabs[index].label.data!,
                            style: TextStyle(
                              color: ColorManager.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
