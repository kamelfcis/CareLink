import 'package:care_link/core/components/custom_circular_progress_indecator.dart';
import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/patient/doctor_details/view_models/cubit/connect_with_doctor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectButton extends StatefulWidget {
  final String doctorId;

  const ConnectButton({super.key, required this.doctorId});

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  @override
  void initState() {
    super.initState();
    // Check current connection status as soon as the button mounts
    context
        .read<ConnectWithDoctorCubit>()
        .checkConnection(widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return BlocBuilder<ConnectWithDoctorCubit, ConnectWithDoctorState>(
      builder: (context, state) {
        final cubit = context.read<ConnectWithDoctorCubit>();

        // Show spinner while checking or while action is in progress
        if (state is ConnectWithDoctorChecking ||
            state is ConnectWithDoctorLoading) {
          return const CustomCircularProgresIndecator();
        }

        if (cubit.isConnected) {
          // ─── Disconnect button ────────────────────────────────────────
          return _ActionButton(
            label: tr.disconnect,
            icon: Icons.link_off_rounded,
            backgroundColor: Colors.red.shade600,
            onPressed: () => _confirmDisconnect(context),
          );
        }

        // ─── Connect button ─────────────────────────────────────────────
        return _ActionButton(
          label: tr.connect,
          icon: Icons.link_rounded,
          backgroundColor: AppColors.kPrimaryColor,
          onPressed: () =>
              cubit.connectWithDoctor(doctorId: widget.doctorId),
        );
      },
    );
  }

  void _confirmDisconnect(BuildContext context) {
    final tr = context.tr;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(tr.disconnectDoctor),
        content: Text(tr.confirmDisconnect),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr.cancel,
                style: TextStyle(color: AppColors.kPrimaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<ConnectWithDoctorCubit>()
                  .disconnectFromDoctor(doctorId: widget.doctorId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(tr.disconnect),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: SizeConfig.width * 0.05),
        label: Text(label, style: AppTextStyles.title16WhiteBold),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.height * 0.018,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}
