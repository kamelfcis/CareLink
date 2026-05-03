import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_link/core/cache/cache_helper.dart';
import 'package:care_link/core/di/dependancy_injection.dart';
import 'package:care_link/core/helper/app_date_picker.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/network/supabase/storage/upload_file.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/extensions/app_extensions.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ═══════════════════════════════════════════════════
//  MODEL
// ═══════════════════════════════════════════════════

@immutable
class PrescriptionModel {
  final String id;
  final String patientId;
  final String? doctorId;
  final String? doctorPatientId;
  final String? imagePath; // stores the public URL from storage
  final String? notes;
  final DateTime createdAt;

  const PrescriptionModel({
    required this.id,
    required this.patientId,
    this.doctorId,
    this.doctorPatientId,
    this.imagePath,
    this.notes,
    required this.createdAt,
  });

  /// Whether this prescription was uploaded by a doctor
  bool get isFromDoctor => doctorId != null;

  factory PrescriptionModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      doctorId: map['doctor_id'] as String?,
      doctorPatientId: map['doctor_patient_id'] as String?,
      // Support both old image_url (if added) and new image_path column
      imagePath: (map['image_path'] ?? map['image_url']) as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.tryParse(
              (map['created_at'] ?? map['prescribed_at']) as String? ?? '') ??
          DateTime.now(),
    );
  }
}

// ═══════════════════════════════════════════════════
//  STATES
// ═══════════════════════════════════════════════════

@immutable
sealed class PrescriptionsState {}

final class PrescriptionsInitial extends PrescriptionsState {}

final class PrescriptionsLoading extends PrescriptionsState {}

final class PrescriptionsLoaded extends PrescriptionsState {
  final List<PrescriptionModel> prescriptions;
  PrescriptionsLoaded(this.prescriptions);
}

final class PrescriptionsFailure extends PrescriptionsState {
  final String message;
  PrescriptionsFailure(this.message);
}

final class PrescriptionAdding extends PrescriptionsState {}

final class PrescriptionAddSuccess extends PrescriptionsState {}

final class PrescriptionAddFailure extends PrescriptionsState {
  final String message;
  PrescriptionAddFailure(this.message);
}

final class PrescriptionDeleting extends PrescriptionsState {}

final class PrescriptionDeleteSuccess extends PrescriptionsState {}

final class PrescriptionDeleteFailure extends PrescriptionsState {
  final String message;
  PrescriptionDeleteFailure(this.message);
}

final class PrescriptionImagePicked extends PrescriptionsState {
  final File image;
  PrescriptionImagePicked(this.image);
}

// ═══════════════════════════════════════════════════
//  CUBIT
// ═══════════════════════════════════════════════════

class PrescriptionsCubit extends Cubit<PrescriptionsState> {
  PrescriptionsCubit({
    required this.patientId,
    required this.isDoctor,
  }) : super(PrescriptionsInitial()) {
    fetchPrescriptions();
  }

  final String patientId;
  final bool isDoctor;

  List<PrescriptionModel> _prescriptions = [];
  List<PrescriptionModel> get prescriptions => _prescriptions;

  File? pickedImage;
  String? selectedDate;
  final notesController = TextEditingController();

  final _supabase = getIt<SupabaseClient>();

  // ── Fetch ───────────────────────────────────────
  Future<void> fetchPrescriptions() async {
    try {
      emit(PrescriptionsLoading());
      final response = await _supabase
          .from('prescriptions')
          .select()
          .eq('patient_id', patientId)
          .order('created_at', ascending: false);

      _prescriptions = (response as List)
          .map((e) => PrescriptionModel.fromMap(e))
          .toList();
      emit(PrescriptionsLoaded(_prescriptions));
    } catch (e) {
      log(e.toString());
      emit(PrescriptionsFailure(e.toString()));
    }
  }

