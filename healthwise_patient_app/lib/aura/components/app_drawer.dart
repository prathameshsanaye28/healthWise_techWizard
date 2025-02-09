import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:healthwise_patient_app/aura/localization/locales.dart';
import 'package:healthwise_patient_app/aura/models/user.dart';
import 'package:healthwise_patient_app/aura/resources/user_provider.dart';
import 'package:healthwise_patient_app/aura/views/chat_screen.dart/search_screen.dart';
import 'package:healthwise_patient_app/aura/views/lifestyle/lifestlye_screen.dart';
import 'package:healthwise_patient_app/patient_base/navigator_screen.dart';
import 'package:healthwise_patient_app/patient_base/views/ecommerce/cart_screen.dart';
import 'package:healthwise_patient_app/patient_base/views/mri_scanner/mri_scanner.dart';
import 'package:healthwise_patient_app/patient_base/views/symptom_screen.dart';
import 'package:healthwise_patient_app/patient_base/views/video_call/home_page.dart';
import 'package:healthwise_patient_app/patient_base/views/voice_assistant/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

import '../../patient_base/views/doctor_list/doctor_list.dart';
import '../views/CircadianScreens/weather_page.dart';
import '../views/analyse_report.dart';
import '../views/analysis_screens/analysis_screen.dart';
import '../views/articles.dart';
import '../views/diet_plan_screen.dart';
import '../views/gamification/gamification_feature.dart';
import '../views/therapist_screen.dart';

class AppDrawer extends StatefulWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late FlutterLocalization _flutterLocalization;
  bool _isLoading = true;
  late String _currentLocale;
  bool _isAuraExpanded = false; // Add this line

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLocale = prefs.getString('currentLocale') ?? 'en';
      _isLoading = false;
    });
  }

  Future<void> _saveLanguagePreference(String locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currentLocale', locale);
  }

  void _setLocale(String? value) {
    if (value == null) return;

    _flutterLocalization.translate(value);

    setState(() {
      _currentLocale = value;
    });
    _saveLanguagePreference(value);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Drawer(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final Patient? user = Provider.of<UserProvider>(context).getUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(174, 175, 247, 1), // Soft pink
                // Color.fromRGBO(253, 221, 236, 1), // Light peach
                Color(0xFFC5DEE3), // Pale blue
              ],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleData.healthwise.getString(context), // Update this line
                  style: const TextStyle(
                      fontSize: 45,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
                context,
                LocaleData.home.getString(context),
                const Icon(Icons.home),
                const PatientAppNavigatorScreen(),
                '/navigatorScreen'),
          ),
          ExpansionTile(
            title: Text(LocaleData.aura.getString(context)),
            leading: const ImageIcon(AssetImage("assets/icons/aura_icon.png")),
            initiallyExpanded: _isAuraExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() => _isAuraExpanded = expanded);
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildDrawerItem(
                  context,
                  LocaleData.usageAnalyser.getString(context),
                  const Icon(Icons.auto_graph),
                  const CombinedAnalysisScreen(),
                  '/combined_analysis',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildDrawerItem(
                  context,
                  LocaleData.therapistNearMe.getString(context),
                  const Icon(Icons.medical_services_outlined),
                  TherapistScreen(userUid: user!.uid),
                  '/therapist',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildDrawerItem(
                  context,
                  LocaleData.weather.getString(context),
                  const Icon(Icons.wb_sunny),
                  const WeatherPage(),
                  '/weather',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildDrawerItem(
                  context,
                  LocaleData.challenges.getString(context),
                  const Icon(Icons.flag),
                  ChallengesScreen(userId: user.uid),
                  '/challenges',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
                context,
                LocaleData.doctorList.getString(context),
                const Icon(Icons.health_and_safety),
                const DoctorListScreen(),
                '/doctor_list'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
                context,
                LocaleData.voice_ass.getString(context),
                const Icon(Icons.voice_chat),
                const VoiceAssistantHomePage(),
                '/voice-ass'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
                context,
                LocaleData.lifestyle.getString(context),
                const ImageIcon(AssetImage("assets/icons/lifestyle_icon.png")),
                const LifestlyeScreen(),
                '/lifestyle'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
                context,
                LocaleData.labReportAnalysis.getString(context),
                const Icon(Icons.receipt),
                const SummarizerScreen(),
                '/summarizer'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
                context,
                LocaleData.dietPlanGenerator.getString(context),
                const Icon(Icons.restaurant),
                const DietPlanScreen(),
                '/diet_plan'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
              context,
              LocaleData.articles.getString(context),
              const Icon(Icons.article),
              const NewsScreen(),
              '/articles',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
              context,
              LocaleData.symptoms.getString(context),
              const Icon(Icons.medical_information),
              const SymptomsScreen(),
              '/symptoms',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
              context,
              LocaleData.appointment.getString(context),
              const Icon(Icons.meeting_room),
              const DoctorListScreen(),
              '/appointment',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
              context,
              LocaleData.cart.getString(context),
              const Icon(Icons.shopping_cart),
              CartScreen(
                userId: user.uid,
              ),
              '/cart',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
              context,
              LocaleData.chat.getString(context),
              const Icon(Icons.chat),
              // ChatScreen(
              //   userId: user.uid,
              //   username: user.fullname,
              // ),
              SearchScreen(),
              '/chat',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
              context,
              LocaleData.video_call.getString(context),
              const Icon(Icons.video_call),
              // ChatScreen(
              //   userId: user.uid,
              //   username: user.fullname,
              // ),
              HomePage(),
              '/video_call',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDrawerItem(
                context,
                "MRI Scanner",
                const Icon(Icons.voice_chat),
                const MriScannerScreen(),
                '/voice-ass'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _currentLocale,
              onChanged: (String? newValue) {
                _setLocale(newValue);
              },
              items: <String>['en', 'hi', 'ta']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value == 'en'
                        ? LocaleData.english.getString(context)
                        : value == 'hi'
                            ? LocaleData.hindi.getString(context)
                            : "தமிழ்",
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(BuildContext context, String title,
      Widget leadingIcon, Widget destination, String route) {
    return ListTile(
      title: Text(title),
      leading: leadingIcon,
      selected: widget.currentRoute == route,
      selectedTileColor: const Color.fromRGBO(253, 221, 236, 1),
      onTap: () {
        if (widget.currentRoute != route) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => destination));
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
