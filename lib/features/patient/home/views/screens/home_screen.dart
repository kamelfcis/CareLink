import 'package:care_link/core/app_route/route_names.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/views/widgets/custom_failure_message.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:care_link/features/patient/home/view_models/cubit/doctors_cubit.dart';
import 'package:care_link/features/patient/home/views/widgets/animated_medical_background.dart';
import 'package:care_link/features/patient/home/views/widgets/custom_loading_indicator.dart';
import 'package:care_link/features/patient/home/views/widgets/doctor_card.dart';
import 'package:care_link/features/patient/home/views/widgets/gradient_header.dart';
import 'package:care_link/features/patient/settings/views/screens/settings_screen.dart';
import 'package:care_link/features/patient/shared/widgets/patient_identity_qr.dart';
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
  const PatientHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final patientModel = getIt<CacheHelper>().getPatientModel()!;
    final userModel = patientModel.patient;
    final tr = context.tr;

    return GradientHeader(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.04,
          vertical: SizeConfig.height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Top row: avatar + greeting + settings ───
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userModel!.image),
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
                        builder: (context) => SettingsScreen()),
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

            // ─── Headline ───
            Text(tr.findYourDesired, style: AppTextStyles.title14White),
            Text(tr.doctorsNearYou, style: AppTextStyles.title22WhiteColorBold),
            SizedBox(height: SizeConfig.height * 0.014),

            // ─── QR Card ───
            PatientIdentityQrCard(
              patientId: patientModel.id,
              patientName: userModel.name,
              compact: true,
            ),
            SizedBox(height: SizeConfig.height * 0.016),

            // ─── Premium Search + Filter ───
            _SearchAndFilterBar(),
            SizedBox(height: SizeConfig.height * 0.01),

            // ─── Active filter chips ───
            _ActiveFilterChips(),
            SizedBox(height: SizeConfig.height * 0.01),

            // ─── Doctors list ───
            DoctorsListView(),
          ],
        ),
      ),
    );
  }
}

/* ══════════════════════════════════════════════
   PREMIUM SEARCH + FILTER BAR
══════════════════════════════════════════════ */

