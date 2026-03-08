import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/features/patient/chronic_conditions/models/chronic_condition_model.dart';
import 'package:care_link/features/patient/chronic_conditions/view_models/cubit/chronic_conditions_cubit.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/network/supabase/database/get_data_with_spacific_id.dart';
import 'package:care_link/features/patient/chronic_conditions/models/chronic_condition_model.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChronicConditionsCubit extends Cubit<ChronicConditionsState> {
  ChronicConditionsCubit({required this.patientId})
      : super(ChronicConditionsInitial()) {
    getChronicConditions();
  }

  final String patientId;

  // -->> variables
  List<ChronicConditionModel> chronicConditions = [];
  final supabase = getIt<SupabaseClient>();

  // -->> functions
  getChronicConditions() async {
    try {
      emit(GetChronicConditionsLoading());
      final response = await getDataWithSpacificId(
        tableName: "chronic_conditions",
        id: patientId,
        primaryKey: "patient_id",
      );
      log(response.toString());
      chronicConditions = (response as List)
          .map<ChronicConditionModel>((e) => ChronicConditionModel.fromMap(e))
          .toList();
      emit(GetChronicConditionsSuccess());
    } catch (e) {
      log('Error fetching conditions: $e');
      emit(GetChronicConditionsError(errorMessage: e.toString()));
    }
  }

  // Add new condition
  addChronicCondition({required String name, String? notes}) async {
    try {
      emit(AddChronicConditionLoading());
      final response = await supabase.from("chronic_conditions").insert({
        "patient_id": patientId,
        "name": name,
        "notes": notes,
        "created_at": DateTime.now().toIso8601String()
      }).select();
      log('Insert response: $response');
      await getChronicConditions();
      emit(AddChronicConditionSuccess());
    } catch (e) {
      log('Error adding condition: $e');
      emit(AddChronicConditionError(errorMessage: e.toString()));
    }
  }

  // Delete condition
  deleteChronicCondition({required String id}) async {
    try {
      emit(DeleteChronicConditionLoading());
      await supabase.from("chronic_conditions").delete().eq("id", id);
      await getChronicConditions();
      emit(DeleteChronicConditionSuccess());
    } catch (e) {
      log('Error deleting condition: $e');
      emit(DeleteChronicConditionError(errorMessage: e.toString()));
    }
  }
}

sealed class ChronicConditionsState {}

final class ChronicConditionsInitial extends ChronicConditionsState {}

final class GetChronicConditionsSuccess extends ChronicConditionsState {}

final class GetChronicConditionsLoading extends ChronicConditionsState {}

final class GetChronicConditionsError extends ChronicConditionsState {
  final String errorMessage;
  GetChronicConditionsError({required this.errorMessage});
}

final class AddChronicConditionSuccess extends ChronicConditionsState {}

final class AddChronicConditionLoading extends ChronicConditionsState {}

final class AddChronicConditionError extends ChronicConditionsState {
  final String errorMessage;
  AddChronicConditionError({required this.errorMessage});
}

final class DeleteChronicConditionSuccess extends ChronicConditionsState {}

final class DeleteChronicConditionLoading extends ChronicConditionsState {}

final class DeleteChronicConditionError extends ChronicConditionsState {
  final String errorMessage;
  DeleteChronicConditionError({required this.errorMessage});
}

class ChronicConditionsScreen extends StatelessWidget {
  const ChronicConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    log(args.toString());
    return ChronicConditionsView(
      patientId: args!,
    );
  }
}

class ChronicConditionsView extends StatefulWidget {
  const ChronicConditionsView({required this.patientId});

  final String patientId;

  @override
  State<ChronicConditionsView> createState() => _ChronicConditionsViewState();
}

