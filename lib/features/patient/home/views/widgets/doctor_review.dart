import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class DoctorReview extends StatelessWidget {
  const DoctorReview({
    super.key,
    this.averageRating = 0.0,
    this.reviewCount = 0,
  });

  final double averageRating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final hasReviews = reviewCount > 0;
    final displayRating = hasReviews ? averageRating : 0.0;
    final label = hasReviews
        ? '${displayRating.toStringAsFixed(1)} ($reviewCount)'
        : 'New';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StarRow(rating: displayRating),
        SizedBox(width: SizeConfig.width * 0.01),
        Text(
          label,
          style: AppTextStyles.title12WhiteW500,
        ),
      ],
    );
  }
}

/// Renders up to 5 stars with full, half, and empty states.
class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = i + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star_rounded;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(
          icon,
          size: SizeConfig.width * 0.035,
          color: Colors.amber,
        );
      }),
    );
  }
}
