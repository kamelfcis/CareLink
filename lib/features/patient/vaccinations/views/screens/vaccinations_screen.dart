import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/network/supabase/database/get_data_with_spacific_id.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meta/meta.dart';

@immutable
class VaccinationModel {
  final String id;
  final String patientId;
  final String vaccineName;
  final int? doseNumber;
  final DateTime? vaccinationDate;
  final String? notes;
  final DateTime createdAt;

  const VaccinationModel({
    required this.id,
    required this.patientId,
    required this.vaccineName,
    this.doseNumber,
    this.vaccinationDate,
    this.notes,
    required this.createdAt,
  });

  factory VaccinationModel.fromMap(Map<String, dynamic> map) {
    return VaccinationModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      vaccineName: map['vaccine_name'] as String,
      doseNumber: map['dose_number'] as int?,
      vaccinationDate: map['vaccination_date'] != null ? DateTime.parse(map['vaccination_date']) : null,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'vaccine_name': vaccineName,
      'dose_number': doseNumber,
      'vaccination_date': vaccinationDate?.toIso8601String().split('T')[0],
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class VaccinationsCubit extends Cubit<VaccinationsState> {
  VaccinationsCubit({required this.patientId})
      : super(VaccinationsInitial()) {
    getVaccinations();
  }

  final String patientId;

  // -->> variables
  List<VaccinationModel> vaccinations = [];
  final supabase = getIt<SupabaseClient>();

  // -->> functions
  getVaccinations() async {
    try {
      emit(GetVaccinationsLoading());
      final response = await getDataWithSpacificId(
        tableName: "vaccinations",
        id: patientId,
        primaryKey: "patient_id",
      );
      log(response.toString());
      vaccinations = (response as List)
          .map<VaccinationModel>((e) => VaccinationModel.fromMap(e))
          .toList();
      emit(GetVaccinationsSuccess());
    } catch (e) {
      log('Error fetching vaccinations: $e');
      emit(GetVaccinationsError(errorMessage: e.toString()));
    }
  }

  // Add new vaccination
  addVaccination({
    required String vaccineName,
    int? doseNumber,
    DateTime? vaccinationDate,
    String? notes,
  }) async {
    try {
      emit(AddVaccinationLoading());
      final insertData = <String, dynamic>{
        "patient_id": patientId,
        "vaccine_name": vaccineName,
        "notes": notes,
        "created_at": DateTime.now().toIso8601String(),
      };
      if (doseNumber != null) {
        insertData["dose_number"] = doseNumber;
      }
      if (vaccinationDate != null) {
        insertData["vaccination_date"] = vaccinationDate.toIso8601String().split('T')[0];
      }
      final response = await supabase.from("vaccinations").insert(insertData).select();
      log('Insert response: $response');
      await getVaccinations();
      emit(AddVaccinationSuccess());
    } catch (e) {
      log('Error adding vaccination: $e');
      emit(AddVaccinationError(errorMessage: e.toString()));
    }
  }

  // Delete vaccination
  deleteVaccination({required String id}) async {
    try {
      emit(DeleteVaccinationLoading());
      await supabase.from("vaccinations").delete().eq("id", id);
      await getVaccinations();
      emit(DeleteVaccinationSuccess());
    } catch (e) {
      log('Error deleting vaccination: $e');
      emit(DeleteVaccinationError(errorMessage: e.toString()));
    }
  }
}

sealed class VaccinationsState {}

final class VaccinationsInitial extends VaccinationsState {}

final class GetVaccinationsSuccess extends VaccinationsState {}

final class GetVaccinationsLoading extends VaccinationsState {}

final class GetVaccinationsError extends VaccinationsState {
  final String errorMessage;
  GetVaccinationsError({required this.errorMessage});
}

final class AddVaccinationSuccess extends VaccinationsState {}

final class AddVaccinationLoading extends VaccinationsState {}

final class AddVaccinationError extends VaccinationsState {
  final String errorMessage;
  AddVaccinationError({required this.errorMessage});
}

final class DeleteVaccinationSuccess extends VaccinationsState {}

final class DeleteVaccinationLoading extends VaccinationsState {}

final class DeleteVaccinationError extends VaccinationsState {
  final String errorMessage;
  DeleteVaccinationError({required this.errorMessage});
}

class VaccinationsScreen extends StatelessWidget {
  const VaccinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    return VaccinationsView(
      patientId: args!,
    );
  }
}

class VaccinationsView extends StatefulWidget {
  const VaccinationsView({required this.patientId});