class _SearchAndFilterBar extends StatelessWidget {
  const _SearchAndFilterBar();

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Row(
      children: [
        // ─── Search field ───
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (q) =>
                  context.read<DoctorsCubit>().searchDoctors(q),
              style: AppTextStyles.title14Black,
              decoration: InputDecoration(
                hintText: tr.searchByNameOrSpecialty,
                hintStyle: AppTextStyles.title14Grey,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.kPrimaryColor,
                  size: SizeConfig.width * 0.06,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: SizeConfig.height * 0.016,
                  horizontal: SizeConfig.width * 0.02,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.025),

        // ─── Filter button ───
        BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            final cubit = context.read<DoctorsCubit>();
            final count = cubit.activeFilterCount;
            final hasFilters = count > 0;

            return GestureDetector(
              onTap: () => _showFilterBottomSheet(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.038,
                  vertical: SizeConfig.height * 0.016,
                ),
                decoration: BoxDecoration(
                  color: hasFilters ? AppColors.kPrimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      color: hasFilters
                          ? Colors.white
                          : AppColors.kPrimaryColor,
                      size: SizeConfig.width * 0.055,
                    ),
                    if (hasFilters) ...[
                      SizedBox(width: SizeConfig.width * 0.015),
                      Container(
                        width: SizeConfig.width * 0.055,
                        height: SizeConfig.width * 0.055,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: AppColors.kPrimaryColor,
                            fontSize: SizeConfig.width * 0.032,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final cubit = context.read<DoctorsCubit>();

    String? tempSpecialty = cubit.selectedSpecialty;
    String? tempGovernorate = cubit.selectedGovernorate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (_, setModal) {
            return _FilterBottomSheet(
              cubit: cubit,
              tempSpecialty: tempSpecialty,
              tempGovernorate: tempGovernorate,
              onSpecialtyChanged: (v) => setModal(() => tempSpecialty = v),
              onGovernorateChanged: (v) =>
                  setModal(() => tempGovernorate = v),
              onApply: () {
                cubit.filterBySpecialty(tempSpecialty);
                cubit.filterByGovernorate(tempGovernorate);
                Navigator.pop(sheetCtx);
              },
              onClearAll: () {
                setModal(() {
                  tempSpecialty = null;
                  tempGovernorate = null;
                });
              },
            );
          },
        );
      },
    );
  }
}

/* ══════════════════════════════════════════════
   ACTIVE FILTER CHIPS
══════════════════════════════════════════════ */

class _ActiveFilterChips extends StatelessWidget {
  const _ActiveFilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorsCubit, DoctorsState>(
      builder: (context, state) {
        final cubit = context.read<DoctorsCubit>();
        final specialty = cubit.selectedSpecialty;
        final governorate = cubit.selectedGovernorate;

        if (specialty == null && governorate == null) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (specialty != null)
                _FilterChip(
                  icon: Icons.medical_services_outlined,
                  label: specialty,
                  onRemove: () =>
                      cubit.filterBySpecialty(null),
                ),
              if (specialty != null && governorate != null)
                SizedBox(width: SizeConfig.width * 0.02),
              if (governorate != null)
                _FilterChip(
                  icon: Icons.location_on_outlined,
                  label: governorate,
                  onRemove: () =>
                      cubit.filterByGovernorate(null),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.03,
        vertical: SizeConfig.height * 0.006,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.kPrimaryColor),
          SizedBox(width: SizeConfig.width * 0.015),
          Text(
            label,
            style: TextStyle(
              color: AppColors.kPrimaryColor,
              fontSize: SizeConfig.width * 0.033,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.015),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/* ══════════════════════════════════════════════
   PREMIUM FILTER BOTTOM SHEET
══════════════════════════════════════════════ */

class _FilterBottomSheet extends StatelessWidget {
  final DoctorsCubit cubit;
  final String? tempSpecialty;
  final String? tempGovernorate;
  final ValueChanged<String?> onSpecialtyChanged;
  final ValueChanged<String?> onGovernorateChanged;
  final VoidCallback onApply;
  final VoidCallback onClearAll;

  const _FilterBottomSheet({
    required this.cubit,
    required this.tempSpecialty,
    required this.tempGovernorate,
    required this.onSpecialtyChanged,
    required this.onGovernorateChanged,
    required this.onApply,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final hasAnyFilter = tempSpecialty != null || tempGovernorate != null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Handle ───
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ─── Header ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width * 0.05,
                vertical: SizeConfig.height * 0.018,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tune_rounded,
                          color: AppColors.kPrimaryColor,
                          size: SizeConfig.width * 0.06),
                      SizedBox(width: SizeConfig.width * 0.02),
                      Text(
                        tr.filters,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  if (hasAnyFilter)
                    GestureDetector(
                      onTap: onClearAll,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width * 0.03,
                          vertical: SizeConfig.height * 0.006,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tr.clearFilter,
                          style: TextStyle(
                            color: AppColors.kPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ─── Tab bar ───
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.04),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade600,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.medical_services_outlined,
                              size: 16),
                          const SizedBox(width: 6),
                          Text(tr.specialty),
                          if (tempSpecialty != null) ...[
                            const SizedBox(width: 4),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16),
                          const SizedBox(width: 6),
                          Text(tr.location),
                          if (tempGovernorate != null) ...[
                            const SizedBox(width: 4),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
                height: SizeConfig.height * 0.025,
                color: Colors.grey.shade100),

            // ─── Tab views ───
            Flexible(
              child: TabBarView(
                children: [
                  // Tab 1: Specialty
                  _SpecialtyTab(
                    specialties: cubit.specialties,
                    doctors: cubit.doctors,
                    selected: tempSpecialty,
                    onSelect: onSpecialtyChanged,
                  ),
                  // Tab 2: Location
                  _LocationTab(
                    governorates: cubit.governorates,
                    selected: tempGovernorate,
                    onSelect: onGovernorateChanged,
                  ),
                ],
              ),
            ),

            // ─── Apply button ───
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
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.height * 0.018),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    tr.apply,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecialtyTab extends StatelessWidget {
  final List<String> specialties;
  final List<DoctorModel> doctors;
  final String? selected;
  final ValueChanged<String?> onSelect;

  const _SpecialtyTab({
    required this.specialties,
    required this.doctors,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    if (specialties.isEmpty) {
      return Center(
          child: Text(tr.noResultsFound,
              style: AppTextStyles.title14Grey));
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.04,
        vertical: SizeConfig.height * 0.005,
      ),
      itemCount: specialties.length,
      itemBuilder: (context, index) {
        final s = specialties[index];
        final isSelected = selected == s;
        final doc = doctors.firstWhere(
          (d) => d.specialty.name == s,
          orElse: () => doctors.first,
        );
        final icon = doc.specialty.icon ?? '';

        return GestureDetector(
          onTap: () => onSelect(isSelected ? null : s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: EdgeInsets.only(bottom: SizeConfig.height * 0.009),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.016,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.kPrimaryColor.withOpacity(0.08)
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
                  Text(icon, style: const TextStyle(fontSize: 22)),
                  SizedBox(width: SizeConfig.width * 0.03),
                ],
                Expanded(
                  child: Text(
                    s,
                    style: TextStyle(
                      fontSize: 15,
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
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.kPrimaryColor, size: 22),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LocationTab extends StatelessWidget {
  final List<String> governorates;
  final String? selected;
  final ValueChanged<String?> onSelect;

  const _LocationTab({
    required this.governorates,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    if (governorates.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off_outlined,
                  size: SizeConfig.width * 0.14,
                  color: Colors.grey.shade400),
              SizedBox(height: SizeConfig.height * 0.02),
              Text(
                tr.allLocations,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600),
              ),
              SizedBox(height: SizeConfig.height * 0.008),
              Text(
                'No location data available for doctors yet.',
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.04,
        vertical: SizeConfig.height * 0.005,
      ),
      itemCount: governorates.length,
      itemBuilder: (context, index) {
        final g = governorates[index];
        final isSelected = selected == g;

        return GestureDetector(
          onTap: () => onSelect(isSelected ? null : g),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: EdgeInsets.only(bottom: SizeConfig.height * 0.009),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.016,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.kPrimaryColor.withOpacity(0.08)
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
                Container(
                  width: SizeConfig.width * 0.09,
                  height: SizeConfig.width * 0.09,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.kPrimaryColor.withOpacity(0.15)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_city_rounded,
                    color: isSelected
                        ? AppColors.kPrimaryColor
                        : Colors.grey.shade500,
                    size: SizeConfig.width * 0.045,
                  ),
                ),
                SizedBox(width: SizeConfig.width * 0.03),
                Expanded(
                  child: Text(
                    g,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.kPrimaryColor
                          : Colors.black87,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.kPrimaryColor, size: 22),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ══════════════════════════════════════════════
   DOCTORS LIST VIEW
══════════════════════════════════════════════ */

class DoctorsListView extends StatelessWidget {
  const DoctorsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<DoctorsCubit, DoctorsState>(
        builder: (context, state) {
          if (state is GetDoctorsLoading) {
            return const CustomLoadingIndicator();
          }
          if (state is GetDoctorsFailure) {
            return CustomFailureMesage(errorMessage: state.errorMessage);
          }

          final cubit = context.read<DoctorsCubit>();
          final doctors = cubit.filteredDoctors;

          if (doctors.isEmpty && cubit.doctors.isNotEmpty) {
            return _EmptyFilterResult();
          }

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => context.pushScreen(
                  RouteNames.doctorDetailsScreen,
                  arguments: doctors[index].toJson(),
                ),
                child: DoctorCard(doctor: doctors[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyFilterResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: SizeConfig.width * 0.18,
                color: Colors.grey.shade400),
            SizedBox(height: SizeConfig.height * 0.02),
            Text(
              tr.noResultsFound,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            SizedBox(height: SizeConfig.height * 0.008),
            Text(
              tr.tryDifferentSearch,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.height * 0.025),
            ElevatedButton.icon(
              onPressed: () => context.read<DoctorsCubit>().clearFilters(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(tr.clearFilter),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ══════════════════════════════════════════════
   CHATBOT FAB
══════════════════════════════════════════════ */

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
      builder: (context, child) =>
          Transform.scale(scale: _pulseAnimation.value, child: child),
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
          onPressed: () =>
              Navigator.pushNamed(context, RouteNames.chatBotScreen),
          child: Icon(Icons.auto_awesome,
              size: SizeConfig.width * 0.065, color: Colors.white),
        ),
      ),
    );
  }
}
