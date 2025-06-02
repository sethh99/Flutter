import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // New: To keep track of the selected tab index

  // New: List of widgets to display for each tab
  static final List<Widget> _widgetOptions = <Widget>[
    const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            'Welcome to home screen - Tab 1',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Add more content specific to Tab 1 here
        ],
      ),
    ),
    const Center(
      child: Text(
        'Explore Screen - Tab 2',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    const Center(
      child: Text(
        'Profile Screen - Tab 3',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  // New: Function to handle tab taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
          )
        ],
      ),
      // New: Display the currently selected tab's content
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Highlight the currently selected tab
        selectedItemColor: Colors.amber[800], // Color for the selected icon/label
        onTap: _onItemTapped, // Call the function when a tab is tapped
      ),
    );
  }
}

// Custom SearchDelegate (remains the same)
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
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(results[index]),
        onTap: () {
          close(context, results[index]); // Close search and return result
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = data.where((item) => item.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestions[index]),
        onTap: () {
          query = suggestions[index];
          showResults(context); // Show results based on selected suggestion
        },
      ),
    );
  }
}