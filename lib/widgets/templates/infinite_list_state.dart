import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supa_architecture/supa_architecture.dart';
import 'package:supa_carbon_icons/supa_carbon_icons.dart';

/// An abstract state class that provides infinite scroll list functionality.
///
/// This template class implements a complete infinite scroll list with:
/// - Pagination support using [PagingController]
/// - Search functionality with animated search bar
/// - Filter support with optional filter form
/// - Pull-to-refresh capability
/// - Error handling including 403 forbidden state
/// - Empty state display
/// - Loading indicators
///
/// Subclasses must implement:
/// - [filter]: The data filter instance
/// - [title]: The page title
/// - [repository]: The repository for fetching data
/// - [itemRender]: Method to render each list item
/// - [onIndexChange]: Handler for index changes
///
/// **Usage:**
/// ```dart
/// class MyListPageState extends InfiniteListState<MyModel, MyFilter, MyListPage> {
///   @override
///   MyFilter filter = MyFilter();
///
///   @override
///   String get title => 'My List';
///
///   @override
///   BaseRepository<MyModel, MyFilter> get repository => myRepository;
///
///   @override
///   Widget itemRender(BuildContext context, MyModel item, int index) {
///     return ListTile(title: Text(item.name));
///   }
///
///   @override
///   void onIndexChange() {
///     // Handle index change
///   }
/// }
/// ```
abstract class InfiniteListState<T extends JsonModel, TF extends DataFilter,
    TW extends StatefulWidget> extends State<TW> {
  /// Focus node for the search text field.
  final searchFocus = FocusNode();

  /// Text editing controller for the search input.
  final searchController = TextEditingController();

  /// Paging controller that manages pagination state and data loading.
  final PagingController<int, T> pagingController = PagingController<int, T>(
    firstPageKey: 0,
  );

  /// The data filter instance used for querying data.
  ///
  /// Must be implemented by subclasses to provide the specific filter type.
  abstract TF filter;

  /// The title to display in the app bar.
  ///
  /// Must be implemented by subclasses.
  String get title;

  /// The repository used to fetch and count data.
  ///
  /// Must be implemented by subclasses to provide the specific repository.
  BaseRepository<T, TF> get repository;

  /// Shows the filter form dialog or bottom sheet.
  ///
  /// Must be implemented by subclasses to provide filter UI.
  /// Default implementation throws [UnimplementedError].
  Future<void> showFilterForm() async {
    throw UnimplementedError();
  }

  /// Whether the search bar is currently active.
  bool isSearching = false;

  /// The total count of items available (before pagination).
  int total = 0;

  /// Whether the current user is forbidden from accessing this list.
  ///
  /// Set to true when a 403 Forbidden response is received.
  bool isForbidden = false;

  /// Renders a single list item.
  ///
  /// Must be implemented by subclasses to provide item-specific rendering.
  ///
  /// **Parameters:**
  /// - `context`: The build context.
  /// - `item`: The data item to render.
  /// - `index`: The index of the item in the list.
  Widget itemRender(BuildContext context, T item, int index);

  /// Renders the filter UI above the list.
  ///
  /// Override this method to provide custom filter rendering.
  /// Default implementation returns an empty widget.
  Widget filterRender() {
    return const SizedBox.shrink();
  }

  /// Renders the item count display.
  ///
  /// Override this method to display the total count of items.
  /// Default implementation returns an empty widget.
  ///
  /// **Parameters:**
  /// - `count`: The total number of items.
  Widget countRender(num count) {
    return const SizedBox.shrink();
  }

  /// Handler called when the list index changes.
  ///
  /// Must be implemented by subclasses to handle index changes.
  void onIndexChange() {
    throw UnimplementedError();
  }

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener(handlePageRequest);
  }

  /// Resets the list to the first page and clears all loaded items.
  ///
  /// This method resets the filter skip value, clears the paging controller,
  /// and reloads the first page of data.
  Future<void> reset() async {
    filter.skip = 0;
    pagingController.nextPageKey = filter.skip;
    pagingController.itemList = [];
    await handlePageRequest(filter.skip);
  }

  @override
  void dispose() {
    pagingController.dispose();
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  /// Gets the current list of loaded items.
  List<T> get list {
    return pagingController.itemList!;
  }

  /// Clears the current filter and refreshes the list.
  void clearFilter() {
    pagingController.refresh();
  }

  /// Forces a UI rebuild by calling setState.
  void reloadUI() {
    setState(() {});
  }

  /// Handles search query input and refreshes the list.
  ///
  /// **Parameters:**
  /// - `query`: The search query string. If empty, no action is taken.
  void onSearch(String query) {
    if (query != '') {
      setState(() {
        filter.skip = 0;
        filter.search = query;
      });
      pagingController.refresh();
    }
  }

  /// Toggles the search bar visibility.
  ///
  /// If search is active, it clears the search query and refreshes the list.
  /// If search is inactive, it activates search mode and requests focus.
  void toggleSearch() {
    if (isSearching) {
      searchController.text = '';

      isSearching = false;
      filter.search = '';
      filter.skip = 0;

      pagingController.refresh();
      return;
    }

    setState(() {
      isSearching = true;
      searchFocus.requestFocus();
    });
  }

  /// Handles pagination requests by fetching data for the specified page.
  ///
  /// This method fetches both the list of items and the total count,
  /// then updates the paging controller accordingly. It also handles
  /// errors, including 403 Forbidden responses.
  ///
  /// **Parameters:**
  /// - `pageKey`: The page key (typically the skip/offset value) to fetch.
  Future<void> handlePageRequest(int pageKey) async {
    filter.skip = pageKey;

    await Future.wait([
      repository.list(filter),
      repository.count(filter),
    ]).then((values) {
      final list = values[0] as List<T>;
      final count = values[1] as int;

      if (mounted) {
        setState(() {
          total = count;

          if (pagingController.isLastPage(filter, list, count)) {
            pagingController.appendLastPage(list);
            return;
          }

          pagingController.appendPage(list, filter.skip + list.length);
        });
      }
    }).catchError((error) {
      debugPrint('Có lỗi xảy ra');

      if (mounted) {
        pagingController.error(error);
        if (error is DioException) {
          if (error.response?.statusCode == 403) {
            setState(() {
              isForbidden = true;
            });
            return;
          }
        }
      }
    });
  }

  /// Refreshes the list by resetting to the first page and reloading data.
  Future<void> refresh() async {
    filter.skip = 0;
    pagingController.refresh();
  }

  /// Whether to show the filter button in the app bar.
  ///
  /// Override this getter to control filter button visibility.
  /// Defaults to true.
  bool get shouldShowFilterButton => true;

  /// Whether to show the create button (floating action button).
  ///
  /// Override this getter to control create button visibility.
  /// Defaults to false.
  bool get shouldShowCreateButton => false;

  /// Handler called when the create button is pressed.
  ///
  /// Override this method to implement create functionality.
  /// Default implementation does nothing.
  FutureOr<void> onCreate() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isForbidden) {
      return const PageForbidden();
    }

    final searchAction = Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 16,
      ),
      child: IconButton(
        onPressed: toggleSearch,
        icon: Icon(isSearching ? CarbonIcons.close : CarbonIcons.search),
      ),
    );

    final searchTitle = SearchableAppBarTitle(
      searchHint: 'Tìm kiếm...',
      isSearching: isSearching,
      onSubmitted: onSearch,
      searchController: searchController,
      searchFocus: searchFocus,
      title: title,
    );

    final backButton = Navigator.canPop(context) ? const GoBackButton() : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: backButton,
        title: searchTitle,
        actions: [
          if (!isSearching && shouldShowFilterButton)
            IconButton(
              icon: const Icon(CarbonIcons.filter),
              onPressed: () async {
                showFilterForm();
              },
            ),
          searchAction,
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: Column(
              children: [
                filterRender(),
                countRender(total),
                Expanded(
                  child: PagedListView<int, T>(
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: itemRender,
                      firstPageProgressIndicatorBuilder:
                          buildFirstPageProgressIndicator,
                      newPageProgressIndicatorBuilder:
                          buildNewPageProgressIndicator,
                      noItemsFoundIndicatorBuilder: buildEmptyListIndicator,
                      newPageErrorIndicatorBuilder:
                          buildNextPageErrorPageIndicator,
                      firstPageErrorIndicatorBuilder:
                          buildFirstPageErrorPageIndicator,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: shouldShowCreateButton
          ? FloatingActionButton(
              onPressed: onCreate,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              child: const Icon(CarbonIcons.add),
            )
          : null,
    );
  }

  /// Builds the progress indicator shown while loading the first page.
  ///
  /// Override this method to customize the first page loading indicator.
  Widget buildFirstPageProgressIndicator(BuildContext context) {
    return const LoadingIndicator();
  }

  /// Builds the progress indicator shown while loading subsequent pages.
  ///
  /// Override this method to customize the new page loading indicator.
  Widget buildNewPageProgressIndicator(BuildContext context) {
    return const LoadingIndicator();
  }

  /// Builds the indicator shown when the list is empty.
  ///
  /// Override this method to customize the empty list indicator.
  Widget buildEmptyListIndicator(BuildContext context) {
    return const EmptyComponent(
      title: 'Chưa có dữ liệu',
    );
  }

  /// Builds the error indicator shown when loading a subsequent page fails.
  ///
  /// Override this method to customize the next page error indicator.
  Widget buildNextPageErrorPageIndicator(BuildContext context) {
    return const Center(
      child: Text('Có lỗi xảy ra'),
    );
  }

  /// Builds the error indicator shown when loading the first page fails.
  ///
  /// Override this method to customize the first page error indicator.
  Widget buildFirstPageErrorPageIndicator(BuildContext context) {
    return const Center(
      child: Text('Có lỗi xảy ra'),
    );
  }

  /// Builds the indicator shown when no items are found.
  ///
  /// Override this method to customize the no items found indicator.
  Widget noItemsFoundIndicatorBuilder(BuildContext context) {
    return const EmptyComponent(
      title: 'Không có dữ liệu',
    );
  }

  /// Activates the search bar by setting [isSearching] to true.
  void showSearchBar() => setState(() => isSearching = true);

  /// Cancels the search by clearing the search query and deactivating search mode.
  ///
  /// This method clears the search controller, resets the filter search value,
  /// and refreshes the list to show all items.
  void cancelSearchBar() {
    searchController.clear();
    setState(() {
      isSearching = false;
      filter.search = '';
      filter.skip = 0;
    });
    pagingController.refresh();
  }
}
