import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_model.dart';
import 'package:care_link/features/auth/sign_up_as_doctor/models/doctor_specialty_model.dart';
import 'package:care_link/features/auth/sign_in/models/user_model.dart';

// ─────────────────────────────────────────────────────────────
// Extended doctor model that carries location + rating fields
// returned by the search queries.
// ─────────────────────────────────────────────────────────────
class DoctorSearchResult {
  final DoctorModel doctor;
  final double? avgRating;
  final int totalReviews;
  final String? governorate;
  final String? center;
  final double? latitude;
  final double? longitude;
  /// Calculated in-memory by the service when the user's position is provided.
  double? distanceKm;

  DoctorSearchResult({
    required this.doctor,
    this.avgRating,
    this.totalReviews = 0,
    this.governorate,
    this.center,
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  factory DoctorSearchResult.fromJson(Map<String, dynamic> json) {
    return DoctorSearchResult(
      doctor: DoctorModel.fromJson(json),
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      governorate: json['governorate'] as String?,
      center: json['center'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Filter parameters – all fields are optional.
// ─────────────────────────────────────────────────────────────
class DoctorSearchFilter {
  /// Free-text search on doctor name or specialty.
  final String? query;

  /// Only return doctors with avgRating >= this value (1–5).
  final double? minRating;

  /// Match governorate exactly (Arabic or English string).
  final String? governorate;

  /// Match center/district exactly.
  final String? center;

  /// User's current latitude – required for distance filtering.
  final double? userLatitude;

  /// User's current longitude – required for distance filtering.
  final double? userLongitude;

  /// Maximum distance in kilometres. Only applied when [userLatitude]
  /// and [userLongitude] are both provided.
  final double? maxDistanceKm;

  /// Maximum number of results (default 50).
  final int limit;

  /// Offset for pagination (default 0).
  final int offset;

  const DoctorSearchFilter({
    this.query,
    this.minRating,
    this.governorate,
    this.center,
    this.userLatitude,
    this.userLongitude,
    this.maxDistanceKm,
    this.limit = 50,
    this.offset = 0,
  });
}

// ─────────────────────────────────────────────────────────────
// SearchFilterService
// ─────────────────────────────────────────────────────────────
class SearchFilterService {
  SearchFilterService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  // ── Haversine distance formula ────────────────────────────
  static double _haversineKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _toRad(double deg) => deg * math.pi / 180;

  // ─────────────────────────────────────────────────────────
  /// Search and filter doctors.
  ///
  /// Strategy:
  ///  1. Build a Supabase query filtering by governorate / center /
  ///     name+specialty on the DB side.
  ///  2. Fetch avgRating from the `doctor_avg_rating` view via a
  ///     joined select (or a second query if the view isn't joinable).
  ///  3. Apply rating and distance filters in Dart for maximum
  ///     flexibility (avoids complex SQL for distance).
  // ─────────────────────────────────────────────────────────
  Future<List<DoctorSearchResult>> searchDoctors(
    DoctorSearchFilter filter,
  ) async {
    // ── 1. Build base query ──────────────────────────────────
    // We select doctors joined with users, specialties and the
    // avg-rating view. Adjust column names if your schema differs.
    var query = _client
        .from('doctors')
        .select('''
          id,
          bio,
          hospital,
          governorate,
          center,
          latitude,
          longitude,
          users!inner(id, name, email, image, phone, role),
          doctor_specialties!inner(id, name, description, icon, is_active, created_at),
          doctor_avg_rating(avg_rating, total_reviews)
        ''');

    // ── 2. Server-side filters ───────────────────────────────
    if (filter.governorate != null && filter.governorate!.isNotEmpty) {
      query = query.eq('governorate', filter.governorate!);
    }
    if (filter.center != null && filter.center!.isNotEmpty) {
      query = query.eq('center', filter.center!);
    }
    if (filter.query != null && filter.query!.isNotEmpty) {
      // Search doctor name via the joined users table, or specialty name.
      // Supabase PostgREST doesn't support OR across joined tables in one
      // filter, so we do a text search on the specialty name here and
      // also filter by name in Dart below for the cross-table OR.
      query = query.ilike(
        'doctor_specialties.name',
        '%${filter.query}%',
      );
    }

    // ── 3. Pagination ────────────────────────────────────────
    query = query.range(filter.offset, filter.offset + filter.limit - 1);

    // ── 4. Execute ───────────────────────────────────────────
    final response = await query;
    final List<dynamic> rows = response as List<dynamic>;

    // ── 5. Map to DoctorSearchResult ─────────────────────────
    List<DoctorSearchResult> results = rows
        .map((row) {
          try {
            final map = Map<String, dynamic>.from(row as Map);
            // Flatten the avg_rating view join
            final ratingRow = map['doctor_avg_rating'];
            if (ratingRow is List && ratingRow.isNotEmpty) {
              map['avg_rating'] = ratingRow.first['avg_rating'];
              map['total_reviews'] = ratingRow.first['total_reviews'];
            } else if (ratingRow is Map) {
              map['avg_rating'] = ratingRow['avg_rating'];
              map['total_reviews'] = ratingRow['total_reviews'];
            }
            return DoctorSearchResult.fromJson(map);
          } catch (_) {
            return null;
          }
        })
        .whereType<DoctorSearchResult>()
        .toList();

    // ── 6. In-memory: filter by doctor name (cross-table OR) ─
    if (filter.query != null && filter.query!.isNotEmpty) {
      final q = filter.query!.toLowerCase();
      results = results.where((r) {
        final name = r.doctor.doctor?.name.toLowerCase() ?? '';
        final specialty = r.doctor.specialty.name.toLowerCase();
        return name.contains(q) || specialty.contains(q);
      }).toList();
    }

    // ── 7. In-memory: filter by minimum rating ───────────────
    if (filter.minRating != null) {
      results = results
          .where((r) => (r.avgRating ?? 0) >= filter.minRating!)
          .toList();
    }

    // ── 8. In-memory: calculate distance + filter ────────────
    final hasPosition =
        filter.userLatitude != null && filter.userLongitude != null;
    if (hasPosition) {
      for (final result in results) {
        if (result.latitude != null && result.longitude != null) {
          result.distanceKm = _haversineKm(
            filter.userLatitude!,
            filter.userLongitude!,
            result.latitude!,
            result.longitude!,
          );
        }
      }
      if (filter.maxDistanceKm != null) {
        results = results
            .where((r) =>
                r.distanceKm == null ||
                r.distanceKm! <= filter.maxDistanceKm!)
            .toList();
      }
      // Sort by distance ascending when position is known
      results.sort((a, b) {
        final da = a.distanceKm ?? double.infinity;
        final db = b.distanceKm ?? double.infinity;
        return da.compareTo(db);
      });
    }

    return results;
  }

  // ─────────────────────────────────────────────────────────
  /// Convenience: fetch a single doctor's average rating.
  // ─────────────────────────────────────────────────────────
  Future<({double avgRating, int totalReviews})> getDoctorRating(
    String doctorId,
  ) async {
    final response = await _client
        .from('doctor_avg_rating')
        .select('avg_rating, total_reviews')
        .eq('doctor_id', doctorId)
        .maybeSingle();

    if (response == null) return (avgRating: 0.0, totalReviews: 0);
    return (
      avgRating: (response['avg_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (response['total_reviews'] as num?)?.toInt() ?? 0,
    );
  }

  // ─────────────────────────────────────────────────────────
  /// Fetch all governorates that have at least one doctor
  /// (useful for populating a filter chip list).
  // ─────────────────────────────────────────────────────────
  Future<List<String>> getAvailableGovernorates() async {
    final response = await _client
        .from('doctors')
        .select('governorate')
        .not('governorate', 'is', null);

    final List<dynamic> rows = response as List<dynamic>;
    final Set<String> governorates = rows
        .map((r) => r['governorate'] as String? ?? '')
        .where((g) => g.isNotEmpty)
        .toSet();
    return governorates.toList()..sort();
  }
}
