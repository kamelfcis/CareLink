import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/components/custom_text_form_field.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/views/widgets/custom_failure_message.dart';
import 'package:care_link/features/patient/home/view_models/cubit/doctors_cubit.dart';
import 'package:care_link/features/patient/home/views/widgets/custom_loading_indicator.dart';
import 'package:care_link/features/patient/home/views/widgets/doctor_card.dart';
import 'package:care_link/features/patient/home/views/widgets/animated_medical_background.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:care_link/features/patient/settings/views/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedMedicalBackground(
        child: PatientHomeScreenBody(),
      ),
      floatingActionButton: _ChatBotFab(),
    );
  }
}

class PatientHomeScreenBody extends StatelessWidget {
  const PatientHomeScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userModel = getIt<CacheHelper>().getPatientModel()!.patient;
    final tr = context.tr;
    return GradientHeader(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.03,
          vertical: SizeConfig.height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    userModel!.image,
                  ),
                  radius: SizeConfig.width * 0.065,
                ),
                SizedBox(width: SizeConfig.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tr.helloUser(userModel.name),
                        style: AppTextStyles.title18WhiteW500,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(tr.bookDoctorToday,
                          style: AppTextStyles.title12White70),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  ),
                  child: Badge(
                    backgroundColor: Colors.red,
                    smallSize: SizeConfig.width * 0.025,
                    child: Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: SizeConfig.width * 0.065,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.height * 0.012),
            Text(
              tr.findYourDesired,
              style: AppTextStyles.title14White,
            ),
            Text(
              tr.doctorsNearYou,
              style: AppTextStyles.title22WhiteColorBold,
            ),
            SizedBox(height: SizeConfig.height * 0.012),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hintText: tr.searchForDoctor,
                    prefixIcon: Icons.search,
                    onChanged: (query) {
                      context.read<DoctorsCubit>().searchDoctors(query);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.width * 0.02),
                GestureDetector(
                  onTap: () => _showFilterBottomSheet(context),
                  child: BlocBuilder<DoctorsCubit, DoctorsState>(
                    builder: (context, state) {
                      final hasFilter =
                          context.read<DoctorsCubit>().selectedSpecialty !=
                              null;
                      return Container(
                        padding: EdgeInsets.all(SizeConfig.width * 0.03),
                        decoration: BoxDecoration(
                          color: hasFilter
                              ? Colors.white
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color: hasFilter
                              ? AppColors.kPrimaryColor
                              : Colors.white,
                          size: SizeConfig.width * 0.06,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.height * 0.015),
            DoctorsListView()
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final cubit = context.read<DoctorsCubit>();
    final tr = context.tr;
    String? tempSelectedSpecialty = cubit.selectedSpecialty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (builderContext, setModalState) {
            final specialties = cubit.specialties;
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Title row
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width * 0.05,
                      vertical: SizeConfig.height * 0.018,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr.filterBySpecialty,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        if (tempSelectedSpecialty != null)
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempSelectedSpecialty = null;
                              });
                            },
                            child: Text(
                              tr.clearFilter,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.kPrimaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  // Specialty list
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width * 0.03,
                        vertical: SizeConfig.height * 0.01,
                      ),
                      itemCount: specialties.length,
                      itemBuilder: (context, index) {
                        final specialty = specialties[index];
                        final isSelected =
                            tempSelectedSpecialty == specialty;
                        // Find the icon for this specialty
                        final doc = cubit.doctors.firstWhere(
                          (d) => d.specialty.name == specialty,
                        );
                        final icon = doc.specialty.icon ?? '';

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                tempSelectedSpecialty = null;
                              } else {
                                tempSelectedSpecialty = specialty;
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.symmetric(
                              vertical: SizeConfig.height * 0.005,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width * 0.04,
                              vertical: SizeConfig.height * 0.016,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.kPrimaryColor.withOpacity(0.1)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.kPrimaryColor
                                    : Colors.grey.shade200,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                if (icon.isNotEmpty) ...[
                                  Text(
                                    icon,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  SizedBox(width: SizeConfig.width * 0.03),
                                ],
                                Expanded(
                                  child: Text(
                                    specialty,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? AppColors.kPrimaryColor
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.kPrimaryColor,
                                    size: 22,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Apply button
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      SizeConfig.width * 0.05,
                      SizeConfig.height * 0.01,
                      SizeConfig.width * 0.05,
                      SizeConfig.height * 0.03,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          cubit.filterBySpecialty(tempSelectedSpecialty);
                          Navigator.pop(bottomSheetContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.height * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          tr.apply,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class DoctorsListView extends StatelessWidget {
  const DoctorsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<DoctorsCubit, DoctorsState>(
        builder: (context, state) {
          if (state is GetDoctorsLoading) {
            return CustomLoadingIndicator();
          }
          if (state is GetDoctorsFailure) {
            return CustomFailureMesage(errorMessage: state.errorMessage);
          }
          var doctorsCubit = context.read<DoctorsCubit>();
          final doctors = doctorsCubit.filteredDoctors;

          if (doctors.isEmpty && doctorsCubit.doctors.isNotEmpty) {
            return _buildEmptyFilterResult(context);
          }

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.pushScreen(RouteNames.doctorDetailsScreen,
                      arguments: doctors[index].toJson());
                },
                child: DoctorCard(
                  doctor: doctors[index],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyFilterResult(BuildContext context) {
    final tr = context.tr;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: SizeConfig.width * 0.15,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: SizeConfig.height * 0.02),
            Text(
              tr.noResultsFound,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: SizeConfig.height * 0.008),
            Text(
              tr.tryDifferentSearch,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.height * 0.025),
            TextButton.icon(
              onPressed: () {
                context.read<DoctorsCubit>().clearFilters();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(tr.clearFilter),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBotFab extends StatefulWidget {
  @override
  State<_ChatBotFab> createState() => _ChatBotFabState();
}

class _ChatBotFabState extends State<_ChatBotFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: AppColors.kPrimaryColor,
          elevation: 0,
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.chatBotScreen);
          },
          child: Icon(
            Icons.auto_awesome,
            size: SizeConfig.width * 0.065,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
