import 'package:care_link/core/helper/launch_link.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:care_link/features/patient/doctor_details/view_models/cubit/connect_with_doctor_cubit.dart';
import 'package:care_link/features/patient/doctor_details/view_models/cubit/doctor_reviews_cubit.dart';
import 'package:care_link/features/patient/doctor_details/views/widgets/connect_button.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final doctor = DoctorModel.fromJson(args);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DoctorProfileScreenBody(doctor: doctor),
    );
  }
}

class DoctorProfileScreenBody extends StatelessWidget {
  const DoctorProfileScreenBody({
    super.key,
    required this.doctor,
    this.enableConnect = true,
  });

  final DoctorModel doctor;
  final bool enableConnect;

  @override
  Widget build(BuildContext context) {
    final pageContent = GradientHeader(
      child: ListView(
        padding: EdgeInsets.all(SizeConfig.width * 0.04),
        children: [
          _DoctorHeader(doctor: doctor),
          SizedBox(height: SizeConfig.height * 0.02),
          _DoctorDetailsCard(doctor: doctor),
          SizedBox(height: SizeConfig.height * 0.02),
          _ContactSection(
            doctor: doctor,
          ),
          if (enableConnect) ...[
            SizedBox(height: SizeConfig.height * 0.025),
            ConnectButton(doctorId: doctor.id),
          ],
          SizedBox(height: SizeConfig.height * 0.025),
          _ReviewsSection(doctorId: doctor.id),
          SizedBox(height: SizeConfig.height * 0.02),
        ],
      ),
    );
    if (!enableConnect) {
      return pageContent;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectWithDoctorCubit, ConnectWithDoctorState>(
          listener: (context, state) {
            if (state is ConnectWithDoctorSuccess) {
              CustomQuickAlert.success(
                title: context.tr.success,
                message: context.tr.connectedWithDoctorSuccess,
              );
            } else if (state is ConnectWithDoctorDisconnected) {
              CustomQuickAlert.success(
                title: context.tr.success,
                message: context.tr.disconnectedSuccess,
              );
            } else if (state is ConnectWithDoctorFailure) {
              CustomQuickAlert.error(
                title: context.tr.error,
                message: state.message,
              );
            }
          },
        ),
        BlocListener<DoctorReviewsCubit, DoctorReviewsState>(
          listener: (context, state) {
            if (state is DoctorReviewSubmitSuccess) {
              CustomQuickAlert.success(
                title: context.tr.success,
                message: context.tr.reviewSubmittedSuccess,
              );
            } else if (state is DoctorReviewDeleteSuccess) {
              CustomQuickAlert.success(
                title: context.tr.success,
                message: context.tr.reviewDeletedSuccess,
              );
            } else if (state is DoctorReviewsFailure) {
              CustomQuickAlert.error(
                title: context.tr.error,
                message: state.message,
              );
            }
          },
        ),
      ],
      child: pageContent,
    );
  }
}

class _DoctorHeader extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorHeader({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final imageUrl = doctor.doctor?.image.trim();
    final hasPhoto = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              radius: SizeConfig.width * 0.1,
              backgroundColor: AppColors.kPrimaryLight,
              backgroundImage:
                  hasPhoto ? NetworkImage(imageUrl) : null,
              child: hasPhoto
                  ? null
                  : Icon(
                      Icons.person_rounded,
                      size: SizeConfig.width * 0.12,
                      color: AppColors.kPrimaryDark,
                    ),
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.doctor?.name ?? 'Doctor',
                  style: AppTextStyles.title18WhiteW500,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Text(
                  doctor.specialty.name,
                  style: AppTextStyles.title12White70,
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: Colors.white70,
                        size: SizeConfig.width * 0.04),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        doctor.hospital,
                        style: AppTextStyles.title12WhiteW500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== DETAILS CARD ===================== */

class _DoctorDetailsCard extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorDetailsCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            title: context.tr.email,
            value: doctor.doctor?.email ?? '—',
            icon: Icons.email_outlined,
          ),
          _Divider(),
          _InfoRow(
            title: context.tr.phone,
            value: doctor.doctor?.phone ?? '—',
            icon: Icons.phone_outlined,
          ),
          _Divider(),
          _InfoRow(
            title: context.tr.specialty,
            value: doctor.specialty.name,
            icon: Icons.medical_services_outlined,
          ),
          _Divider(),
          _InfoRow(
            title: context.tr.aboutDoctor,
            value: doctor.bio,
            icon: Icons.info_outline,
            isMultiline: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isMultiline;

  const _InfoRow({
    required this.title,
    required this.value,
    required this.icon,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.01),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon,
              color: AppColors.kPrimaryColor,
              size: SizeConfig.width * 0.055),
          SizedBox(width: SizeConfig.width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title12Grey),
                SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.title14Black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.shade300,
      height: SizeConfig.height * 0.015,
    );
  }
}

