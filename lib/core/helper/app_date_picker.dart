import 'package:flutter/material.dart';

/// Strip time from [d] for calendar comparisons.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Opens [showDatePicker] with [firstDate] / [lastDate] bounds.
/// When [selected] is null, the calendar opens on **today** ([initialDate] defaults to now).
/// [selected] is clamped into range when provided.
Future<DateTime?> pickDateWithDefaultToday(
  BuildContext context, {
  DateTime? selected,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final first = dateOnly(firstDate ?? DateTime(2000));
  final last = dateOnly(lastDate ?? DateTime(2100, 12, 31));
  final today = dateOnly(DateTime.now());

  var initial = selected != null ? dateOnly(selected) : today;
  if (initial.isBefore(first)) {
    initial = first;
  }
  if (initial.isAfter(last)) {
    initial = last;
  }

  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: first,
    lastDate: last,
  );
}
