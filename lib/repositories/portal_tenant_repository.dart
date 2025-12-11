import "package:supa_architecture/api_client/api_client.dart";
import "package:supa_architecture/filters/filters.dart";
import "package:supa_architecture/models/models.dart";
import "package:supa_architecture/repositories/base_repository.dart";

/// A repository class for managing tenants.
///
/// This class extends [BaseRepository] and provides methods for listing and
/// counting tenants based on the provided filters.
class PortalTenantRepository extends BaseRepository<Tenant, TenantFilter> {
  @override
  String get baseUrl => Uri.parse(persistentStorage.baseApiUrl)
      .replace(path: "/rpc/portal/mobile/authentication")
      .toString();

  /// Lists tenants based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [TenantFilter] to filter the list of tenants.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant]s.
  @override
  Future<List<Tenant>> list(TenantFilter filter) async {
    return dio
        .post(
          "/list-tenant",
          data: filter.toJson(),
        )
        .then(
          (response) => response.bodyAsList<Tenant>(),
        );
  }

  /// Counts tenants based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [TenantFilter] to filter the tenants.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the count of tenants.
  @override
  Future<int> count(TenantFilter filter) async {
    return dio
        .post(
          "/count-tenant",
          data: filter.toJson(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }
}
