import 'package:flutter/material.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  // **CHANGE HERE: Accept a Map object instead of a String**
  final Map<String, dynamic> user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // The list of pages is now defined in initState to access user data
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // **CHANGE HERE: Initialize the list of pages with user data**
    _widgetOptions = <Widget>[
      const _HomeTabContent(),
      const ExploreScreen(),
      ProfileScreen(user: widget.user), // Pass user data to ProfileScreen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> appBarTitles = [
      // **CHANGE HERE: Access username from the user map**
      'Welcome, ${widget.user["username"]}',
      'Explore',
      'Profile',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[_selectedIndex]),
        actions: [
          if (_selectedIndex == 2)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// _HomeTabContent widget remains unchanged
class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent();

  static const List<String> _fruitOptions = <String>[
    'Apple', 'Banana', 'Orange', 'Pineapple', 'Watermelon', 'Grapes', 'Mango',
    'Strawberry', 'Blueberry', 'Raspberry', 'Kiwi'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return _fruitOptions;
          }
          return _fruitOptions.where((String option) {
            return option.toLowerCase().startsWith(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          debugPrint('You just selected $selection');
          FocusScope.of(context).unfocus();
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Search fruits...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          );
        },
      ),
    );
  }
}