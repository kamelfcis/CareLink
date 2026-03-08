import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/network/supabase/auth/change_password.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  /// If provided, pre-fills the email field (e.g. from settings)
  final String? initialEmail;

  const ForgotPasswordScreen({super.key, this.initialEmail});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await forgetPassword(_emailController.text.trim());
      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomQuickAlert.error(
          title: context.tr.error,
          message: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Scaffold(
      body: GradientHeader(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width * 0.05,
              ),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.height * 0.06),
                  // Lock icon
                  Container(
                    padding: EdgeInsets.all(SizeConfig.width * 0.06),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _emailSent
                          ? Icons.mark_email_read_rounded
                          : Icons.lock_reset_rounded,
                      size: SizeConfig.width * 0.15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.02),
                  Text(
                    _emailSent ? tr.checkYourEmail : tr.resetPassword,
                    style: AppTextStyles.title22WhiteColorBold,
                  ),
                  SizedBox(height: SizeConfig.height * 0.04),
                  // Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 0.05,
                      vertical: SizeConfig.height * 0.035,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _emailSent
                        ? _buildSuccessContent(tr)
                        : _buildFormContent(tr),
                  ),
                  SizedBox(height: SizeConfig.height * 0.03),
                  // Back to login
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tr.backToLogin,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(dynamic tr) {
    return Column(
      children: [
        Text(
          tr.resetPasswordDesc,
          style: AppTextStyles.title14Grey,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.height * 0.03),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: AppColors.kPrimaryColor,
            style: AppTextStyles.title16Black,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return tr.pleaseEnterEmail;
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return tr.pleaseEnterValidEmail;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: tr.enterYourEmail,
              hintStyle: AppTextStyles.title14Grey,
              prefixIcon: Icon(
                CupertinoIcons.mail,
                color: AppColors.kPrimaryColor,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width * 0.04,
                vertical: SizeConfig.height * 0.018,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.kPrimaryColor.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.kPrimaryColor.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.kPrimaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.025),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.kPrimaryColor.withOpacity(0.6),
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.height * 0.018,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    tr.sendResetLink,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent(dynamic tr) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: SizeConfig.width * 0.12,
            color: Colors.green,
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.02),
        Text(
          tr.resetLinkSent,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.green.shade700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.height * 0.012),
        Text(
          tr.resetLinkSentDesc,
          style: AppTextStyles.title14Grey,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.height * 0.025),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _emailSent = false;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.kPrimaryColor,
              side: BorderSide(color: AppColors.kPrimaryColor),
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.height * 0.016,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              tr.sendResetLink,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}








