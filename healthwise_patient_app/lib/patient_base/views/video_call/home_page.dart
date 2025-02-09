import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/patient_base/views/video_call/settings/settings.dart';
import 'package:healthwise_patient_app/patient_base/views/video_call/video_conference_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController conferenceDTextCtrl =
      TextEditingController(text: 'video_conference_id');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const SettingsDrawer(),
      appBar: AppBar(
        title: const Text(
          'Join Video Conference',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter Conference ID',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: conferenceDTextCtrl,
              decoration: InputDecoration(
                hintText: 'Enter conference ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoConferencePage(
                      conferenceID: conferenceDTextCtrl.text.trim(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Join Conference'),
            ),
          ],
        ),
      ),
    );
  }
}
