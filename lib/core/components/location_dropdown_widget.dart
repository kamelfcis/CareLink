import 'package:flutter/material.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';

// ─────────────────────────────────────────────────────────────
// Data: All 27 Egyptian Governorates with their major centers
// ─────────────────────────────────────────────────────────────
const Map<String, List<String>> kEgyptianGovernorates = {
  'القاهرة': [
    'مدينة نصر',
    'مصر الجديدة',
    'الزيتون',
    'شبرا',
    'الموسكي',
    'المعادي',
    'حلوان',
    'عين شمس',
    'التجمع الخامس',
    'مدينة بدر',
    'المطرية',
    'الوايلي',
    'المقطم',
    'دار السلام',
    'المرج',
    'الأميرية',
  ],
  'الجيزة': [
    'إمبابة',
    'الدقي',
    'الهرم',
    'العجوزة',
    'بولاق الدكرور',
    'الشيخ زايد',
    'أكتوبر',
    'الوراق',
    'الحوامدية',
    'البدرشين',
    'العياط',
    'الصف',
    'أوسيم',
  ],
  'الإسكندرية': [
    'المنتزه',
    'العجمي',
    'برج العرب',
    'الدخيلة',
    'الرمل',
    'سيدي جابر',
    'الأنفوشي',
    'المينا',
    'باب شرق',
    'سموحة',
    'ميامي',
    'لوران',
  ],
  'القليوبية': [
    'بنها',
    'شبرا الخيمة',
    'قليوب',
    'طوخ',
    'قها',
    'كفر شكر',
    'منشية القناطر',
    'الخانكة',
    'الخصوص',
  ],
  'الشرقية': [
    'الزقازيق',
    'العاشر من رمضان',
    'بلبيس',
    'منيا القمح',
    'الصالحية الجديدة',
    'أبو حماد',
    'فاقوس',
    'ههيا',
    'ميت غمر',
    'كفر صقر',
    'ديرب نجم',
    'الإبراهيمية',
  ],
  'الدقهلية': [
    'المنصورة',
    'طلخا',
    'ميت غمر',
    'دكرنس',
    'السنبلاوين',
    'بلقاس',
    'المنزلة',
    'شربين',
    'تمي الأمديد',
    'نبروه',
    'الجمالية',
    'منية النصر',
  ],
  'الغربية': [
    'طنطا',
    'المحلة الكبرى',
    'كفر الزيات',
    'زفتى',
    'السنطة',
    'بسيون',
    'سمنود',
    'قطور',
  ],
  'المنوفية': [
    'شبين الكوم',
    'مينوف',
    'أشمون',
    'الشهداء',
    'تلا',
    'السادات',
    'بركة السبع',
    'قويسنا',
  ],
  'البحيرة': [
    'دمنهور',
    'كفر الدوار',
    'رشيد',
    'الدلنجات',
    'أبو حمص',
    'إيتاي البارود',
    'حوش عيسى',
    'شبراخيت',
    'المحمودية',
    'وادي النطرون',
    'الرحمانية',
  ],
  'كفر الشيخ': [
    'كفر الشيخ',
    'دسوق',
    'فوه',
    'مطوبس',
    'بلطيم',
    'سيدي سالم',
    'الرياض',
    'بيلا',
    'الحامول',
    'قلين',
  ],
  'الإسماعيلية': [
    'الإسماعيلية',
    'فايد',
    'القنطرة',
    'أبو صوير',
    'التل الكبير',
  ],
  'بورسعيد': [
    'بورسعيد',
    'بور فؤاد',
    'الضواحي',
    'المناخ',
    'العرب',
    'الشرق',
    'الزهور',
    'الجنوب',
  ],
  'السويس': [
    'السويس',
    'عتاقة',
    'فيصل',
    'الأربعين',
    'الجناين',
  ],
  'شمال سيناء': [
    'العريش',
    'الشيخ زويد',
    'رفح',
    'بئر العبد',
    'نخل',
    'الحسنة',
  ],
  'جنوب سيناء': [
    'الطور',
    'شرم الشيخ',
    'دهب',
    'نويبع',
    'طابا',
    'سانت كاترين',
    'أبو رديس',
    'رأس سدر',
  ],
  'البحر الأحمر': [
    'الغردقة',
    'رأس غارب',
    'سفاجا',
    'القصير',
    'مرسى علم',
    'الشلاتين',
  ],
  'الوادي الجديد': [
    'الخارجة',
    'الداخلة',
    'الفرافرة',
    'باريس',
    'موط',
  ],
  'مطروح': [
    'مرسى مطروح',
    'سيوة',
    'السلوم',
    'الحمام',
    'الضبعة',
    'العلمين',
  ],
  'الأقصر': [
    'الأقصر',
    'إسنا',
    'أرمنت',
    'الطود',
    'القرنة',
    'البياضية',
  ],
  'أسوان': [
    'أسوان',
    'كوم أمبو',
    'إدفو',
    'نصر النوبة',
    'دراو',
    'الغريبي',
    'أبو سمبل',
  ],
  'قنا': [
    'قنا',
    'نجع حمادي',
    'قوص',
    'أبو تشت',
    'دشنا',
    'الوقف',
    'نقادة',
    'فرشوط',
  ],
  'سوهاج': [
    'سوهاج',
    'طهطا',
    'جرجا',
    'أخميم',
    'البلينا',
    'المراغة',
    'دار السلام',
    'طما',
    'المنشأة',
    'ساقلتة',
  ],
  'أسيوط': [
    'أسيوط',
    'ديروط',
    'منفلوط',
    'أبوتيج',
    'الغنايم',
    'القوصية',
    'ساحل سليم',
    'البداري',
    'صدفا',
  ],
  'المنيا': [
    'المنيا',
    'ملوي',
    'مطاي',
    'سمالوط',
    'المغاغة',
    'أبو قرقاص',
    'بني مزار',
    'العدوة',
    'دير مواس',
  ],
  'بني سويف': [
    'بني سويف',
    'الفيوم',
    'إهناسيا المدينة',
    'الواسطى',
    'ببا',
    'سمسطا',
    'ناصر',
    'الفاصن',
  ],
  'الفيوم': [
    'الفيوم',
    'طامية',
    'سنورس',
    'يوسف الصديق',
    'إطسا',
    'الحادقة',
  ],
  'دمياط': [
    'دمياط',
    'رأس البر',
    'الزرقا',
    'فارسكور',
    'كفر سعد',
    'عزبة البرج',
  ],
};