  final String patientId;

  @override
  State<VaccinationsView> createState() => _VaccinationsViewState();
}

class _VaccinationsViewState extends State<VaccinationsView> {
  late final VaccinationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = VaccinationsCubit(patientId: widget.patientId);
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
          child: BlocListener<VaccinationsCubit, VaccinationsState>(
            listener: (context, state) {
              if (state is AddVaccinationSuccess) {
                context.popScreen();
                CustomQuickAlert.success(
                  title: context.tr.success,
                  message: context.tr.vaccinationAddedSuccess,
                );
              }
              if (state is AddVaccinationError) {
                CustomQuickAlert.error(
                  title: context.tr.error,
                  message: state.errorMessage,
                );
              }
              if (state is DeleteVaccinationSuccess) {
                CustomQuickAlert.success(
                  title: context.tr.success,
                  message: context.tr.vaccinationDeletedSuccess,
                );
              }
              if (state is DeleteVaccinationError) {
                CustomQuickAlert.error(
                  title: context.tr.error,
                  message: state.errorMessage,
                );
              }
            },
            child: BlocBuilder<VaccinationsCubit, VaccinationsState>(
              builder: (context, state) {
                if (state is GetVaccinationsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimaryColor,
                    ),
                  );
                }
                if (state is GetVaccinationsError) {
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
                              .read<VaccinationsCubit>()
                              .getVaccinations(),
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
                final cubit = context.read<VaccinationsCubit>();
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
                        child: BlocBuilder<VaccinationsCubit, VaccinationsState>(
                          builder: (context, state) {
                            if (state is DeleteVaccinationLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              );
                            }
                            final vacs = cubit.vaccinations;
                            return VaccinationsListWidget(
                              vaccinations: vacs,
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
          final isLoading = state is AddVaccinationLoading;
          return FloatingActionButton.extended(
            onPressed: isLoading
                ? null
                : () => _showAddVaccinationBottomSheet(context, _cubit),
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
              isLoading ? context.tr.adding : context.tr.addVaccination,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ):null,
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
              Icons.vaccines_outlined,
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
                  context.tr.vaccinations,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kPrimaryColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                Text(
                  context.tr.trackVaccinationHistory,
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

  // Function to show Bottom Sheet for adding
  void _showAddVaccinationBottomSheet(
    BuildContext context,
    VaccinationsCubit cubit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => BlocConsumer<VaccinationsCubit, VaccinationsState>(
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
                                    Icons.vaccines_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  context.tr.addNewVaccination,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.tr.fillVaccinationDetails,
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
                  child: AddVaccinationContent(
                    cubit: cubit,
                    scrollController: scrollController,
                    isLoading: state is AddVaccinationLoading,
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

// Add vaccination content
class AddVaccinationContent extends StatefulWidget {
  final VaccinationsCubit cubit;
  final ScrollController scrollController;
  final bool isLoading;

  const AddVaccinationContent({
    super.key,
    required this.cubit,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  State<AddVaccinationContent> createState() => _AddVaccinationContentState();
}

class _AddVaccinationContentState extends State<AddVaccinationContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  int? _doseNumber;
  DateTime? _vaccinationDate;

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
              SizedBox(height: spacing * 1),
              _buildEnhancedTextField(
                controller: _nameController,
                label: context.tr.vaccineName,
                maxLines: 1,
                icon: Icons.vaccines_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.tr.pleaseEnterVaccineName;
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing * 1),
              _buildNumberInput(),
              SizedBox(height: spacing * 1),
              _buildDatePickerField(
                label: context.tr.vaccinationDate,
                selectedDate: _vaccinationDate,
                onTap: () => _selectDate(context),
                icon: Icons.calendar_today_outlined,
              ),
              SizedBox(height: spacing * 1),
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
              SizedBox(height: spacing * 2),
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
                            if (_vaccinationDate == null) {
                              CustomQuickAlert.error(
                                title: context.tr.error,
                                message: context.tr.vaccinationDateRequired,
                              );
                              return;
                            }
                            widget.cubit.addVaccination(
                              vaccineName: _nameController.text.trim(),
                              doseNumber: _doseNumber,
                              vaccinationDate: _vaccinationDate,
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
                          context.tr.addVaccination,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: spacing * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.doseNumberOptional,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          enabled: !widget.isLoading,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final num = int.tryParse(value);
              if (num == null || num <= 0) {
                return context.tr.doseNumberPositive;
              }
            }
            return null;
          },
          onChanged: (value) {
            _doseNumber = int.tryParse(value);
          },
          decoration: InputDecoration(
            prefixIcon: Container(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.numbers,
                color: AppColors.kPrimaryColor,
                size: 24,
              ),
            ),
            labelText: context.tr.enterDoseNumber,
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
        SizedBox(height: 12),
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
          child: AbsorbPointer(
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
        SizedBox(height: 12),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _vaccinationDate = picked;
      });
    }
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
        SizedBox(height: 12),
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

// List widget
class VaccinationsListWidget extends StatelessWidget {
  final List<VaccinationModel> vaccinations;
  final VaccinationsCubit cubit;
  final double spacing;
  final double padding;

  const VaccinationsListWidget({
    super.key,
    required this.vaccinations,
    required this.cubit,
    required this.spacing,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (vaccinations.isEmpty) {
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
                Icons.vaccines_outlined,
                size: screenWidth * 0.18,
                color: AppColors.kPrimaryColor,
              ),
            ),
            SizedBox(height: spacing * 2),
            Text(
              context.tr.noVaccinationsYet,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kPrimaryColor,
                height: 1.2,
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Text(
              context.tr.addFirstVaccination,
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
      itemCount: vaccinations.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final vaccination = vaccinations[index];
        return VaccinationItemWidget(
          vaccination: vaccination,
          cubit: cubit,
          padding: padding,
          spacing: spacing,
        );
      },
    );
  }
}

class VaccinationItemWidget extends StatelessWidget {
  final VaccinationModel vaccination;
  final VaccinationsCubit cubit;
  final double padding;
  final double spacing;

  const VaccinationItemWidget({
    super.key,
    required this.vaccination,
    required this.cubit,
    required this.spacing,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsBottomSheet(context),
      child: Container(
        // Different UI: Horizontal layout with timeline feel
        margin: EdgeInsets.symmetric(vertical: spacing * 0.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.kPrimaryColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(padding * 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kPrimaryColor,
                      AppColors.kPrimaryDark,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.vaccines_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: spacing * 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            vaccination.vaccineName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (vaccination.doseNumber != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              context.tr.doseLabel(vaccination.doseNumber!),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.kPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (vaccination.vaccinationDate != null) ...[
                      SizedBox(height: spacing * 0.5),
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            color: AppColors.kPrimaryColor,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${vaccination.vaccinationDate!.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (vaccination.notes != null) ...[
                      SizedBox(height: spacing * 0.5),
                      Text(
                        vaccination.notes!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: spacing * 0.5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        context.tr.addedDate(vaccination.createdAt.toLocal().toString().split(' ')[0]),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing * 0.5),
              GestureDetector(
                onTap: () => _showActionBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    color: AppColors.kPrimaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      vaccination.vaccineName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (vaccination.doseNumber != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        context.tr.doseLabel(vaccination.doseNumber!),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              if (vaccination.vaccinationDate != null) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.event,
                        color: AppColors.kPrimaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.dateLabel,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vaccination.vaccinationDate!.toLocal().toString().split(' ')[0],
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
                ),
                const SizedBox(height: 12),
              ],
              if (vaccination.notes != null) ...[
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
                    vaccination.notes!,
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
                context.tr.addedDate(vaccination.createdAt.toLocal().toString().split(' ')[0]),
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
    );
  }

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
                context.tr.vaccinationOptions,
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
                  context.tr.deleteVaccination,
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
                  context.tr.editVaccination,
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
          context.tr.confirmDeleteVaccination,
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
              cubit.deleteVaccination(id: vaccination.id);
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