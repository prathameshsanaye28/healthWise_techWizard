import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import "package:image_picker/image_picker.dart";

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final TextEditingController _thoughtsController = TextEditingController();
  final TextEditingController _textController =
      TextEditingController(); // Add this
  final List<String> messages = []; // Add this
  final List<MoodboardItem> _moodboardImages = [];
  final List<JournalEntry> _journalEntries = [];
  String _selectedFont = 'Roboto';
  double _fontSize = 16.0;
  Color _textColor = Colors.black;

  final Gemini gemini = Gemini.instance;
  String _lastAnalyzedMood = '';

  final List<String> _availableFonts = [
    'Roboto',
    'Lato',
    'OpenSans',
    'Montserrat',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _thoughtsController.text = prefs.getString('thoughts') ?? '';
      _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _textColor = Color(prefs.getInt('textColor') ?? Colors.black.value);

      // Load moodboard items
      final moodboardData = prefs.getStringList('moodboard') ?? [];
      _moodboardImages.clear();
      for (var item in moodboardData) {
        final parts = item.split('|');
        if (parts.length == 2) {
          _moodboardImages.add(MoodboardItem(
            imagePath: parts[0],
            caption: parts[1],
          ));
        }
      }

      // Load journal entries
      final journalData = prefs.getStringList('journal') ?? [];
      _journalEntries.clear();
      for (var entry in journalData) {
        final parts = entry.split('|||');
        if (parts.length == 4) {
          _journalEntries.add(JournalEntry(
            title: parts[0],
            content: parts[1],
            dateTime: DateTime.parse(parts[2]),
            mood: parts[3],
          ));
        }
      }
    });
  }

  Future<String> _analyzeMood(String text) async {
    try {
      final prompt =
          'Analyze the mood of the user in 1 word from happy, sad, calm, content, angry, anxious, without any tables or graphics, if this is the text they are writing: $text';
      String mood = '';

      await for (var event in gemini.streamGenerateContent(prompt)) {
        final response =
            event.content?.parts?.map((part) => part.text).join(" ") ??
                "neutral";
        mood = response.trim().toLowerCase();
        print("Gemini Mood Analysis: $mood");
      }

      return mood;
    } catch (e) {
      print("Error analyzing mood: $e");
      return 'neutral';
    }
  }

  void _saveData() async {
    // Analyze mood before saving
    _lastAnalyzedMood = await _analyzeMood(_thoughtsController.text);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('thoughts', _thoughtsController.text);
    await prefs.setString('selectedFont', _selectedFont);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setInt('textColor', _textColor.value);

    // Save moodboard items
    final moodboardData = _moodboardImages
        .map((item) => '${item.imagePath}|${item.caption}')
        .toList();
    await prefs.setStringList('moodboard', moodboardData);

    // Save journal entries
    final journalData = _journalEntries
        .map((entry) =>
            '${entry.title}|||${entry.content}|||${entry.dateTime.toIso8601String()}|||${entry.mood}')
        .toList();
    await prefs.setStringList('journal', journalData);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('$_lastAnalyzedMood'),
    //     backgroundColor: const Color.fromARGB(255, 186, 228, 148),
    //   ),
    // );
  }

  void _showTextCustomization() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customize Text'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: _selectedFont,
                  items: _availableFonts.map((font) {
                    return DropdownMenuItem(
                      value: font,
                      child: Text(font),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedFont = value!);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Font Size'),
                Slider(
                  value: _fontSize,
                  min: 12,
                  max: 24,
                  divisions: 12,
                  label: _fontSize.round().toString(),
                  onChanged: (value) {
                    setState(() => _fontSize = value);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Text Color'),
                const SizedBox(height: 8),
                SimpleColorPicker(
                  selectedColor: _textColor,
                  onColorChanged: (color) {
                    setState(() => _textColor = color);
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
              _saveData();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _textColor,
            onColorChanged: (color) {
              setState(() => _textColor = color);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _addToMoodboard() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Moodboard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 800,
                  maxHeight: 800,
                );

                if (image != null) {
                  _showMoodboardCaptionDialog(image.path, false);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.mood),
              title: const Text('Choose Preset Mood'),
              onTap: () {
                Navigator.pop(context);
                _showPresetMoodDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPresetMoodDialog() {
    final presetMoods = {
      'Happy': Icons.sentiment_very_satisfied,
      'Sad': Icons.sentiment_very_dissatisfied,
      'Excited': Icons.celebration,
      'Peaceful': Icons.spa,
      'Energetic': Icons.flash_on,
      'Tired': Icons.bedtime,
      'Creative': Icons.palette,
      'Focused': Icons.track_changes,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Mood'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: presetMoods.length,
            itemBuilder: (context, index) {
              final entry = presetMoods.entries.elementAt(index);
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _showMoodboardCaptionDialog(entry.key, true);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(entry.value, color: Colors.pink.shade300),
                      const SizedBox(height: 4),
                      Text(
                        entry.key,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

// Add this method to show caption dialog
  void _showMoodboardCaptionDialog(String imagePath, bool isAsset) {
    final captionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Caption'),
        content: TextField(
          controller: captionController,
          decoration: const InputDecoration(
            labelText: 'Caption',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _moodboardImages.add(MoodboardItem(
                  imagePath: imagePath,
                  caption: captionController.text,
                  isAsset: isAsset,
                ));
              });
              Navigator.pop(context);
              _saveData();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.split('.').first) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_very_dissatisfied;
      case 'excited':
        return Icons.celebration;
      case 'peaceful':
        return Icons.spa;
      case 'energetic':
        return Icons.flash_on;
      case 'tired':
        return Icons.bedtime;
      case 'creative':
        return Icons.palette;
      case 'focused':
        return Icons.track_changes;
      default:
        return Icons.emoji_emotions;
    }
  }

  String getActivity(String? analyzedMood) {
    if (analyzedMood == null) return 'Your joy is contagious! Keep shining!';
    switch (analyzedMood.toLowerCase()) {
      case 'happy':
        return 'Your joy is contagious! Keep shining!';
      case 'content':
      case 'calm':
        return 'Everyday is so beautiful.';
      case 'sad':
        return 'Had a bad day? :(';
      case 'angry':
        return 'Let us take a deep breath.';
      case 'anxious':
        return 'One step at a time, one step at a time.';
      default:
        return 'Your joy is contagious! Keep shining!';
    }
  }

  void _addJournalEntry() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final contentController = TextEditingController();
        String selectedMood = 'happy';

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('New Journal Entry'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<String>(
                    future: contentController.text.isNotEmpty
                        ? _analyzeMood(contentController.text)
                        : Future.value('happy'),
                    builder: (context, snapshot) {
                      selectedMood = snapshot.data ?? 'happy';
                      return DropdownButton<String>(
                        value: selectedMood,
                        items: ['happy', 'sad', 'excited', 'peaceful']
                            .map((mood) => DropdownMenuItem(
                                  value: mood,
                                  child: Row(
                                    children: [
                                      Icon(_getMoodIcon('$mood.png')),
                                      const SizedBox(width: 8),
                                      Text(mood.toUpperCase()),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedMood = value!);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Analyze mood before saving
                  final analyzedMood =
                      await _analyzeMood(contentController.text);
                  final printString = getActivity(analyzedMood);
                  print(printString);
                  setState(() {
                    _journalEntries.add(JournalEntry(
                      title: titleController.text,
                      content: contentController.text,
                      dateTime: DateTime.now(),
                      mood: analyzedMood,
                    ));
                  });
                  Navigator.pop(context);
                  _saveData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(printString),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editJournalEntry(int index) {
    final entry = _journalEntries[index];
    final titleController = TextEditingController(text: entry.title);
    final contentController = TextEditingController(text: entry.content);
    String selectedMood = entry.mood;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Journal Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedMood,
                  items: ['happy', 'sad', 'excited', 'peaceful']
                      .map((mood) => DropdownMenuItem(
                            value: mood,
                            child: Row(
                              children: [
                                Icon(_getMoodIcon('$mood.png')),
                                const SizedBox(width: 8),
                                Text(mood.toUpperCase()),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedMood = value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _journalEntries[index] = JournalEntry(
                    title: titleController.text,
                    content: contentController.text,
                    dateTime: DateTime.now(),
                    mood: selectedMood,
                  );
                });
                Navigator.pop(context);
                _saveData();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final userMessage = _textController.text.trim();
    print(userMessage);
    if (userMessage.isEmpty) return;

    // Display the user message
    setState(() {
      messages.insert(0, "User: $userMessage");
    });

    _textController.clear();
    final userPrompt =
        'analyse the mood of the user in 1 word from happy, sad, calm, content, angry, anxious, without any tables or graphics, if this is the text they are writing in journal: $userMessage.';
    // Send the message to Gemini and print the response in the terminal
    _getGeminiResponse(userPrompt);
  }

  void _getGeminiResponse(String userMessage) async {
    try {
      await for (var event in gemini.streamGenerateContent(userMessage)) {
        final responseText =
            event.content?.parts?.map((part) => part.text).join(" ") ??
                "No response available";

        // Print the Gemini response to the terminal
        print("Gemini: $responseText");

        // // Optionally add Gemini's response to the chat screen
        // setState(() {
        //   messages.insert(0, "Gemini: $responseText");
        // });
      }
    } catch (e) {
      print("Error fetching response: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Personal Diary'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: _showTextCustomization,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let your thoughts flow...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _thoughtsController,
                maxLines: 5,
                style: TextStyle(
                  fontFamily: _selectedFont,
                  fontSize: _fontSize,
                  color: _textColor,
                ),
                decoration: const InputDecoration(
                  hintText: 'Write here...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //     VoiceInputWidget(
                //   onTextRecognized: (text) {
                //     setState(() {
                //       _thoughtsController.text = text;
                //     });
                //   },
                // ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _saveData,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 248, 169, 195),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Moodboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addToMoodboard,
                ),
              ],
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _moodboardImages.isEmpty
                  ? const Center(
                      child: Text(
                        'Add images to your moodboard',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _moodboardImages.length,
                      itemBuilder: (context, index) {
                        final item = _moodboardImages[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Image'),
                                  content: const Text(
                                      'Remove this from your moodboard?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _moodboardImages.removeAt(index);
                                        });
                                        Navigator.pop(context);
                                        _saveData();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.pink.shade200),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: item.isAsset
                                      ? Icon(
                                          _getMoodIcon(item.imagePath),
                                          size: 40,
                                          color: Colors.pink.shade300,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(item.imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.caption,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Journal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sort By'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Date (Newest First)'),
                              onTap: () {
                                setState(() {
                                  _journalEntries.sort((a, b) =>
                                      b.dateTime.compareTo(a.dateTime));
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Date (Oldest First)'),
                              onTap: () {
                                setState(() {
                                  _journalEntries.sort((a, b) =>
                                      a.dateTime.compareTo(b.dateTime));
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Title'),
                              onTap: () {
                                setState(() {
                                  _journalEntries.sort(
                                      (a, b) => a.title.compareTo(b.title));
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _journalEntries.length,
              itemBuilder: (context, index) {
                final entry = _journalEntries[index];
                return Dismissible(
                  key: Key(entry.dateTime.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _journalEntries.removeAt(index);
                    });
                    _saveData();
                  },
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        _getMoodIcon('${entry.mood}.png'),
                        color: Colors.pink.shade300,
                      ),
                      title: Text(entry.title),
                      subtitle: Text(
                        'Last edited: ${DateFormat('MMM d, yyyy • h:mm a').format(entry.dateTime)}',
                      ),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _editJournalEntry(index),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _addJournalEntry,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Add new entry',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodboardItem {
  final String imagePath; // Can be either asset path or file path
  final String caption;
  final bool isAsset; // To distinguish between preset and picked images

  MoodboardItem({
    required this.imagePath,
    required this.caption,
    this.isAsset = true,
  });
}

class JournalEntry {
  final String title;
  final String content;
  final DateTime dateTime;
  final String mood;

  JournalEntry({
    required this.title,
    required this.content,
    required this.dateTime,
    required this.mood,
  });
}

class SimpleColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const SimpleColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.black,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedColor == color ? Colors.white : Colors.black,
                width: selectedColor == color ? 3 : 1,
              ),
              boxShadow: [
                if (selectedColor == color)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
