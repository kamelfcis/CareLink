import 'package:care_link/core/constants/app_constants.dart';

/// Public profile URL encoded in the patient QR: `{site}/patient/{patientId}`.
/// Site root comes from [AppConstants.qrCodeUrl] (e.g. `http://carelink.somee.com/`).
String buildPatientQrPayload(String patientId) {
  final base = Uri.parse(AppConstants.qrCodeUrl);
  return base.resolve('patient/$patientId').toString();
}
