import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Egyptian governorates with their major cities / districts
// All 27 governorates are included (Arabic & English names provided).
// ---------------------------------------------------------------------------

class _EgyptianLocation {
  final String governorateAr;
  final String governorateEn;
  final List<String> centers;

  const _EgyptianLocation({
    required this.governorateAr,
    required this.governorateEn,
    required this.centers,
  });
}

const List<_EgyptianLocation> _kEgyptianLocations = [
  _EgyptianLocation(
    governorateAr: 'القاهرة',
    governorateEn: 'Cairo',
    centers: [
      'مدينة نصر', 'مصر الجديدة', 'مدينة الشروق', 'العباسية',
      'المعادي', 'المقطم', 'حلوان', 'التجمع الخامس',
      'عين شمس', 'شبرا', 'الزيتون', 'السلام',
      'الأميرية', 'منشأة ناصر', 'المرج', 'حي الأزبكية',
      'باب الشعرية', 'الجمالية', 'بولاق', 'الوايلي',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الجيزة',
    governorateEn: 'Giza',
    centers: [
      'أكتوبر', '6 أكتوبر', 'الشيخ زايد', 'الهرم',
      'الدقي', 'العجوزة', 'بولاق الدكرور', 'إمبابة',
      'الوراق', 'أوسيم', 'الحوامدية', 'الصف',
      'البدرشين', 'المنيب', 'كرداسة',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الإسكندرية',
    governorateEn: 'Alexandria',
    centers: [
      'المنتزه', 'سيدي جابر', 'العجمي', 'الجمرك',
      'المينا', 'بحري', 'محرم بك', 'سموحة',
      'كينج مريوط', 'العامرية', 'أبو قير', 'الدخيلة',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'البحيرة',
    governorateEn: 'Beheira',
    centers: [
      'دمنهور', 'كفر الدوار', 'إيتاي البارود', 'أبو حمص',
      'المحمودية', 'رشيد', 'شبراخيت', 'حوش عيسى',
      'الدلنجات', 'بدر', 'النوبارية', 'وادي النطرون',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'المنوفية',
    governorateEn: 'Monufia',
    centers: [
      'شبين الكوم', 'منوف', 'أشمون', 'الباجور',
      'السادات', 'قويسنا', 'تلا', 'بركة السبع',
      'الشهداء',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الغربية',
    governorateEn: 'Gharbia',
    centers: [
      'طنطا', 'المحلة الكبرى', 'زفتى', 'السنطة',
      'كفر الزيات', 'بسيون', 'سمنود', 'قطور',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الدقهلية',
    governorateEn: 'Dakahlia',
    centers: [
      'المنصورة', 'ميت غمر', 'طلخا', 'منية النصر',
      'دكرنس', 'أجا', 'المنزلة', 'بلقاس',
      'شربين', 'سنباط', 'نبروه', 'تمي الأمديد',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الشرقية',
    governorateEn: 'Sharqia',
    centers: [
      'الزقازيق', 'العاشر من رمضان', 'بلبيس', 'أبو كبير',
      'المنيا الجديدة', 'ههيا', 'فاقوس', 'كفر صقر',
      'أبو حماد', 'ديرب نجم', 'الإبراهيمية',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'كفر الشيخ',
    governorateEn: 'Kafr el-Sheikh',
    centers: [
      'كفر الشيخ', 'دسوق', 'فوه', 'مطوبس',
      'الحامول', 'بيلا', 'الرياض', 'سيدي سالم',
      'قلين', 'بلطيم',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الإسماعيلية',
    governorateEn: 'Ismailia',
    centers: [
      'الإسماعيلية', 'أبو صوير', 'القصاصين', 'التل الكبير',
      'فايد', 'القنطرة شرق', 'القنطرة غرب',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'بورسعيد',
    governorateEn: 'Port Said',
    centers: [
      'بورسعيد', 'بورفؤاد', 'الزهور', 'الشرق',
      'المناخ', 'الضواحي',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'السويس',
    governorateEn: 'Suez',
    centers: [
      'السويس', 'الأربعين', 'عتاقة', 'فيصل',
      'الجناين', 'الصالحية',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'شمال سيناء',
    governorateEn: 'North Sinai',
    centers: [
      'العريش', 'رفح', 'الشيخ زويد', 'بئر العبد',
      'نخل', 'الحسنة',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'جنوب سيناء',
    governorateEn: 'South Sinai',
    centers: [
      'الطور', 'شرم الشيخ', 'دهب', 'نويبع',
      'طابا', 'أبو زنيمة', 'سانت كاترين',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'البحر الأحمر',
    governorateEn: 'Red Sea',
    centers: [
      'الغردقة', 'سفاجا', 'القصير', 'مرسى علم',
      'الشلاتين', 'حلايب',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'مطروح',
    governorateEn: 'Matrouh',
    centers: [
      'مرسى مطروح', 'سيوة', 'الضبعة', 'السلوم',
      'النجيلة', 'الحمام',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الوادي الجديد',
    governorateEn: 'New Valley',
    centers: [
      'الخارجة', 'الداخلة', 'الفرافرة', 'بلاط',
      'موط', 'باريس',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'أسيوط',
    governorateEn: 'Assiut',
    centers: [
      'أسيوط', 'ديروط', 'المنفلوطي', 'أبنوب',
      'أبو تيج', 'صدفا', 'الغنايم', 'القوصية',
      'ساحل سليم',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'سوهاج',
    governorateEn: 'Sohag',
    centers: [
      'سوهاج', 'أخميم', 'طهطا', 'جرجا',
      'البلينا', 'المراغة', 'المنشأة', 'دار السلام',
      'ساقلتة', 'الكوثر',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'قنا',
    governorateEn: 'Qena',
    centers: [
      'قنا', 'نجع حمادي', 'دشنا', 'قفط',
      'قوص', 'نقادة', 'أبو تشت', 'فرشوط',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الأقصر',
    governorateEn: 'Luxor',
    centers: [
      'الأقصر', 'الأقصر الغربية', 'إسنا', 'الطود',
      'أرمنت', 'القرنة',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'أسوان',
    governorateEn: 'Aswan',
    centers: [
      'أسوان', 'كوم أمبو', 'إدفو', 'نصر النوبة',
      'دراو', 'أبو سمبل السياحية',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'المنيا',
    governorateEn: 'Minya',
    centers: [
      'المنيا', 'ملوى', 'أبو قرقاص', 'مغاغة',
      'بني مزار', 'سمالوط', 'المطاهرة', 'العدوة',
      'دير مواس',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'بني سويف',
    governorateEn: 'Beni Suef',
    centers: [
      'بني سويف', 'الواسطى', 'ناصر', 'إهناسيا',
      'ببا', 'الفشن', 'سمسطا',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'الفيوم',
    governorateEn: 'Fayoum',
    centers: [
      'الفيوم', 'إبشواي', 'سنورس', 'يوسف الصديق',
      'طامية', 'الحادقة',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'دمياط',
    governorateEn: 'Damietta',
    centers: [
      'دمياط', 'رأس البر', 'فارسكور', 'الزرقا',
      'كفر سعد', 'السرو',
    ],
  ),
  _EgyptianLocation(
    governorateAr: 'القليوبية',
    governorateEn: 'Qalyubia',
    centers: [
      'بنها', 'شبرا الخيمة', 'قليوب', 'القناطر',
      'طوخ', 'الخانكة', 'الخصوص', 'كفر شكر',
      'الأبيض',
    ],
  ),
];

// ---------------------------------------------------------------------------
// LocationDropdownWidget
// ---------------------------------------------------------------------------

/// A pair of cascading dropdowns that let the user select an Egyptian
/// governorate and then a city / district within that governorate.
///
/// Example usage:
/// ```dart
/// LocationDropdownWidget(
///   onLocationSelected: (governorate, center) {
///     print('$governorate → $center');
///   },
/// )
/// ```
class LocationDropdownWidget extends StatefulWidget {
  /// Called whenever both a governorate AND a center have been selected.
  final void Function(String governorate, String center) onLocationSelected;

  /// Optional initial governorate (Arabic name).
  final String? initialGovernorate;

  /// Optional initial center within [initialGovernorate].
  final String? initialCenter;

  /// Label text for the governorate dropdown.
  final String governorateLabel;

  /// Label text for the center/district dropdown.
  final String centerLabel;

  /// Whether to show the English governorate name in parentheses.
  final bool showEnglishNames;

  const LocationDropdownWidget({
    super.key,
    required this.onLocationSelected,
    this.initialGovernorate,
    this.initialCenter,
    this.governorateLabel = 'المحافظة',
    this.centerLabel = 'المركز / المدينة',
    this.showEnglishNames = false,
  });

  @override
  State<LocationDropdownWidget> createState() => _LocationDropdownWidgetState();
}

class _LocationDropdownWidgetState extends State<LocationDropdownWidget> {
  _EgyptianLocation? _selectedLocation;
  String? _selectedCenter;

  @override
  void initState() {
    super.initState();
    if (widget.initialGovernorate != null) {
      _selectedLocation = _kEgyptianLocations.firstWhere(
        (loc) => loc.governorateAr == widget.initialGovernorate,
        orElse: () => _kEgyptianLocations.first,
      );
      if (widget.initialCenter != null &&
          _selectedLocation!.centers.contains(widget.initialCenter)) {
        _selectedCenter = widget.initialCenter;
      }
    }
  }

  void _onGovernorateChanged(_EgyptianLocation? location) {
    setState(() {
      _selectedLocation = location;
      _selectedCenter = null; // reset city when governorate changes
    });
  }

  void _onCenterChanged(String? center) {
    setState(() => _selectedCenter = center);
    if (center != null && _selectedLocation != null) {
      widget.onLocationSelected(_selectedLocation!.governorateAr, center);
    }
  }

  String _governorateLabel(_EgyptianLocation loc) {
    if (widget.showEnglishNames) {
      return '${loc.governorateAr}  (${loc.governorateEn})';
    }
    return loc.governorateAr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Governorate dropdown ────────────────────────────────────────────
        _buildDropdownCard(
          context: context,
          label: widget.governorateLabel,
          icon: Icons.location_city_rounded,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<_EgyptianLocation>(
              value: _selectedLocation,
              isExpanded: true,
              hint: Text(
                'اختر المحافظة',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.primary),
              items: _kEgyptianLocations.map((loc) {
                return DropdownMenuItem<_EgyptianLocation>(
                  value: loc,
                  child: Text(
                    _governorateLabel(loc),
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: _onGovernorateChanged,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Center / district dropdown ──────────────────────────────────────
        AnimatedOpacity(
          opacity: _selectedLocation != null ? 1.0 : 0.45,
          duration: const Duration(milliseconds: 250),
          child: IgnorePointer(
            ignoring: _selectedLocation == null,
            child: _buildDropdownCard(
              context: context,
              label: widget.centerLabel,
              icon: Icons.place_rounded,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCenter,
                  isExpanded: true,
                  hint: Text(
                    _selectedLocation == null
                        ? 'اختر المحافظة أولاً'
                        : 'اختر المركز / المدينة',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: _selectedLocation != null
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.3)),
                  items: (_selectedLocation?.centers ?? []).map((center) {
                    return DropdownMenuItem<String>(
                      value: center,
                      child: Text(center, style: theme.textTheme.bodyMedium),
                    );
                  }).toList(),
                  onChanged: _onCenterChanged,
                ),
              ),
            ),
          ),
        ),

        // ── Selection summary chip ──────────────────────────────────────────
        if (_selectedLocation != null && _selectedCenter != null) ...[
          const SizedBox(height: 12),
          _SelectionSummary(
            governorate: _selectedLocation!.governorateAr,
            center: _selectedCenter!,
            onClear: () => setState(() {
              _selectedLocation = null;
              _selectedCenter = null;
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Row(
              children: [
                Icon(icon, size: 16, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SelectionSummary — small chip shown once both values are chosen
// ---------------------------------------------------------------------------

class _SelectionSummary extends StatelessWidget {
  final String governorate;
  final String center;
  final VoidCallback onClear;

  const _SelectionSummary({
    required this.governorate,
    required this.center,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$governorate ← $center',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Icon(Icons.close_rounded,
                size: 18,
                color: colorScheme.onPrimaryContainer.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