// ─────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────
class LocationDropdownWidget extends StatefulWidget {
  const LocationDropdownWidget({
    super.key,
    required this.onLocationSelected,
    this.initialGovernorate,
    this.initialCenter,
    this.labelStyle,
    this.dropdownDecoration,
  });

  /// Called whenever both governorate AND center are selected.
  final void Function(String governorate, String center) onLocationSelected;

  final String? initialGovernorate;
  final String? initialCenter;
  final TextStyle? labelStyle;
  final InputDecoration? dropdownDecoration;

  @override
  State<LocationDropdownWidget> createState() => _LocationDropdownWidgetState();
}

class _LocationDropdownWidgetState extends State<LocationDropdownWidget> {
  String? _selectedGovernorate;
  String? _selectedCenter;
  List<String> _centers = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialGovernorate != null &&
        kEgyptianGovernorates.containsKey(widget.initialGovernorate)) {
      _selectedGovernorate = widget.initialGovernorate;
      _centers = kEgyptianGovernorates[_selectedGovernorate!]!;
      if (widget.initialCenter != null &&
          _centers.contains(widget.initialCenter)) {
        _selectedCenter = widget.initialCenter;
      }
    }
  }

  void _onGovernorateChanged(String? value) {
    setState(() {
      _selectedGovernorate = value;
      _selectedCenter = null;
      _centers =
          value != null ? (kEgyptianGovernorates[value] ?? []) : [];
    });
  }

  void _onCenterChanged(String? value) {
    setState(() => _selectedCenter = value);
    if (_selectedGovernorate != null && value != null) {
      widget.onLocationSelected(_selectedGovernorate!, value);
    }
  }

  // ── UI helpers ──────────────────────────────────────────
  InputDecoration _fieldDecoration(String label) {
    return widget.dropdownDecoration?.copyWith(labelText: label) ??
        InputDecoration(
          labelText: label,
          labelStyle: widget.labelStyle ??
              TextStyle(color: AppColors.kPrimaryDark, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: AppColors.kPrimaryColor, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: AppColors.kPrimaryDark, width: 2),
          ),
          filled: true,
          fillColor: AppColors.kPrimaryLight.withOpacity(0.35),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Governorate dropdown ─────────────────────────────
        DropdownButtonFormField<String>(
          value: _selectedGovernorate,
          decoration: _fieldDecoration('المحافظة / Governorate'),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.kPrimaryColor),
          items: kEgyptianGovernorates.keys
              .map(
                (gov) => DropdownMenuItem<String>(
                  value: gov,
                  child: Text(
                    gov,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: _onGovernorateChanged,
          validator: (v) => v == null ? 'الرجاء اختيار المحافظة' : null,
        ),

        const SizedBox(height: 16),

        // ── Center / District dropdown ───────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _selectedGovernorate == null
              ? _DisabledDropdown(
                  key: const ValueKey('disabled'),
                  decoration: _fieldDecoration('المركز / District'),
                )
              : DropdownButtonFormField<String>(
                  key: ValueKey(_selectedGovernorate),
                  value: _selectedCenter,
                  decoration: _fieldDecoration('المركز / District'),
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.kPrimaryColor),
                  items: _centers
                      .map(
                        (center) => DropdownMenuItem<String>(
                          value: center,
                          child: Text(
                            center,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _onCenterChanged,
                  validator: (v) =>
                      v == null ? 'الرجاء اختيار المركز' : null,
                ),
        ),

        // ── Selected location chip ───────────────────────────
        if (_selectedGovernorate != null && _selectedCenter != null) ...[
          const SizedBox(height: 12),
          Chip(
            avatar: Icon(Icons.location_on,
                size: 16, color: AppColors.kPrimaryDark),
            label: Text(
              '$_selectedGovernorate – $_selectedCenter',
              style: TextStyle(
                  fontSize: 12, color: AppColors.kPrimaryDark),
            ),
            backgroundColor: AppColors.kPrimaryLight,
            side: BorderSide(color: AppColors.kPrimaryColor, width: 1),
            deleteIcon: Icon(Icons.close,
                size: 14, color: AppColors.kPrimaryDark),
            onDeleted: () {
              setState(() {
                _selectedCenter = null;
                _selectedGovernorate = null;
                _centers = [];
              });
            },
          ),
        ],
      ],
    );
  }
}

// ── Helper: greyed-out dropdown shown before governorate selected ──
class _DisabledDropdown extends StatelessWidget {
  const _DisabledDropdown({super.key, required this.decoration});
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DropdownButtonFormField<String>(
        value: null,
        decoration: decoration.copyWith(
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        items: const [],
        onChanged: null,
        hint: const Text(
          'اختر المحافظة أولاً',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }
}
