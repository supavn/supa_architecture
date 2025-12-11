part of "filters.dart";

/// A class representing a filter for tenants.
///
/// This class extends [DataFilter] and provides a list of filter fields
/// for tenants.
class TenantFilter extends DataFilter {
  /// List of filter fields for tenants.
  ///
  /// Currently, this list is empty, but it can be extended to include
  /// specific filter criteria for tenants.
  @override
  List<FilterField> get fields => [];
}