/* ===================== CONTACT ===================== */

class _ContactSection extends StatelessWidget {
  final DoctorModel doctor;

  const _ContactSection({required this.doctor});
  @override
  Widget build(BuildContext context) {
    final phone = doctor.doctor?.phone.trim();
    final canDial = phone != null && phone.isNotEmpty;

    return Row(
      children: [
        _ContactButton(
          icon: Icons.phone,
          label: context.tr.call,
          onTap: canDial
              ? () {
                  launchUrlSocialMedia(url: "tel:$phone");
                }
              : null,
        ),
        _ContactButton(
          icon: FontAwesomeIcons.whatsapp,
          label: context.tr.whatsApp,
          onTap: canDial
              ? () {
                  launchUrlSocialMedia(url: "https://wa.me/$phone");
                }
              : null,
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ContactButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width * 0.015),
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height * 0.015,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: AppColors.kPrimaryColor,
                  size: SizeConfig.width * 0.055),
              SizedBox(height: 6),
              Text(label, style: AppTextStyles.title12BlackColorW400),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  REVIEWS SECTION
// ═══════════════════════════════════════════════════

class _ReviewsSection extends StatefulWidget {
  final String doctorId;
  const _ReviewsSection({required this.doctorId});

  @override
  State<_ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<_ReviewsSection> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorReviewsCubit>().fetchReviews(widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
      builder: (context, state) {
        final cubit = context.read<DoctorReviewsCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Section header ────────────────────────────────
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.width * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.star_rounded,
                      color: Colors.amber,
                      size: SizeConfig.width * 0.05),
                ),
                SizedBox(width: SizeConfig.width * 0.025),
                Text(tr.patientReviews,
                    style: AppTextStyles.title18WhiteW500),
                const Spacer(),
                if (state is! DoctorReviewsLoading)
                  GestureDetector(
                    onTap: () => cubit.fetchReviews(widget.doctorId),
                    child: Container(
                      padding: EdgeInsets.all(SizeConfig.width * 0.018),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.refresh_rounded,
                          color: Colors.white70,
                          size: SizeConfig.width * 0.045),
                    ),
                  ),
              ],
            ),
            SizedBox(height: SizeConfig.height * 0.015),

            if (state is DoctorReviewsLoading)
              Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: SizeConfig.height * 0.04),
                  child: const CircularProgressIndicator(
                      color: Colors.amber, strokeWidth: 2.5),
                ),
              )
            else ...[
              // ─── Premium summary card ─────────────────────────
              _PremiumRatingSummary(cubit: cubit),
              SizedBox(height: SizeConfig.height * 0.015),

              // ─── Write / My review ────────────────────────────
              _MyReviewCard(doctorId: widget.doctorId, cubit: cubit),
              SizedBox(height: SizeConfig.height * 0.015),

              // ─── Other reviews ────────────────────────────────
              if (cubit.reviews
                  .where((r) =>
                      r.patientId != (cubit.myReview?.patientId ?? ''))
                  .isEmpty)
                _EmptyReviews()
              else
                ...cubit.reviews
                    .where((r) =>
                        r.patientId != (cubit.myReview?.patientId ?? ''))
                    .map((r) => _ReviewCard(review: r)),
            ],
          ],
        );
      },
    );
  }
}

