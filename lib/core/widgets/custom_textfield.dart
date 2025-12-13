import 'package:blue_bird/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final Function(String)? onChange;
  final TextEditingController? controller;
  final bool obscureText;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final String? errorText;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.hint,
    this.onChange,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.errorText,
    this.readOnly,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: TextFormField(
        keyboardAppearance: Brightness.dark,
        obscureText: _obscureText,
        validator: widget.validator,
        readOnly: widget.readOnly ?? false,
        onChanged: widget.onChange,
        controller: widget.controller,
        style: const TextStyle(color: ColorManager.white),
        decoration: InputDecoration(
          errorText: widget.errorText,
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: ColorManager.white, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: ColorManager.white, width: 2),
          ),
          prefixIcon: Icon(widget.prefixIcon, color: ColorManager.white),
          hintText: widget.hint,
          hintStyle: const TextStyle(color: ColorManager.halfTransparentWhite),
        ),
      ),
    );
  }
}
