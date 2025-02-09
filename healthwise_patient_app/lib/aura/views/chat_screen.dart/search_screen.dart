
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_methods.dart';
import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchResults;

  void searchUsers(String query) async {
    setState(() {
      isLoading = true;
    });
    
    searchResults = await ChatMethods().searchUsers(query);
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search users...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => searchUsers(_searchController.text),
                ),
              ),
              onFieldSubmitted: searchUsers,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults == null
                    ? const Center(child: Text('Search for users'))
                    : ListView.builder(
                        itemCount: searchResults!.docs.length,
                        itemBuilder: (context, index) {
                          var userData = searchResults!.docs[index].data() as Map<String, dynamic>;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(userData['photoUrl']),
                            ),
                            title: Text(userData['username']),
                            subtitle: Text(userData['fullname']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    userId: userData['uid'],
                                    username: userData['username'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}