import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormFieldWithTitle extends StatefulWidget {
  const CustomTextFormFieldWithTitle({
    super.key,
    this.onChanged,
    this.enable = true,
    required this.hintText,
    this.title,
    this.isPassword = false,
    this.controller,
    this.enableValidator = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.onTap,
    this.keyboardType,
    this.maxLength,
  });
  final String hintText;
  final int? maxLength;
  final String? title;
  final TextInputType? keyboardType;
  final bool isPassword, enableValidator;
  final TextEditingController? controller;
  final int maxLines;
  final bool? enable;
  final IconData? prefixIcon;
  final Function(String)? onChanged;
  final Function()? onTap;
  @override
  State<CustomTextFormFieldWithTitle> createState() =>
      _CustomTextFormFieldWithTitleState();
}

class _CustomTextFormFieldWithTitleState
    extends State<CustomTextFormFieldWithTitle> {
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title == null
            ? SizedBox()
            : Text(widget.title!, style: AppTextStyles.title16BlackBold),
        SizedBox(height: context.screenHeight * 0.004),
        TextFormField(
          maxLength: widget.maxLength,
          style: AppTextStyles.title18Black,
          onTap: widget.onTap,
          enabled: widget.enable,
          cursorColor: AppColors.kPrimaryColor,
          controller: widget.controller,
          onChanged: widget.onChanged,
          validator: widget.enableValidator
              ? (value) =>
                  value!.isEmpty ? "Field ${widget.title} is required" : null
              : null,
          obscureText: widget.isPassword ? isPassword : false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.white10,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.screenWidth * 0.03,
              vertical: context.screenHeight * 0.016,
            ),
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon, color: AppColors.kPrimaryColor),
            hintStyle: AppTextStyles.title14Grey,
            border: buildBorder(),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(),
            disabledBorder: buildBorder(),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    icon: Icon(
                      isPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.kPrimaryColor,
                    ),
                  )
                : null,
          ),
          textAlignVertical: TextAlignVertical.center,
          maxLines: widget.maxLines,
        ),
      ],
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: AppColors.kPrimaryColor,
        width: 0.5,
      ),
    );
  }
}