  // ── Pick image ──────────────────────────────────
  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      pickedImage = File(picked.path);
      emit(PrescriptionImagePicked(pickedImage!));
    }
  }

  void removePickedImage() {
    pickedImage = null;
    emit(PrescriptionsLoaded(_prescriptions));
  }

  void selectDate(String date) {
    selectedDate = date;
  }

  // ── Add ─────────────────────────────────────────
  Future<void> addPrescription() async {
    if (pickedImage == null) return;

    try {
      emit(PrescriptionAdding());

      // Upload image and get its public URL
      final imagePath = await uploadFileToSupabaseStorage(
        file: pickedImage!,
        pucketName: 'prescriptions',
      );

      if (imagePath == null) {
        emit(PrescriptionAddFailure('Failed to upload image'));
        return;
      }

      String? doctorId;
      String? doctorPatientId;

      if (isDoctor) {
        // Get doctor id from cache
        doctorId = getIt<CacheHelper>().getDoctorModel()?.id;

        // Look up the doctor_patients connection record
        if (doctorId != null) {
          try {
            final conn = await _supabase
                .from('doctor_patients')
                .select('id')
                .eq('doctor_id', doctorId)
                .eq('patient_id', patientId)
                .maybeSingle();
            doctorPatientId = conn?['id'] as String?;
          } catch (_) {}
        }
      }

      await _supabase.from('prescriptions').insert({
        'patient_id': patientId,
        if (doctorId != null) 'doctor_id': doctorId,
        if (doctorPatientId != null) 'doctor_patient_id': doctorPatientId,
        'image_path': imagePath,
        if (notesController.text.trim().isNotEmpty)
          'notes': notesController.text.trim(),
      });

      // Reset form
      pickedImage = null;
      selectedDate = null;
      notesController.clear();

      emit(PrescriptionAddSuccess());
      await fetchPrescriptions();
    } catch (e) {
      log(e.toString());
      emit(PrescriptionAddFailure(e.toString()));
    }
  }

  // ── Delete ──────────────────────────────────────
  Future<void> deletePrescription(String prescriptionId) async {
    try {
      emit(PrescriptionDeleting());
      await _supabase
          .from('prescriptions')
          .delete()
          .eq('id', prescriptionId);
      emit(PrescriptionDeleteSuccess());
      await fetchPrescriptions();
    } catch (e) {
      log(e.toString());
      emit(PrescriptionDeleteFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    notesController.dispose();
    return super.close();
  }
}

// ═══════════════════════════════════════════════════
//  SCREEN
// ═══════════════════════════════════════════════════

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final patientId = args['patient_id'] as String;
    final isDoctor = args['is_doctor'] as bool? ?? false;

    return BlocProvider(
      create: (_) =>
          PrescriptionsCubit(patientId: patientId, isDoctor: isDoctor),
      child: const _PrescriptionsView(),
    );
  }
}

class _PrescriptionsView extends StatelessWidget {
  const _PrescriptionsView();

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final cubit = context.read<PrescriptionsCubit>();

    return BlocListener<PrescriptionsCubit, PrescriptionsState>(
      listener: (context, state) {
        if (state is PrescriptionAddSuccess) {
          Navigator.pop(context); // close bottom sheet
          CustomQuickAlert.success(
              title: tr.success, message: tr.prescriptionAddedSuccess);
        } else if (state is PrescriptionAddFailure) {
          CustomQuickAlert.error(
              title: tr.error, message: state.message);
        } else if (state is PrescriptionDeleteSuccess) {
          CustomQuickAlert.success(
              title: tr.success, message: tr.prescriptionDeletedSuccess);
        } else if (state is PrescriptionDeleteFailure) {
          CustomQuickAlert.error(
              title: tr.error, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _buildAppBar(context, tr),
        body: _PrescriptionsBody(),
        floatingActionButton: _AddFab(cubit: cubit),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, dynamic tr) {
    return AppBar(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.prescriptions, style: AppTextStyles.title18WhiteW500),
          Text(tr.managePrescriptions,
              style: AppTextStyles.title12White70),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: () =>
              context.read<PrescriptionsCubit>().fetchPrescriptions(),
        ),
      ],
    );
  }
}