// ─── Premium Rating Summary ───────────────────────

class _PremiumRatingSummary extends StatelessWidget {
  final DoctorReviewsCubit cubit;
  const _PremiumRatingSummary({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final avg = cubit.avgRating;
    final total = cubit.reviews.length;

    // Count per star
    final counts = List.generate(5, (i) {
      final star = 5 - i;
      return cubit.reviews.where((r) => r.rating == star).length;
    });

    return Container(
      padding: EdgeInsets.all(SizeConfig.width * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Big score ────────────────────────────────
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                avg == 0 ? '—' : avg.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: SizeConfig.width * 0.13,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  height: 1,
                ),
              ),
              SizedBox(height: SizeConfig.height * 0.006),
              _StarRow(
                  rating: avg.round(),
                  size: SizeConfig.width * 0.042,
                  activeColor: Colors.amber),
              SizedBox(height: SizeConfig.height * 0.005),
              Text(
                tr.basedOnReviews(total),
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),

          SizedBox(width: SizeConfig.width * 0.045),
          Container(
              width: 1,
              height: SizeConfig.height * 0.1,
              color: Colors.grey.shade200),
          SizedBox(width: SizeConfig.width * 0.04),

          // ── Rating bars ──────────────────────────────
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = counts[i];
                final fraction = total == 0 ? 0.0 : count / total;
                return _RatingBar(
                    star: star, fraction: fraction, count: count);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int star;
  final double fraction;
  final int count;

  const _RatingBar(
      {required this.star,
      required this.fraction,
      required this.count});

  @override
  Widget build(BuildContext context) {
    Color barColor;
    if (star >= 4) {
      barColor = Colors.green.shade400;
    } else if (star == 3) {
      barColor = Colors.amber.shade400;
    } else {
      barColor = Colors.red.shade300;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.003),
      child: Row(
        children: [
          Text('$star',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600)),
          SizedBox(width: SizeConfig.width * 0.01),
          Icon(Icons.star_rounded, size: 11, color: Colors.amber),
          SizedBox(width: SizeConfig.width * 0.015),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: SizeConfig.height * 0.007,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.015),
          SizedBox(
            width: SizeConfig.width * 0.06,
            child: Text('$count',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

// ─── My Review Card ──────────────────────────────

class _MyReviewCard extends StatelessWidget {
  final String doctorId;
  final DoctorReviewsCubit cubit;

  const _MyReviewCard({required this.doctorId, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final myReview = cubit.myReview;

    if (myReview != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.kPrimaryColor.withOpacity(0.08),
              AppColors.kPrimaryColor.withOpacity(0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.kPrimaryColor.withOpacity(0.2), width: 1.5),
        ),
        padding: EdgeInsets.all(SizeConfig.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 0.025,
                      vertical: SizeConfig.height * 0.004),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded,
                          color: Colors.white,
                          size: SizeConfig.width * 0.035),
                      SizedBox(width: 4),
                      Text(tr.yourReview,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const Spacer(),
                _ActionIconBtn(
                  icon: Icons.edit_rounded,
                  color: AppColors.kPrimaryColor,
                  onTap: () => _showSheet(context, existing: myReview),
                ),
                SizedBox(width: SizeConfig.width * 0.015),
                _ActionIconBtn(
                  icon: Icons.delete_rounded,
                  color: Colors.red,
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.height * 0.012),
            _StarRow(
                rating: myReview.rating,
                size: SizeConfig.width * 0.048,
                activeColor: Colors.amber),
            if (myReview.reviewText?.isNotEmpty == true) ...[
              SizedBox(height: SizeConfig.height * 0.01),
              Text(
                '"${myReview.reviewText}"',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // No review yet — premium CTA button
    return _WriteReviewButton(onTap: () => _showSheet(context));
  }

  void _showSheet(BuildContext context, {DoctorReviewModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ReviewInputSheet(doctorId: doctorId, existing: existing),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final tr = context.tr;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(tr.deleteReview, style: AppTextStyles.title18BlackW500),
        content: Text(tr.confirmDeleteReview),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr.cancel,
                  style: TextStyle(color: AppColors.kPrimaryColor))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteReview(doctorId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(tr.delete),
          ),
        ],
      ),
    );
  }
}

// ─── Premium Write Review Button ─────────────────

class _WriteReviewButton extends StatefulWidget {
  final VoidCallback onTap;
  const _WriteReviewButton({required this.onTap});

  @override
  State<_WriteReviewButton> createState() => _WriteReviewButtonState();
}

class _WriteReviewButtonState extends State<_WriteReviewButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFC107), Color(0xFFFF8F00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.45),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Decorative circles ──────────────────
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  width: SizeConfig.width * 0.22,
                  height: SizeConfig.width * 0.22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                right: SizeConfig.width * 0.1,
                bottom: -14,
                child: Container(
                  width: SizeConfig.width * 0.14,
                  height: SizeConfig.width * 0.14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),

              // ── Content ─────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.05,
                  vertical: SizeConfig.height * 0.022,
                ),
                child: Row(
                  children: [
                    // Stars stack
                    SizedBox(
                      width: SizeConfig.width * 0.22,
                      height: SizeConfig.width * 0.1,
                      child: Stack(
                        children: List.generate(5, (i) {
                          return Positioned(
                            left: i * SizeConfig.width * 0.038,
                            child: Icon(
                              Icons.star_rounded,
                              color: i == 4
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6 + i * 0.08),
                              size: SizeConfig.width * 0.052,
                              shadows: [
                                Shadow(
                                  color: Colors.orange.shade900
                                      .withOpacity(0.4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(width: SizeConfig.width * 0.03),

                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr.writeReview,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: SizeConfig.height * 0.003),
                          Text(
                            tr.rateYourExperience,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow button
                    Container(
                      padding: EdgeInsets.all(SizeConfig.width * 0.025),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: SizeConfig.width * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Action icon button ──────────────────────────

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIconBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.width * 0.018),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: SizeConfig.width * 0.042),
      ),
    );
  }
}

// ─── Review Input Sheet ──────────────────────────

class _ReviewInputSheet extends StatefulWidget {
  final String doctorId;
  final DoctorReviewModel? existing;

  const _ReviewInputSheet({required this.doctorId, this.existing});

  @override
  State<_ReviewInputSheet> createState() => _ReviewInputSheetState();
}

class _ReviewInputSheetState extends State<_ReviewInputSheet> {
  int _selectedRating = 0;
  late TextEditingController _controller;

  static const _labels = ['Terrible', 'Bad', 'Okay', 'Good', 'Excellent'];

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.existing?.rating ?? 0;
    _controller =
        TextEditingController(text: widget.existing?.reviewText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final cubit = context.read<DoctorReviewsCubit>();
    final isEdit = widget.existing != null;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
          SizeConfig.width * 0.05,
          SizeConfig.height * 0.015,
          SizeConfig.width * 0.05,
          SizeConfig.height * 0.02,
        ),
        child: BlocConsumer<DoctorReviewsCubit, DoctorReviewsState>(
          listener: (context, state) {
            if (state is DoctorReviewSubmitSuccess) Navigator.pop(context);
          },
          builder: (context, state) {
            final isLoading = state is DoctorReviewSubmitting;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),

                // Title
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(SizeConfig.width * 0.025),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 22),
                    ),
                    SizedBox(width: SizeConfig.width * 0.03),
                    Text(
                      isEdit ? tr.editReview : tr.writeReview,
                      style: AppTextStyles.title18BlackW500,
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.height * 0.025),

                // Stars + label
                Text(tr.rateYourExperience,
                    style: AppTextStyles.title14Grey),
                SizedBox(height: SizeConfig.height * 0.012),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final star = i + 1;
                    final isActive = star <= _selectedRating;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedRating = star),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.width * 0.015),
                        child: Icon(
                          isActive
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: isActive
                              ? Colors.amber
                              : Colors.grey.shade300,
                          size: isActive
                              ? SizeConfig.width * 0.115
                              : SizeConfig.width * 0.1,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: SizeConfig.height * 0.008),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _selectedRating > 0
                      ? Text(
                          _labels[_selectedRating - 1],
                          key: ValueKey(_selectedRating),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedRating >= 4
                                ? Colors.green
                                : _selectedRating == 3
                                    ? Colors.amber.shade700
                                    : Colors.red,
                          ),
                        )
                      : Text(tr.selectRating,
                          key: const ValueKey(0),
                          style: AppTextStyles.title12Grey),
                ),
                SizedBox(height: SizeConfig.height * 0.02),

                // Review text
                TextFormField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: tr.writeYourReview,
                    hintStyle: AppTextStyles.title14Grey,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                          left: 12,
                          right: 8,
                          top: SizeConfig.height * 0.012),
                      child: Icon(Icons.comment_outlined,
                          color: Colors.grey.shade400, size: 20),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: AppColors.kPrimaryColor, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.all(SizeConfig.width * 0.035),
                  ),
                ),
                SizedBox(height: SizeConfig.height * 0.02),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedRating == 0 || isLoading)
                        ? null
                        : () => cubit.submitReview(
                              doctorId: widget.doctorId,
                              rating: _selectedRating,
                              reviewText: _controller.text,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          Colors.grey.shade300,
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.height * 0.018),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send_rounded,
                                  color: Colors.white, size: 18),
                              SizedBox(width: SizeConfig.width * 0.02),
                              Text(tr.submitReview,
                                  style: AppTextStyles.title16WhiteBold),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Star Row (display only) ─────────────────────

