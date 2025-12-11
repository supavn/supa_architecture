import 'package:flutter/material.dart';

/// A widget that provides a searchable app bar title with animated transitions.
///
/// This widget can switch between displaying a title and a search text field
/// with smooth animations. It's commonly used in app bars where users can
/// toggle between viewing the title and searching for content.
///
/// **Usage:**
/// ```dart
/// SearchableAppBarTitle(
///   isSearching: isSearching,
///   searchController: searchController,
///   searchFocus: searchFocus,
///   onSubmitted: (query) {
///     // Handle search query
///   },
///   title: 'My Page',
///   searchHint: 'Search...',
/// )
/// ```
class SearchableAppBarTitle extends StatelessWidget {
  /// Whether the widget is currently in search mode.
  ///
  /// When true, displays a search text field. When false, displays the title.
  final bool isSearching;

  /// The text editing controller for the search field.
  final TextEditingController searchController;

  /// The focus node for the search text field.
  ///
  /// Used to programmatically control focus on the search field.
  final FocusNode searchFocus;

  /// Callback function called when the search query changes.
  ///
  /// The current search query string is passed as a parameter.
  final Function(String) onSubmitted;

  /// The title text to display when not in search mode.
  final String title;

  /// The hint text displayed in the search field when it's empty.
  final String searchHint;

  /// Creates a [SearchableAppBarTitle] widget.
  ///
  /// **Parameters:**
  /// - `isSearching`: Whether the widget is in search mode (required).
  /// - `searchController`: Text editing controller for the search field (required).
  /// - `searchFocus`: Focus node for the search field (required).
  /// - `onSubmitted`: Callback function called when search query changes (required).
  /// - `title`: The title text to display when not searching (required).
  /// - `searchHint`: The hint text for the search field (required).
  const SearchableAppBarTitle({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.searchFocus,
    required this.onSubmitted,
    required this.title,
    required this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: isSearching
          ? TextFormField(
              key: const ValueKey('searchField'),
              focusNode: searchFocus,
              controller: searchController,
              onChanged: onSubmitted,
              decoration: InputDecoration(
                hintText: searchHint,
                border: InputBorder.none,
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            )
          : Row(
              key: const ValueKey('titleRow'),
              children: [
                Expanded(
                  child: Text(
                    title, // Replace with your desired title text
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20, // Adjust the font size as needed
                      fontWeight:
                          FontWeight.bold, // Adjust the font weight as needed
                      color: Colors.black, // Adjust the color as needed
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