// ─── Body ────────────────────────────────────────

class _PrescriptionsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return BlocBuilder<PrescriptionsCubit, PrescriptionsState>(
      builder: (context, state) {
        if (state is PrescriptionsLoading || state is PrescriptionDeleting) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
          );
        }

        if (state is PrescriptionsFailure) {
          return _ErrorView(message: state.message);
        }

        final cubit = context.read<PrescriptionsCubit>();
        final list = cubit.prescriptions;

        if (list.isEmpty) {
          return _EmptyView();
        }

        return RefreshIndicator(
          color: AppColors.kPrimaryColor,
          onRefresh: () => cubit.fetchPrescriptions(),
          child: ListView.builder(
            padding: EdgeInsets.all(SizeConfig.width * 0.04),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _PrescriptionCard(
                prescription: list[index],
                cubit: cubit,
              );
            },
          ),
        );
      },
    );
  }
}

// ─── Prescription Card ───────────────────────────

class _PrescriptionCard extends StatelessWidget {
  final PrescriptionModel prescription;
  final PrescriptionsCubit cubit;

  const _PrescriptionCard({
    required this.prescription,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final isDoctor = prescription.isFromDoctor;
    final hasImage =
        prescription.imagePath != null && prescription.imagePath!.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.018),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Image ───
          if (hasImage)
            GestureDetector(
              onTap: () => _viewFullImage(context, prescription.imagePath!),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
                child: Stack(
                  children: [
                    Image.network(
                      prescription.imagePath!,
                      height: SizeConfig.height * 0.25,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: SizeConfig.height * 0.25,
                          color: Colors.grey.shade100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kPrimaryColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        height: SizeConfig.height * 0.15,
                        color: Colors.grey.shade100,
                        child: Center(
                          child: Icon(Icons.broken_image_outlined,
                              color: Colors.grey.shade400,
                              size: SizeConfig.width * 0.12),
                        ),
                      ),
                    ),
                    // Tap hint overlay
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.zoom_in_rounded,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text('Tap to enlarge',
                                style: AppTextStyles.title12White70.copyWith(
                                    fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              height: SizeConfig.height * 0.12,
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.07),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
              ),
              child: Center(
                child: Icon(Icons.receipt_long_outlined,
                    size: SizeConfig.width * 0.12,
                    color: AppColors.kPrimaryColor.withOpacity(0.5)),
              ),
            ),

          // ─── Info ───
          Padding(
            padding: EdgeInsets.all(SizeConfig.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Uploader badge + date
                Row(
                  children: [
                    _UploaderBadge(isDoctor: isDoctor),
                    const Spacer(),
                    Text(
                      _formatDate(prescription.createdAt.toIso8601String()),
                      style: AppTextStyles.title12Grey,
                    ),
                  ],
                ),

                // Notes
                if (prescription.notes != null &&
                    prescription.notes!.isNotEmpty) ...[
                  SizedBox(height: SizeConfig.height * 0.01),
                  Text(
                    prescription.notes!,
                    style: AppTextStyles.title14Black,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                SizedBox(height: SizeConfig.height * 0.012),
                // Action row
                Row(
                  children: [
                    if (hasImage)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _viewFullImage(
                              context, prescription.imagePath!),
                          icon: Icon(Icons.visibility_outlined,
                              size: 16, color: AppColors.kPrimaryColor),
                          label: Text(tr.viewMore,
                              style: TextStyle(
                                  color: AppColors.kPrimaryColor,
                                  fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: AppColors.kPrimaryColor, width: 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.height * 0.01),
                          ),
                        ),
                      ),
                    if (hasImage)
                      SizedBox(width: SizeConfig.width * 0.02),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _confirmDelete(context, tr, prescription.id),
                        icon: const Icon(Icons.delete_outline,
                            size: 16, color: Colors.red),
                        label: Text(tr.delete,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.height * 0.01),
                        ),
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

  String _formatDate(String raw) {
    try {
      final d = DateTime.tryParse(raw);
      if (d == null) return raw;
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return raw;
    }
  }

  void _viewFullImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(SizeConfig.width * 0.04),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  child: Image.network(url, fit: BoxFit.contain),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, dynamic tr, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(tr.deleteConfirmation,
            style: AppTextStyles.title18BlackW500),
        content: Text(tr.confirmDeletePrescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr.cancel,
                style: TextStyle(color: AppColors.kPrimaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deletePrescription(id);
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

class _UploaderBadge extends StatelessWidget {
  final bool isDoctor;

  const _UploaderBadge({required this.isDoctor});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.025,
        vertical: SizeConfig.height * 0.004,
      ),
      decoration: BoxDecoration(
        color: isDoctor
            ? AppColors.kPrimaryColor.withOpacity(0.12)
            : Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDoctor ? Icons.medical_services_outlined : Icons.person_outline,
            size: 13,
            color: isDoctor ? AppColors.kPrimaryColor : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isDoctor ? tr.uploadedByDoctor : tr.uploadedByPatient,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDoctor ? AppColors.kPrimaryColor : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FAB ─────────────────────────────────────────

class _AddFab extends StatelessWidget {
  final PrescriptionsCubit cubit;

  const _AddFab({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_photo_alternate_outlined),
      label: Text(context.tr.addPrescription),
      onPressed: () => _showAddSheet(context),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _AddPrescriptionSheet(),
      ),
    );
  }
}

// ─── Add Bottom Sheet ────────────────────────────

class _AddPrescriptionSheet extends StatelessWidget {
  const _AddPrescriptionSheet();

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final cubit = context.read<PrescriptionsCubit>();

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.all(SizeConfig.width * 0.05),
        child: BlocConsumer<PrescriptionsCubit, PrescriptionsState>(
          listener: (context, state) {
            if (state is PrescriptionAddSuccess) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final isAdding = state is PrescriptionAdding;
            final hasImage = cubit.pickedImage != null;

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Text(tr.addNewPrescription,
                      style: AppTextStyles.title18BlackW500),
                  SizedBox(height: SizeConfig.height * 0.006),
                  Text(tr.fillPrescriptionDetails,
                      style: AppTextStyles.title14Grey),
                  SizedBox(height: SizeConfig.height * 0.025),

                  // ─── Image picker ───
                  Text(tr.prescriptionImage,
                      style: AppTextStyles.title16BlackBold),
                  SizedBox(height: SizeConfig.height * 0.01),
                  _ImagePickerWidget(cubit: cubit, isAdding: isAdding),
                  SizedBox(height: SizeConfig.height * 0.02),

                  // ─── Date ───
                  Text(tr.prescriptionDateOptional,
                      style: AppTextStyles.title16BlackBold),
                  SizedBox(height: SizeConfig.height * 0.008),
                  _DatePickerField(cubit: cubit),
                  SizedBox(height: SizeConfig.height * 0.02),

                  // ─── Notes ───
                  Text(tr.notesOptional,
                      style: AppTextStyles.title16BlackBold),
                  SizedBox(height: SizeConfig.height * 0.008),
                  TextFormField(
                    controller: cubit.notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: tr.notes,
                      hintStyle: AppTextStyles.title14Grey,
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: Colors.grey.shade300, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: AppColors.kPrimaryColor, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.025),

                  // ─── Submit ───
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (!hasImage || isAdding)
                          ? null
                          : () => cubit.addPrescription(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.kPrimaryColor.withOpacity(0.4),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.height * 0.018),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isAdding
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(tr.addPrescription,
                              style: AppTextStyles.title16WhiteBold),
                    ),
                  ),
                  SizedBox(height: SizeConfig.height * 0.01),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Image Picker Widget ─────────────────────────

class _ImagePickerWidget extends StatelessWidget {
  final PrescriptionsCubit cubit;
  final bool isAdding;

  const _ImagePickerWidget({required this.cubit, required this.isAdding});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return BlocBuilder<PrescriptionsCubit, PrescriptionsState>(
      buildWhen: (_, c) =>
          c is PrescriptionImagePicked || c is PrescriptionsLoaded,
      builder: (context, state) {
        final hasImage = cubit.pickedImage != null;

        if (hasImage) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  cubit.pickedImage!,
                  height: SizeConfig.height * 0.22,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (!isAdding)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: cubit.removePickedImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
            ],
          );
        }

        return GestureDetector(
          onTap: () => _showSourceSheet(context),
          child: Container(
            height: SizeConfig.height * 0.16,
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.kPrimaryColor.withOpacity(0.4),
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: SizeConfig.width * 0.1,
                  color: AppColors.kPrimaryColor,
                ),
                SizedBox(height: SizeConfig.height * 0.01),
                Text(
                  tr.tapToSelectPrescriptionImage,
                  style: TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.width * 0.035,
                  ),
                ),
                SizedBox(height: SizeConfig.height * 0.006),
                Text(tr.gallery,
                    style: AppTextStyles.title12Grey),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSourceSheet(BuildContext context) {
    final tr = context.tr;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.06,
          vertical: SizeConfig.height * 0.03,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tr.addPrescription, style: AppTextStyles.title18BlackW500),
            SizedBox(height: SizeConfig.height * 0.025),
            Row(
              children: [
                _SourceOption(
                  icon: Icons.photo_library_outlined,
                  label: tr.gallery,
                  onTap: () {
                    Navigator.pop(context);
                    cubit.pickImage(source: ImageSource.gallery);
                  },
                ),
                SizedBox(width: SizeConfig.width * 0.04),
                _SourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: tr.camera,
                  onTap: () {
                    Navigator.pop(context);
                    cubit.pickImage(source: ImageSource.camera);
                  },
                ),
              ],
            ),
            SizedBox(height: SizeConfig.height * 0.02),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.025),
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.kPrimaryColor.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: AppColors.kPrimaryColor,
                  size: SizeConfig.width * 0.09),
              SizedBox(height: SizeConfig.height * 0.008),
              Text(label, style: AppTextStyles.title14Black),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Date Picker Field ───────────────────────────

class _DatePickerField extends StatefulWidget {
  final PrescriptionsCubit cubit;

  const _DatePickerField({required this.cubit});

  @override
  State<_DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<_DatePickerField> {
  String? _displayDate;

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.kPrimaryColor,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          final formatted =
              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
          final displayFormatted =
              '${picked.day}/${picked.month}/${picked.year}';
          widget.cubit.selectDate(formatted);
          setState(() => _displayDate = displayFormatted);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width * 0.04,
          vertical: SizeConfig.height * 0.018,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                color: AppColors.kPrimaryColor, size: 20),
            SizedBox(width: SizeConfig.width * 0.03),
            Text(
              _displayDate ?? tr.selectDate,
              style: _displayDate != null
                  ? AppTextStyles.title14Black
                  : AppTextStyles.title14Grey,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty View ──────────────────────────────────

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: SizeConfig.width * 0.22,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: SizeConfig.height * 0.025),
            Text(
              tr.noPrescriptionsYet,
              style: AppTextStyles.title18BlackW500
                  .copyWith(color: Colors.grey.shade600),
            ),
            SizedBox(height: SizeConfig.height * 0.01),
            Text(
              tr.addFirstPrescription,
              style: AppTextStyles.title14Grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error View ──────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                size: SizeConfig.width * 0.15, color: Colors.red.shade300),
            SizedBox(height: SizeConfig.height * 0.02),
            Text(message,
                textAlign: TextAlign.center,
                style: AppTextStyles.title14Grey),
            SizedBox(height: SizeConfig.height * 0.02),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<PrescriptionsCubit>().fetchPrescriptions(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.tr.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
