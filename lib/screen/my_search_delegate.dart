import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate<String> {
  final List<String> data = [
    'Apple',
    'Banana',
    'Orange',
    'Pineapple',
    'Watermelon',
    'Grapes',
    'Mango',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // 'Clear' button on the right
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          // When query is cleared, show all suggestions again
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // 'Back' button on the left
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    // This view is shown when a user presses 'enter' or a search action
    // It uses .contains() for a broader search (e.g., 'pl' finds 'Apple' and 'Pineapple')
    final results = data.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(results[index]),
        onTap: () {
          close(context, results[index]);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This is the primary view that shows the "drop down" list
    // It's shown immediately and updates as the user types.

    // Filter the list based on the user's query
    final suggestions = data.where((item) {
      final itemLower = item.toLowerCase();
      final queryLower = query.toLowerCase();

      // This is the key logic: find all items that START WITH the query
      return itemLower.startsWith(queryLower);
    }).toList();

    // If the query is empty, item.startsWith('') is always true, so it returns all items.
    // This is why the full list "drops down" when you first click the search bar.

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestions[index]),
        onTap: () {
          query = suggestions[index];
          // When a suggestion is tapped, show the results view for it
          showResults(context);
        },
      ),
    );
  }
}