import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/network/supabase/database/get_data_with_spacific_id.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meta/meta.dart';

@immutable
class MedicationModel {
  final String id;
  final String patientId;
  final String medicationName;
  final String? dosage;
  final String? frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? notes;
  final DateTime createdAt;

  const MedicationModel({
    required this.id,
    required this.patientId,
    required this.medicationName,
    this.dosage,
    this.frequency,
    this.startDate,
    this.endDate,
    this.notes,
    required this.createdAt,
  });

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      medicationName: map['medication_name'] as String,
      dosage: map['dosage'] as String?,
      frequency: map['frequency'] as String?,
      startDate: map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'medication_name': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'start_date': startDate?.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
class MedicationsCubit extends Cubit<MedicationsState> {
  MedicationsCubit({required this.patientId})
      : super(MedicationsInitial()) {
    getMedications();
  }

  final String patientId;

  // -->> variables
  List<MedicationModel> medications = [];
  final supabase = getIt<SupabaseClient>();

  // -->> functions
  getMedications() async {
    try {
      emit(GetMedicationsLoading());
      final response = await getDataWithSpacificId(
        tableName: "medications",
        id: patientId,
        primaryKey: "patient_id",
      );
      log(response.toString());
      medications = (response as List)
          .map<MedicationModel>((e) => MedicationModel.fromMap(e))
          .toList();
      emit(GetMedicationsSuccess());
    } catch (e) {
      log('Error fetching medications: $e');
      emit(GetMedicationsError(errorMessage: e.toString()));
    }
  }

  // Add new medication
  addMedication({
    required String medicationName,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    try {
      emit(AddMedicationLoading());
      final insertData = {
        "patient_id": patientId,
        "medication_name": medicationName,
        "dosage": dosage,
        "frequency": frequency,
        "notes": notes,
        "created_at": DateTime.now().toIso8601String(),
      };
      if (startDate != null) {
        insertData["start_date"] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        insertData["end_date"] = endDate.toIso8601String().split('T')[0];
      }
      final response = await supabase.from("medications").insert(insertData).select();
      log('Insert response: $response');
      await getMedications();
      emit(AddMedicationSuccess());
    } catch (e) {
      log('Error adding medication: $e');
      emit(AddMedicationError(errorMessage: e.toString()));
    }
  }

  // Delete medication
  deleteMedication({required String id}) async {
    try {
      emit(DeleteMedicationLoading());
      await supabase.from("medications").delete().eq("id", id);
      await getMedications();
      emit(DeleteMedicationSuccess());
    } catch (e) {
      log('Error deleting medication: $e');
      emit(DeleteMedicationError(errorMessage: e.toString()));
    }
  }
}

sealed class MedicationsState {}

final class MedicationsInitial extends MedicationsState {}

final class GetMedicationsSuccess extends MedicationsState {}

final class GetMedicationsLoading extends MedicationsState {}

final class GetMedicationsError extends MedicationsState {
  final String errorMessage;
  GetMedicationsError({required this.errorMessage});
}

final class AddMedicationSuccess extends MedicationsState {}

final class AddMedicationLoading extends MedicationsState {}

final class AddMedicationError extends MedicationsState {
  final String errorMessage;
  AddMedicationError({required this.errorMessage});
}

final class DeleteMedicationSuccess extends MedicationsState {}

final class DeleteMedicationLoading extends MedicationsState {}

final class DeleteMedicationError extends MedicationsState {
  final String errorMessage;
  DeleteMedicationError({required this.errorMessage});
}

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    return MedicationsView(
      patientId: args!,
    );
  }
}

class MedicationsView extends StatefulWidget {
  const MedicationsView({required this.patientId});

  final String patientId;

  @override
  State<MedicationsView> createState() => _MedicationsViewState();
}

