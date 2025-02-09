import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  String _accessToken = '';
  List _playlists = [];
  bool _isLoading = false;
  String _error = ''; // Add error state

  // Your Spotify API credentials
  final String clientId = 'e67f0f69e90b42249f91abfc5a77b5e0';
  final String clientSecret = 'fdb910c59f8e4b209959c0fcefeb7698';

  // Updated redirect URI - must match exactly what's in Spotify Dashboard
  final String redirectUri = 'com.aura.techwizard://callback';

  Future<String> getAccessToken() async {
    try {
      final authorizationUrl = Uri.https('accounts.spotify.com', '/authorize', {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': 'user-library-read playlist-read-private',
      }).toString();

      print('Launching auth URL: $authorizationUrl'); // Debug print

      final result = await FlutterWebAuth.authenticate(
        url: authorizationUrl,
        callbackUrlScheme: 'com.aura.techwizard',
      );

      print('Got auth result: $result'); // Debug print

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        throw Exception("Authorization code not found");
      }

      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      print('Token response: ${response.body}'); // Debug print

      final jsonResponse = json.decode(response.body);
      if (jsonResponse['access_token'] != null) {
        return jsonResponse['access_token'];
      } else {
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e) {
      print('Error in getAccessToken: $e'); // Debug print
      rethrow;
    }
  }

  Future<void> fetchPlaylists(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/playlists'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Playlists response: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        setState(() {
          _playlists = json.decode(response.body)['items'];
        });
      } else {
        throw Exception('Failed to load playlists: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchPlaylists: $e'); // Debug print
      rethrow;
    }
  }

  Future<void> loginAndFetchData() async {
    setState(() {
      _isLoading = true;
      _error = ''; // Clear any previous errors
    });

    try {
      _accessToken = await getAccessToken();
      await fetchPlaylists(_accessToken);
    } catch (e) {
      print('Error in loginAndFetchData: $e');
      setState(() {
        _error = e.toString(); // Show error to user
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Playlists'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : loginAndFetchData,
              child: const Text('Login with Spotify'),
            ),
            const SizedBox(height: 20),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_playlists.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _playlists.length,
                  itemBuilder: (context, index) {
                    var playlist = _playlists[index];
                    return ListTile(
                      title: Text(playlist['name'] ?? 'Unnamed Playlist'),
                      subtitle: Text(
                        'By ${playlist['owner']?['display_name'] ?? 'Unknown'}',
                      ),
                      leading: playlist['images']?.isNotEmpty ?? false
                          ? Image.network(playlist['images'][0]['url'])
                          : const Icon(Icons.music_note),
                    );
                  },
                ),
              )
            else if (!_isLoading && _error.isEmpty)
              const Text('No playlists found.'),
          ],
        ),
      ),
    );
  }
}
