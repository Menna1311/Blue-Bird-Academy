import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static double? _screenWidth;
  static double? _scaleFactor;

  static void _ensureCache(BuildContext context) {
    if (_screenWidth != null && _scaleFactor != null) return;

    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _scaleFactor = _screenWidth! / 400;
  }

  static double _getResponsiveFontSize(BuildContext context, double fontSize) {
    _ensureCache(context);
    final responsiveSize = fontSize * _scaleFactor!;
    final lowerLimit = fontSize * 0.8;
    final upperLimit = fontSize * 1.2;
    return responsiveSize.clamp(lowerLimit, upperLimit);
  }

  static TextStyle font24W500White(
    BuildContext context, {
    Color? color = ColorManager.white,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final size = _getResponsiveFontSize(context, fontSize ?? AppSize.s24);
    return GoogleFonts.balooThambi2(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }

  static TextStyle font18W400White(
    BuildContext context, {
    Color? color = ColorManager.white,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final size = _getResponsiveFontSize(context, fontSize ?? AppSize.s18);
    return GoogleFonts.balooThambi2(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }

  static TextStyle font24W800White(
    BuildContext context, {
    Color? color = ColorManager.white,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    final size = _getResponsiveFontSize(context, fontSize ?? AppSize.s24);
    return GoogleFonts.balooThambi2(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }

  static TextStyle font20W800White(
    BuildContext context, {
    Color? color = ColorManager.white,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    final size = _getResponsiveFontSize(context, fontSize ?? AppSize.s20);
    return GoogleFonts.balooThambi2(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }

  static TextStyle font14W800White(
    BuildContext context, {
    Color? color = ColorManager.white,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    final size = _getResponsiveFontSize(context, fontSize ?? AppSize.s14);
    return GoogleFonts.balooThambi2(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }

  static TextStyle titleFont24W600(
    BuildContext context, {
    Color? color = ColorManager.white,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final size = _getResponsiveFontSize(context, fontSize ?? AppSize.s24);
    return GoogleFonts.balooThambi2(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }

  static TextStyle font18W400primary(
    BuildContext context, {
    Color? color = ColorManager.primary,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final size = _getResponsiveFontSize(context, fontSize ?? AppSize.s18);
    return GoogleFonts.balooThambi2(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