class _StarRow extends StatelessWidget {
  final int rating;
  final double size;
  final Color activeColor;

  const _StarRow(
      {required this.rating,
      this.size = 18,
      this.activeColor = Colors.amber});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < rating ? activeColor : Colors.grey.shade300,
          size: size,
        );
      }),
    );
  }
}

// ─── Individual Review Card ──────────────────────

class _ReviewCard extends StatelessWidget {
  final DoctorReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final hasImage = review.reviewerImage?.isNotEmpty == true;
    final name = review.reviewerName ?? 'Patient';

    // Color accent by rating
    final Color accent = review.rating >= 4
        ? Colors.green.shade400
        : review.rating == 3
            ? Colors.amber.shade600
            : Colors.red.shade400;

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.012),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Colored top accent bar ───────────────────
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: accent.withOpacity(0.4), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: SizeConfig.width * 0.048,
                        backgroundImage: hasImage
                            ? NetworkImage(review.reviewerImage!)
                            : null,
                        backgroundColor:
                            AppColors.kPrimaryColor.withOpacity(0.1),
                        child: hasImage
                            ? null
                            : Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : 'P',
                                style: TextStyle(
                                    color: AppColors.kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.width * 0.042),
                              ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.width * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          SizedBox(height: SizeConfig.height * 0.003),
                          _StarRow(
                              rating: review.rating,
                              size: SizeConfig.width * 0.04,
                              activeColor: Colors.amber),
                        ],
                      ),
                    ),
                    // Date chip
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width * 0.022,
                          vertical: SizeConfig.height * 0.004),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatDate(review.createdAt),
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                if (review.reviewText?.isNotEmpty == true) ...[
                  SizedBox(height: SizeConfig.height * 0.012),
                  Container(
                    padding: EdgeInsets.all(SizeConfig.width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote_rounded,
                            color: accent.withOpacity(0.5),
                            size: SizeConfig.width * 0.045),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            review.reviewText!,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

// ─── Empty Reviews ───────────────────────────────

class _EmptyReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.01),
      padding: EdgeInsets.all(SizeConfig.width * 0.06),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.rate_review_outlined,
              color: Colors.white54, size: SizeConfig.width * 0.12),
          SizedBox(height: SizeConfig.height * 0.012),
          Text(tr.noReviewsYet,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text(tr.beFirstToReview,
              style: AppTextStyles.title12White70,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
