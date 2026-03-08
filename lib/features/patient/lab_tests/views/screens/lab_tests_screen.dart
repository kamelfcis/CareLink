import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/network/supabase/storage/upload_file.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/network/supabase/database/get_data_with_spacific_id.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Assuming image_picker for selecting image
import 'package:meta/meta.dart';

@immutable
class LabTestModel {
  final String id;
  final String patientId;
  final String? testName;
  final String? filePath;
  final DateTime? testDate;
  final String? testNumber;
  final String? notes;
  final DateTime createdAt;

  const LabTestModel({
    required this.id,
    required this.patientId,
    this.testName,
    this.filePath,
    this.testDate,
    this.testNumber,
    this.notes,
    required this.createdAt,
  });

  factory LabTestModel.fromMap(Map<String, dynamic> map) {
    return LabTestModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      testName: map['test_name'] as String?,
      filePath: map['file_path'] as String?,
      testDate: map['test_date'] != null ? DateTime.parse(map['test_date']) : null,
      testNumber: map['test_number'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'test_name': testName,
      'file_path': filePath,
      'test_date': testDate?.toIso8601String().split('T')[0],
      'test_number': testNumber,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class LabTestsCubit extends Cubit<LabTestsState> {
  LabTestsCubit({required this.patientId})
      : super(LabTestsInitial()) {
    getLabTests();
  }

  final String patientId;

  // -->> variables
  List<LabTestModel> labTests = [];
  final supabase = getIt<SupabaseClient>();

  // -->> functions
  getLabTests() async {
    try {
      emit(GetLabTestsLoading());
      final response = await getDataWithSpacificId(
        tableName: "lab_tests",
        id: patientId,
        primaryKey: "patient_id",
      );
      log(response.toString());
      labTests = (response as List)
          .map<LabTestModel>((e) => LabTestModel.fromMap(e))
          .toList();
      emit(GetLabTestsSuccess());
    } catch (e) {
      log('Error fetching lab tests: $e');
      emit(GetLabTestsError(errorMessage: e.toString()));
    }
  }

  // Add new lab test - Assuming uploadLabTestImage is your ready function
  Future<void> addLabTest({
    String? testName,
    File? imageFile,
    DateTime? testDate,
    String? testNumber,
    String? notes,
  }) async {
    try {
      emit(AddLabTestLoading());
      String? filePath;
      if (imageFile != null) {
        // Call your ready upload function here
        filePath = await uploadFileToSupabaseStorage(file:imageFile,pucketName: "lab-tests"); // Replace with your actual function
        if (filePath == null) {
          emit(AddLabTestError(errorMessage: 'Failed to upload image')); // Not user-facing directly
          return;
        }
      }

      final Map <String, dynamic> insertData = {
        "patient_id": patientId,
        "test_name": testName,
        "file_path": filePath,
        "test_date": testDate?.toIso8601String().split('T')[0],
        "test_number": testNumber,
        "notes": notes,
        "created_at": DateTime.now().toIso8601String(),
      };
      final response = await supabase.from("lab_tests").insert(insertData).select();
      log('Insert response: $response');
      await getLabTests();
      emit(AddLabTestSuccess());
    } catch (e) {
      log('Error adding lab test: $e');
      emit(AddLabTestError(errorMessage: e.toString()));
    }
  }

  // Delete lab test
  deleteLabTest({required String id}) async {
    try {
      emit(DeleteLabTestLoading());
      await supabase.from("lab_tests").delete().eq("id", id);
      await getLabTests();
      emit(DeleteLabTestSuccess());
    } catch (e) {
      log('Error deleting lab test: $e');
      emit(DeleteLabTestError(errorMessage: e.toString()));
    }
  }

}

sealed class LabTestsState {}

final class LabTestsInitial extends LabTestsState {}

final class GetLabTestsSuccess extends LabTestsState {}

final class GetLabTestsLoading extends LabTestsState {}

final class GetLabTestsError extends LabTestsState {
  final String errorMessage;
  GetLabTestsError({required this.errorMessage});
}

final class AddLabTestSuccess extends LabTestsState {}

final class AddLabTestLoading extends LabTestsState {}

final class AddLabTestError extends LabTestsState {
  final String errorMessage;
  AddLabTestError({required this.errorMessage});
}

final class DeleteLabTestSuccess extends LabTestsState {}

final class DeleteLabTestLoading extends LabTestsState {}

final class DeleteLabTestError extends LabTestsState {
  final String errorMessage;
  DeleteLabTestError({required this.errorMessage});
}

class LabTestsScreen extends StatelessWidget {
  const LabTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    return LabTestsView(
      patientId: args!,
    );
  }
}

class LabTestsView extends StatefulWidget {
  const LabTestsView({required this.patientId});

  final String patientId;

  @override
  State<LabTestsView> createState() => _LabTestsViewState();
}

class _LabTestsViewState extends State<LabTestsView> {
  late final LabTestsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = LabTestsCubit(patientId: widget.patientId);
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
          child: BlocListener<LabTestsCubit, LabTestsState>(
            listener: (context, state) {
              if (state is AddLabTestSuccess) {
                context.popScreen();
                CustomQuickAlert.success(
                  title: context.tr.success,
                  message: context.tr.labTestAddedSuccess,
                );
              }
              if (state is AddLabTestError) {
                CustomQuickAlert.error(
                  title: context.tr.error,
                  message: state.errorMessage,
                );
              }
              if (state is DeleteLabTestSuccess) {
                CustomQuickAlert.success(
                  title: context.tr.success,
                  message: context.tr.labTestDeletedSuccess,
                );
              }
              if (state is DeleteLabTestError) {
                CustomQuickAlert.error(
                  title: context.tr.error,
                  message: state.errorMessage,
                );
              }
            },
            child: BlocBuilder<LabTestsCubit, LabTestsState>(
              builder: (context, state) {
                if (state is GetLabTestsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimaryColor,
                    ),
                  );
                }
                if (state is GetLabTestsError) {
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
                              .read<LabTestsCubit>()
                              .getLabTests(),
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
                final cubit = context.read<LabTestsCubit>();
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
                        child: BlocBuilder<LabTestsCubit, LabTestsState>(
                          builder: (context, state) {
                            if (state is DeleteLabTestLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              );
                            }
                            final labs = cubit.labTests;
                            return LabTestsListWidget(
                              labTests: labs,
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
      floatingActionButton: getIt<CacheHelper>().getDoctorModel() != null
          ? BlocBuilder(
        bloc: _cubit,
        builder: (context, state) {
          final isLoading = state is AddLabTestLoading;
          return FloatingActionButton.extended(
            onPressed: isLoading
                ? null
                : () => _showAddLabTestBottomSheet(context, _cubit),
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
              isLoading ? context.tr.adding : context.tr.addLabTest,
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
              Icons.local_hospital_outlined,
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
                  context.tr.labTests,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kPrimaryColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: spacing * 0.5),
                Text(
                  context.tr.trackLabTestResults,
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
  void _showAddLabTestBottomSheet(
    BuildContext context,
    LabTestsCubit cubit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => BlocConsumer<LabTestsCubit, LabTestsState>(
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
                                  child:  Icon(
                                    Icons.local_hospital_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  context.tr.addNewLabTest,
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
                              context.tr.fillLabTestDetails,
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
                  child: AddLabTestContent(
                    cubit: cubit,
                    scrollController: scrollController,
                    isLoading: state is AddLabTestLoading,
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

// Add lab test content with image picker
class AddLabTestContent extends StatefulWidget {
  final LabTestsCubit cubit;
  final ScrollController scrollController;
  final bool isLoading;

  const AddLabTestContent({
    super.key,
    required this.cubit,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  State<AddLabTestContent> createState() => _AddLabTestContentState();
}

class _AddLabTestContentState extends State<AddLabTestContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _testNumberController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _testDate;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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
                label: context.tr.testName,
                maxLines: 1,
                icon: Icons.local_hospital_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.tr.pleaseEnterTestName;
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing * 1),
              _buildEnhancedTextField(
                controller: _testNumberController,
                label: context.tr.testNumberOptional,
                maxLines: 1,
                icon: Icons.numbers,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty && value.trim().length < 2) {
                    return context.tr.testNumberMinLength;
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing * 1),
              _buildDatePickerField(
                label: context.tr.testDateOptional,
                selectedDate: _testDate,
                onTap: () => _selectDate(context),
                icon: Icons.calendar_today_outlined,
              ),
              SizedBox(height: spacing * 1),
              // Image picker section
              _buildImagePicker(),
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
                            widget.cubit.addLabTest(
                              testName: _nameController.text.trim(),
                              imageFile: _selectedImage,
                              testDate: _testDate,
                              testNumber: _testNumberController.text.trim().isEmpty ? null : _testNumberController.text.trim(),
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
                          context.tr.addLabTest,
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

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.testResultImage,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: widget.isLoading ? null : _pickImage,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.kPrimaryColor.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[50],
            ),
            child: _selectedImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: AppColors.kPrimaryColor,
                        size: 48,
                      ),
                      SizedBox(height: 8),
                      Text(
                        context.tr.tapToSelectImage,
                        style: TextStyle(
                          color: AppColors.kPrimaryColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 120,
                    ),
                  ),
          ),
        ),
        if (_selectedImage != null) ...[
          SizedBox(height: 4),
          TextButton.icon(
            onPressed: _removeImage,
            icon: Icon(Icons.delete, color: AppColors.kErrorColor, size: 16),
            label: Text(
              context.tr.removeImage,
              style: TextStyle(color: AppColors.kErrorColor),
            ),
          ),
        ],
        SizedBox(height: 12),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
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
        _testDate = picked;
      });
    }
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
          onTap: onTap,
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
    _testNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// List widget
class LabTestsListWidget extends StatelessWidget {
  final List<LabTestModel> labTests;
  final LabTestsCubit cubit;
  final double spacing;
  final double padding;

  const LabTestsListWidget({
    super.key,
    required this.labTests,
    required this.cubit,
    required this.spacing,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (labTests.isEmpty) {
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
                Icons.local_hospital_outlined,
                size: screenWidth * 0.18,
                color: AppColors.kPrimaryColor,
              ),
            ),
            SizedBox(height: spacing * 2),
            Text(
              context.tr.noLabTestsYet,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kPrimaryColor,
                height: 1.2,
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Text(
              context.tr.addFirstLabTest,
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
      itemCount: labTests.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final labTest = labTests[index];
        return LabTestItemWidget(
          labTest: labTest,
          cubit: cubit,
          padding: padding,
          spacing: spacing,
        );
      },
    );
  }
}

class LabTestItemWidget extends StatelessWidget {
  final LabTestModel labTest;
  final LabTestsCubit cubit;
  final double padding;
  final double spacing;

  const LabTestItemWidget({
    super.key,
    required this.labTest,
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
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
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
          padding: EdgeInsets.all(padding * 2.5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labTest.filePath != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        labTest.filePath!, // Assuming public URL
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.kPrimaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.kPrimaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing * 2),
                  ] else ...[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.kPrimaryColor,
                            AppColors.kPrimaryDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_hospital_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: spacing * 2),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labTest.testName ?? context.tr.unnamedTest,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        if (labTest.testNumber != null) ...[
                          SizedBox(height: spacing * 0.5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              context.tr.testNumberValue(labTest.testNumber!),
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
              if (labTest.notes != null) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacing * 2),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border(
                      left: BorderSide(
                                              color: AppColors.kPrimaryColor,
                      width: 4,

                      )
                    ),
                  ),
                  child: Text(
                    labTest.notes!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.kPrimaryColor.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1),
              ],
              if (labTest.testDate != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.kPrimaryColor,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      context.tr.testDateValue(labTest.testDate!.toLocal().toString().split(' ')[0]),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  context.tr.addedDate(labTest.createdAt.toLocal().toString().split(' ')[0]),
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
          child: SingleChildScrollView(
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
                Text(
                  labTest.testName ?? context.tr.unnamedTest,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                if (labTest.testNumber != null) ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.numbers,
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
                              context.tr.testNumber,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              labTest.testNumber!,
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
                if (labTest.testDate != null) ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_today,
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
                              context.tr.testDate,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              labTest.testDate!.toLocal().toString().split(' ')[0],
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
                if (labTest.filePath != null) ...[
                  Text(
                    context.tr.resultImage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      labTest.filePath!, // Assuming public URL
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.kPrimaryColor,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (labTest.notes != null) ...[
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
                      labTest.notes!,
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
                  context.tr.addedDate(labTest.createdAt.toLocal().toString().split(' ')[0]),
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
                context.tr.labTestOptions,
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
                  context.tr.deleteLabTest,
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
                  context.tr.editLabTest,
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
          context.tr.confirmDeleteLabTest,
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
              cubit.deleteLabTest(id: labTest.id);
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