class _MedicationsViewState extends State<MedicationsView> {
  late final MedicationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MedicationsCubit(patientId: widget.patientId);
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
          child: BlocListener<MedicationsCubit, MedicationsState>(
            listener: (context, state) {
              if (state is AddMedicationSuccess) {
                context.popScreen();
                CustomQuickAlert.success(
                  title: context.tr.success,
                  message: context.tr.medicationAddedSuccess,
                );
              }
              if (state is AddMedicationError) {
                CustomQuickAlert.error(
                  title: context.tr.error,
                  message: state.errorMessage,
                );
              }
              if (state is DeleteMedicationSuccess) {
                CustomQuickAlert.success(
                  title: context.tr.success,
                  message: context.tr.medicationDeletedSuccess,
                );
              }
              if (state is DeleteMedicationError) {
                CustomQuickAlert.error(
                  title: context.tr.error,
                  message: state.errorMessage,
                );
              }
            },
            child: BlocBuilder<MedicationsCubit, MedicationsState>(
              builder: (context, state) {
                if (state is GetMedicationsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimaryColor,
                    ),
                  );
                }
                if (state is GetMedicationsError) {
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
                              .read<MedicationsCubit>()
                              .getMedications(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            context.tr.retry,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // In Success or Initial, read data from Cubit
                final cubit = context.read<MedicationsCubit>();
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
                        child: BlocBuilder<MedicationsCubit, MedicationsState>(
                          builder: (context, state) {
                            if (state is DeleteMedicationLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              );
                            }
                            final meds = cubit.medications;
                            return MedicationsListWidget(
                              medications: meds,
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
      // Floating Action Button for adding
      floatingActionButton: getIt<CacheHelper>().getDoctorModel() == null
          ? BlocBuilder(
        bloc: _cubit,
        builder: (context, state) {
          final isLoading = state is AddMedicationLoading;
          return FloatingActionButton.extended(
            onPressed: isLoading
                ? null
                : () => _showAddMedicationBottomSheet(context, _cubit),
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
              isLoading ? context.tr.adding : context.tr.addMedication,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ): null,
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
              Icons.medication_liquid_outlined,
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
                  context.tr.medications,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kPrimaryColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                Text(
                  context.tr.manageCurrentMedications,
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

  // Function to show Bottom Sheet for adding - Similar to improved version
  void _showAddMedicationBottomSheet(
    BuildContext context,
    MedicationsCubit cubit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => BlocConsumer<MedicationsCubit, MedicationsState>(
        bloc: cubit,
        listener: (context, state) {
          // Global listener handles it
        },
        builder: (context, state) => DraggableScrollableSheet(
          initialChildSize: 0.75,
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
                // Enhanced handle
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(top: 16, bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Improved header
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
                                    Icons.medication_liquid_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  context.tr.addNewMedication,
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
                              context.tr.fillMedicationDetails,
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
                  child: AddMedicationContent(
                    cubit: cubit,
                    scrollController: scrollController,
                    isLoading: state is AddMedicationLoading,
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

// Add medication content with date pickers
class AddMedicationContent extends StatefulWidget {
  final MedicationsCubit cubit;
  final ScrollController scrollController;
  final bool isLoading;

  const AddMedicationContent({
    super.key,
    required this.cubit,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  State<AddMedicationContent> createState() => _AddMedicationContentState();
}

class _AddMedicationContentState extends State<AddMedicationContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final spacing = screenHeight * 0.015;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing * 1), // Reduced spacing
              _buildEnhancedTextField(
                controller: _nameController,
                label: context.tr.medicationName,
                maxLines: 1,
                icon: Icons.medication,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.tr.pleaseEnterMedicationName;
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing * 1), // Reduced spacing
              _buildEnhancedTextField(
                controller: _dosageController,
                label: context.tr.dosage,
                maxLines: 1,
                icon: Icons.tablet_outlined,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty && value.trim().length < 2) {
                    return context.tr.dosageMinLength;
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing * 1), // Reduced spacing
              _buildEnhancedTextField(
                controller: _frequencyController,
                label: context.tr.frequency,
                maxLines: 1,
                icon: Icons.schedule_outlined,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty && value.trim().length < 2) {
                    return context.tr.frequencyMinLength;
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing * 1), // Reduced spacing
              _buildDatePickerField(
                label: context.tr.startDate,
                selectedDate: _startDate,
                onTap: () => _selectDate(context, true),
                icon: Icons.calendar_today_outlined,
              ),
              SizedBox(height: spacing * 1), // Reduced spacing
              _buildDatePickerField(
                label: context.tr.endDateOptional,
                selectedDate: _endDate,
                onTap: () => _selectDate(context, false),
                icon: Icons.event_outlined,
              ),
              SizedBox(height: spacing * 1), // Reduced spacing
              _buildEnhancedTextField(
                controller: _notesController,
                label: context.tr.notesOptional,
                maxLines: 4,
                icon: Icons.note_alt_outlined,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
                    return context.tr.notesMinLength;
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing * 2), // Slightly reduced before button
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
                            // Additional validation for dates
                            if (_startDate == null) {
                              CustomQuickAlert.error(
                                title: context.tr.error,
                                message: context.tr.startDateRequired,
                              );
                              return;
                            }
                            if (_endDate != null && _endDate!.isBefore(_startDate!)) {
                              CustomQuickAlert.error(
                                title: context.tr.error,
                                message: context.tr.endDateAfterStart,
                              );
                              return;
                            }
                            widget.cubit.addMedication(
                              medicationName: _nameController.text.trim(),
                              dosage: _dosageController.text.trim().isEmpty ? null : _dosageController.text.trim(),
                              frequency: _frequencyController.text.trim().isEmpty ? null : _frequencyController.text.trim(),
                              startDate: _startDate,
                              endDate: _endDate,
                              notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
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
                          context.tr.addMedication,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: spacing * 2), // Reduced spacing
            ],
          ),
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
              borderSide:  BorderSide(
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
        SizedBox(height: 12), // Reduced internal spacing
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required IconData icon,
  }) {
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
        GestureDetector(
          onTap: widget.isLoading ? null : onTap,
          child: AbsorbPointer( // Prevent text selection
            absorbing: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.kPrimaryColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[50],
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.kPrimaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 16),
                  Text(
                    selectedDate == null ? context.tr.selectDate : '${selectedDate!.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(
                      color: selectedDate == null ? Colors.grey[600] : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12), // Reduced internal spacing
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// List widget
class MedicationsListWidget extends StatelessWidget {
  final List<MedicationModel> medications;
  final MedicationsCubit cubit;
  final double spacing;
  final double padding;

  const MedicationsListWidget({
    super.key,
    required this.medications,
    required this.cubit,
    required this.spacing,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (medications.isEmpty) {
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
                Icons.medication_liquid_outlined,
                size: screenWidth * 0.18,
                color: AppColors.kPrimaryColor,
              ),
            ),
            SizedBox(height: spacing * 2),
            Text(
              context.tr.noMedicationsYet,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kPrimaryColor,
                height: 1.2,
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Text(
              context.tr.addFirstMedication,
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
      itemCount: medications.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final medication = medications[index];
        return MedicationItemWidget(
          medication: medication,
          cubit: cubit,
          padding: padding,
          spacing: spacing,
        );
      },
    );
  }
}

class MedicationItemWidget extends StatelessWidget {
  final MedicationModel medication;
  final MedicationsCubit cubit;
  final double padding;
  final double spacing;

  const MedicationItemWidget({
    super.key,
    required this.medication,
    required this.cubit,
    required this.spacing,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsBottomSheet(context),
      child: Container(
        // Changed card shape: more rounded corners and subtle gradient border
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28), // Increased radius
          border: Border.all(
            color: AppColors.kPrimaryColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(padding * 2.5), // Slightly more padding
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Changed icon to pill shape
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.kPrimaryColor,
                          AppColors.kPrimaryDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24), // Pill shape
                      border: Border.all(
                        color: AppColors.kPrimaryColor,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.medication,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  SizedBox(width: spacing * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.medicationName,
                          style: TextStyle(
                            fontSize: 22, // Slightly larger
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        if (medication.dosage != null || medication.frequency != null) ...[
                          SizedBox(height: spacing * 0.5),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              if (medication.dosage != null) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.kPrimaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    context.tr.dosageValue(medication.dosage!),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.kPrimaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                              if (medication.frequency != null) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.kPrimaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    context.tr.frequencyValue(medication.frequency!),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.kPrimaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showActionBottomSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: AppColors.kPrimaryColor,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.2),
              if (medication.notes != null) ...[
                // Notes as a subtle badge
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacing * 2),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border(
                      left: BorderSide(
                        color: AppColors.kPrimaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    medication.notes!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.kPrimaryColor.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1),
              ],
              // Dates row with improved layout
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (medication.startDate != null) ...[
                    _buildDateChip(context.tr.startValue(medication.startDate!.toLocal().toString().split(' ')[0])),
                  ],
                  if (medication.endDate != null) ...[
                    _buildDateChip(context.tr.endValue(medication.endDate!.toLocal().toString().split(' ')[0])),
                  ],
                ],
              ),
              SizedBox(height: spacing * 0.5),
              // Created at at bottom
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  context.tr.addedDate(medication.createdAt.toLocal().toString().split(' ')[0]),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.kPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.kPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Similar details bottom sheet, adapted for medication
  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(
                  medication.medicationName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                if (medication.dosage != null) ...[
                  _buildDetailRow(Icons.tablet_outlined, context.tr.dosageLabel, medication.dosage!),
                  const SizedBox(height: 12),
                ],
                if (medication.frequency != null) ...[
                  _buildDetailRow(Icons.schedule_outlined, context.tr.frequencyLabel, medication.frequency!),
                  const SizedBox(height: 12),
                ],
                if (medication.startDate != null) ...[
                  _buildDetailRow(Icons.calendar_today, context.tr.startDateLabel, medication.startDate!.toLocal().toString().split(' ')[0]),
                  const SizedBox(height: 12),
                ],
                if (medication.endDate != null) ...[
                  _buildDetailRow(Icons.event, context.tr.endDateLabel, medication.endDate!.toLocal().toString().split(' ')[0]),
                  const SizedBox(height: 12),
                ],
                if (medication.notes != null) ...[
                  Text(
                    '${context.tr.notes}:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.kPrimaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      medication.notes!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.kPrimaryColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  context.tr.addedDate(medication.createdAt.toLocal().toString().split(' ')[0]),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.kPrimaryColor,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Action bottom sheet similar
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
              Text(
                context.tr.medicationOptions,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
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
                  context.tr.deleteMedication,
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
                  context.tr.editMedication,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Implement edit if needed
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

  // Delete confirmation similar
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
            Expanded(
              child: Text(
                context.tr.deleteConfirmation,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        content: Text(
          context.tr.confirmDeleteMedication,
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
              cubit.deleteMedication(id: medication.id);
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