class _ChronicConditionsViewState extends State<ChronicConditionsView> {
  late final ChronicConditionsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChronicConditionsCubit(patientId: widget.patientId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04;
    final spacing = screenHeight * 0.015;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider.value(
        value: _cubit,
        child: SafeArea(
          child: BlocListener<ChronicConditionsCubit, ChronicConditionsState>(
            listener: (context, state) {
              if (state is AddChronicConditionSuccess) {
                context.popScreen();
                CustomQuickAlert.success(
                  title: context.tr.success,
                  message: context.tr.conditionAddedSuccess,
                );
              }
              if (state is AddChronicConditionError) {
                CustomQuickAlert.error(
                  title: context.tr.error,
                  message: state.errorMessage,
                );
              }
              if (state is DeleteChronicConditionSuccess) {
                CustomQuickAlert.success(
                  title: context.tr.success,
                  message: context.tr.conditionDeletedSuccess,
                );
              }
              if (state is DeleteChronicConditionError) {
                CustomQuickAlert.error(
                  title: context.tr.error,
                  message: state.errorMessage,
                );
              }
            },
            child: BlocBuilder<ChronicConditionsCubit, ChronicConditionsState>(
              builder: (context, state) {
                if (state is GetChronicConditionsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimaryColor,
                    ),
                  );
                }
                if (state is GetChronicConditionsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        SizedBox(height: spacing * 2),
                        Text(
                          context.tr.errorPrefix(state.errorMessage),
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: spacing * 2),
                        ElevatedButton(
                          onPressed: () => context
                              .read<ChronicConditionsCubit>()
                              .getChronicConditions(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            context.tr.retry,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // In Success or Initial, read data from Cubit
                final cubit = context.read<ChronicConditionsCubit>();
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.zero,
                      sliver: SliverToBoxAdapter(
                        child: _buildHeader(spacing, padding),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      sliver: SliverFillRemaining(
                        child: BlocBuilder<ChronicConditionsCubit,
                            ChronicConditionsState>(
                          builder: (context, state) {
                            if (state is DeleteChronicConditionLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              );
                            }
                            final conditions = cubit.chronicConditions;
                            return ConditionsListWidget(
                              conditions: conditions,
                              cubit: cubit,
                              spacing: spacing,
                              padding: padding * 0.8,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      // Floating Action Button for adding instead of top card
      floatingActionButton: getIt<CacheHelper>().getDoctorModel() == null
          ? BlocBuilder(
        bloc: _cubit,
        builder: (context, state) {
          final isLoading = state is AddChronicConditionLoading;
          return FloatingActionButton.extended(
            onPressed: isLoading
                ? null
                : () => _showAddConditionBottomSheet(context, _cubit),
            backgroundColor: AppColors.kPrimaryColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
            label: Text(
              isLoading ? context.tr.adding : context.tr.addCondition,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ): SizedBox.shrink(),
    );
  }

  Widget _buildHeader(double spacing, double padding) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: spacing * 3),
      padding: EdgeInsets.all(padding * 1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kPrimaryColor.withOpacity(0.8),
            AppColors.kPrimaryLight,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border.all(
          color: AppColors.kPrimaryColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.kPrimaryColor,
                  AppColors.kPrimaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.kPrimaryColor.withOpacity(0.4),
              ),
            ),
            child: Icon(
              Icons.monitor_heart_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(width: spacing * 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.chronicConditions,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kPrimaryColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                Text(
                  context.tr.manageYourOngoingHealthConditions,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.kPrimaryColor.withOpacity(0.8),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to show Bottom Sheet for adding - Improved version
  void _showAddConditionBottomSheet(
    BuildContext context,
    ChronicConditionsCubit cubit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) =>
          BlocConsumer<ChronicConditionsCubit, ChronicConditionsState>(
        bloc: cubit,
        listener: (context, state) {
          // Removed listener handling here as it's now global in BlocListener
        },
        builder: (context, state) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          snap: true,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Enhanced handle with better styling
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(top: 16, bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Improved header with title and close button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.kPrimaryColor,
                                        AppColors.kPrimaryDark,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  context.tr.addNewCondition,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.tr.fillConditionDetails,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AddConditionContent(
                    cubit: cubit,
                    scrollController: scrollController,
                    isLoading: state is AddChronicConditionLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Add condition content (enhanced with better spacing and validation)
class AddConditionContent extends StatefulWidget {
  final ChronicConditionsCubit cubit;
  final ScrollController scrollController;
  final bool isLoading;

  const AddConditionContent({
    super.key,
    required this.cubit,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  State<AddConditionContent> createState() => _AddConditionContentState();
}

class _AddConditionContentState extends State<AddConditionContent> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isNameValid = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final spacing = screenHeight * 0.015;

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.05),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: spacing * 2),
            // Enhanced text fields with better styling and validation
            _buildEnhancedTextField(
              controller: _nameController,
              label: context.tr.conditionName,
              maxLines: 1,
              icon: Icons.text_fields,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr.pleaseEnterConditionName;
                }
                return null;
              },
            ),
            SizedBox(height: spacing * 0.5),
            _buildEnhancedTextField(
              controller: _notesController,
              label: context.tr.notesOptional,
              maxLines: 4,
              icon: Icons.note_alt_outlined,
              validator: null,
            ),
            SizedBox(height: spacing * 1),
            // Improved button with better feedback
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.07,
              child: widget.isLoading
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.kPrimaryColor,
                            AppColors.kPrimaryDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.cubit.addChronicCondition(
                            name: _nameController.text.trim(),
                            notes: _notesController.text.trim().isEmpty
                                ? null
                                : _notesController.text.trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        context.tr.addCondition,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: spacing * 4),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required int maxLines,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    final isNameField = label == context.tr.conditionName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          enabled: !widget.isLoading,
          validator: validator,
          autovalidateMode:
              isNameField ? AutovalidateMode.onUserInteraction : null,
          decoration: InputDecoration(
            prefixIcon: Container(
              padding: const EdgeInsets.all(16),
              child: Icon(
                icon,
                color: AppColors.kPrimaryColor,
                size: 24,
              ),
            ),
            labelText: label,
            labelStyle: TextStyle(
              color: AppColors.kPrimaryColor.withOpacity(0.7),
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.kPrimaryColor.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.kPrimaryColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.kPrimaryColor.withOpacity(0.3),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
          ),
        ),
        if (isNameField && !_isNameValid) ...[
          SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                context.tr.pleaseEnterConditionName,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// List widget (Stateless, uses cubit.deleteChronicCondition)
class ConditionsListWidget extends StatelessWidget {
  final List<ChronicConditionModel> conditions;
  final ChronicConditionsCubit cubit;
  final double spacing;
  final double padding;

  const ConditionsListWidget({
    super.key,
    required this.conditions,
    required this.cubit,
    required this.spacing,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (conditions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kPrimaryColor),
              ),
              child: Icon(
                Icons.medical_services_outlined,
                size: screenWidth * 0.18,
                color: AppColors.kPrimaryColor,
              ),
            ),
            SizedBox(height: spacing * 2),
            Text(
              context.tr.noConditionsYet,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kPrimaryColor,
                height: 1.2,
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Text(
              context.tr.addFirstCondition,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(
        bottom: spacing * 7,
        top: spacing,
      ),
      itemCount: conditions.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final condition = conditions[index];
        return ConditionItemWidget(
          condition: condition,
          cubit: cubit,
          padding: padding,
          spacing: spacing,
        );
      },
    );
  }
}

class AppColors {
  static final Color kPrimaryColor = const Color(0xFF00C2CB);
  static final Color kPrimaryLight = const Color(0xFFE0F7FA);
  static final Color kPrimaryDark = const Color(0xFF007A7F);
  static final Color kSurfaceColor = const Color(0xFFFFFFFF);
  static final Color kErrorColor = const Color(0xFFCF6679);
}

class ConditionItemWidget extends StatelessWidget {
  final ChronicConditionModel condition;
  final ChronicConditionsCubit cubit;
  final double padding;
  final double spacing;

  const ConditionItemWidget({
    super.key,
    required this.condition,
    required this.cubit,
    required this.spacing,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsBottomSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.kPrimaryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(padding * 2),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Container with light gradient for more appeal
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.kPrimaryColor,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.local_hospital_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: spacing * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with better touch
                        Text(
                          condition.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Replaced PopupMenuButton with GestureDetector for nicer BottomSheet
                  GestureDetector(
                    onTap: () => _showActionBottomSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing * 0.8),
              if (condition.notes != null) ...[
                SizedBox(height: spacing * 0.5),
                // Improved notes with more elegant Chip-like design, with onTap for full view
                GestureDetector(
                  onTap: () => _showNotesDialog(context, condition.notes!),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.kPrimaryColor.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 14,
                          color: AppColors.kPrimaryColor,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                condition.notes!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.kPrimaryColor,
                                  height: 1.2,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              if (condition.notes!.length > 50)
                                Text(
                                  context.tr.viewMore,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.kPrimaryColor
                                        .withOpacity(0.8),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: spacing * 0.8),
              ] else ...[
                SizedBox(height: spacing * 0.8),
              ],
              // Date with improved design
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    context.tr.addedDate(condition.createdAt.toLocal().toString().split(' ')[0]),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show full details in BottomSheet on card tap
  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                condition.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              if (condition.notes != null) ...[
                Text(
                  '${context.tr.notes}:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.kPrimaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    condition.notes!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.kPrimaryColor,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.kPrimaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.tr.addedDate(condition.createdAt.toLocal().toString().split(' ')[0]),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show full notes in Dialog on tap
  void _showNotesDialog(BuildContext context, String notes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.note,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              context.tr.notes,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            notes,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.tr.close,
              style: TextStyle(color: AppColors.kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show elegant BottomSheet for options (instead of old PopupMenu)
  void _showActionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      elevation: 8,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // BottomSheet title
              Text(
                context.tr.conditionOptions,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              // Delete option with confirmation
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kErrorColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.kErrorColor),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  context.tr.deleteCondition,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(context.tr.actionCannotBeUndone),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.transparent,
              ),
              const SizedBox(height: 10),
              // Add another option if needed, like edit
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.kPrimaryColor),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  context.tr.editCondition,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  Navigator.pop(context);
                  // cubit.editChronicCondition(condition: condition); // Call edit
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirmation delete function in elegant Dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kErrorColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kErrorColor),
              ),
              child: Icon(
                Icons.warning_amber_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              context.tr.deleteConfirmation,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          context.tr.confirmDeleteCondition,
          style: TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.tr.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteChronicCondition(id: condition.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kErrorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(context.tr.delete),
          ),
        ],
      ),
    );
  }
}
