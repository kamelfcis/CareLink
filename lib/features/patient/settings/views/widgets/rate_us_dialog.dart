import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';

class RateUsDialog extends StatefulWidget {
  const RateUsDialog({super.key});

  @override
  State<RateUsDialog> createState() => _RateUsDialogState();
}

class _RateUsDialogState extends State<RateUsDialog>
    with SingleTickerProviderStateMixin {
  int _selectedRating = 0;
  bool _submitted = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.width * 0.06),
          child: _submitted ? _buildThankYou(tr) : _buildRatingForm(tr),
        ),
      ),
    );
  }

  Widget _buildRatingForm(dynamic tr) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon
        Container(
          padding: EdgeInsets.all(SizeConfig.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star_rounded,
            color: Colors.amber,
            size: SizeConfig.width * 0.1,
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.02),
        Text(
          tr.rateUsTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          tr.rateUsDesc,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.height * 0.025),
        // Stars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = starIndex;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.015,
                ),
                child: Icon(
                  starIndex <= _selectedRating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: starIndex <= _selectedRating
                      ? Colors.amber
                      : Colors.grey.shade300,
                  size: SizeConfig.width * 0.1,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8),
        Text(
          _selectedRating == 0 ? tr.rateUsTapStar : '$_selectedRating / 5',
          style: TextStyle(
            fontSize: 13,
            color: _selectedRating == 0
                ? Colors.grey.shade400
                : AppColors.kPrimaryColor,
            fontWeight:
                _selectedRating == 0 ? FontWeight.w400 : FontWeight.w600,
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.025),
        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedRating > 0
                ? () {
                    setState(() {
                      _submitted = true;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              disabledForegroundColor: Colors.grey.shade400,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.height * 0.016,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              tr.rateUsSubmit,
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

  Widget _buildThankYou(dynamic tr) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: SizeConfig.width * 0.12,
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.02),
        Text(
          tr.rateUsThankYou,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.green.shade700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          tr.rateUsThankYouDesc,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.height * 0.02),
        // Show selected stars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _selectedRating,
            (index) => Icon(
              Icons.star_rounded,
              color: Colors.amber,
              size: SizeConfig.width * 0.07,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.height * 0.025),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.height * 0.016,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              'OK',
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
}

/// Helper to show the rate us dialog
void showRateUsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const RateUsDialog(),
  );
}








