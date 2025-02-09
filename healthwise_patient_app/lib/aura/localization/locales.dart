import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", LocaleData.EN),
  MapLocale("hi", LocaleData.HI),
  MapLocale("ta", LocaleData.TA), // Added Tamil locale
];

mixin LocaleData {
  static const String home = "home";
  static const String adoptPet = "adoptPet";
  static const String labReportAnalysis = "labReportAnalysis";
  static const String dietPlanGenerator = "dietPlanGenerator";
  static const String usageAnalyser = "usageAnalyser";
  static const String therapistNearMe = "therapistNearMe";
  static const String hindi = "hindi";
  static const String english = "english";
  static const String aura = "aura";
  static const String welcomeBack = "welcomeBack";
  static const String howAreYouFeeling = "howAreYouFeeling";
  static const String happy = "happy";
  static const String calm = "calm";
  static const String low = "low";
  static const String stressed = "stressed";
  static const String therapySessions = "therapySessions";
  static const String openUp = "openUp";
  static const String matterMost = "matterMost";
  static const String bookNow = "bookNow";
  static const String yourTasks = "yourTasks";
  static const String journal = "journal";
  static const String music = "music";
  static const String meditation = "meditation";
  static const String games = "games";
  static const String articles = "articles";
  static const String weather = "weather";
  static const String calmNow = "calmNow";
  static const String challenges = "challenges";
  static const String goBackToMainApp = "goBackToMainApp";
  static const String healthwise = "healthwise";
  static const String lifestyle = "lifestyle";
  static const String doctorList = "doctorList";
  static const String appointment = "Appointments";
  static const String symptoms = "Symptoms to Disease";
  static const String cart = "Medicine Cart";
  static const String chat = "chat";
  static const String video_call = "video_call";
  static const String voice_ass = "voice_ass";

  static const Map<String, dynamic> EN = {
    home: "Home",
    adoptPet: "Adopt Pet",
    labReportAnalysis: "Lab Report Analysis",
    dietPlanGenerator: "Diet Plan Generator",
    usageAnalyser: "Usage Analyser",
    therapistNearMe: "Therapist Near Me",
    hindi: "Hindi",
    english: "English",
    aura: "Aura",
    welcomeBack: "Welcome back",
    howAreYouFeeling: "How are you feeling today?",
    happy: "Happy",
    calm: "Calm",
    low: "Low",
    stressed: "Stressed",
    therapySessions: "Therapy Sessions",
    openUp: "Let's open up to the things that",
    matterMost: "matter the most.",
    bookNow: "Book Now",
    yourTasks: "Your Tasks",
    journal: "Journal",
    music: "Music",
    meditation: "Meditation",
    games: "Games",
    articles: "Articles",
    weather: "Weather",
    calmNow: "Calm Now",
    challenges: "Challenges",
    goBackToMainApp: "Go back to main app",
    healthwise: "Healthwise",
    lifestyle: "Lifestyle",
    doctorList: "Doctor List",
    symptoms: "Symptoms to Disease",
    appointment: "Appointments",
    cart: "Medicine cart",
    chat: "Chat",
    video_call: "Video Call",
    voice_ass: "Voice Assistant",
  };

  static const Map<String, dynamic> HI = {
    home: "होम",
    adoptPet: "पालतू जानवर अपनाएं",
    labReportAnalysis: "लैब रिपोर्ट विश्लेषण",
    dietPlanGenerator: "आहार योजना जनरेटर",
    usageAnalyser: "उपयोग विश्लेषक",
    therapistNearMe: "मेरे पास चिकित्सक",
    hindi: "हिंदी",
    english: "अंग्रेज़ी",
    aura: "ऑरा",
    welcomeBack: "वापसी पर स्वागत है",
    howAreYouFeeling: "आज आप कैसा महसूस कर रहे हैं?",
    happy: "खुश",
    calm: "शांत",
    low: "कम",
    stressed: "तनावग्रस्त",
    therapySessions: "चिकित्सा सत्र",
    openUp: "आइए उन चीजों के बारे में खुलकर बात करें जो",
    matterMost: "सबसे ज्यादा मायने रखती हैं।",
    bookNow: "अभी बुक करें",
    yourTasks: "आपके कार्य",
    journal: "पत्रिका",
    music: "संगीत",
    meditation: "ध्यान",
    games: "खेल",
    articles: "समाचार",
    weather: "मौसम",
    calmNow: "शांत हो जाओ",
    challenges: "चुनौतियाँ",
    goBackToMainApp: "मुख्य ऐप्लिकेशन पर वापस जाएं",
    healthwise: "हेल्थवाइज",
    lifestyle: "जीवनशैली",
    doctorList: "डॉक्टर सूची",
    symptoms: "लक्षण से रोग तक",
    appointment: "अपॉइंटमेंट",
    cart: "दवा की खरीदारी",
    chat: "चैट",
    video_call: "वीडियो कॉल",
    voice_ass: "वॉयस असिस्टेंट",
  };

  static const Map<String, dynamic> TA = {
    home: "முகப்பு",
    adoptPet: "விலங்கினை தத்தெடுக்கவும்",
    labReportAnalysis: "ஆய்வக அறிக்கை பகுப்பாய்வு",
    dietPlanGenerator: "உணவுத்திட்ட உருவாக்கி",
    usageAnalyser: "பயன்பாட்டு பகுப்பாய்வாளர்",
    therapistNearMe: "என் அருகில் உள்ள மருத்துவர்",
    hindi: "இந்தி",
    english: "ஆங்கிலம்",
    aura: "ஆரா",
    welcomeBack: "மீண்டும் வருக",
    howAreYouFeeling: "இன்று நீங்கள் எப்படி உணருகிறீர்கள்?",
    happy: "மகிழ்ச்சி",
    calm: "அமைதி",
    low: "குறைவு",
    stressed: "மிகுந்த மன அழுத்தம்",
    therapySessions: "சிகிச்சை அமர்வுகள்",
    openUp: "முக்கியமானவற்றைப் பற்றி திறந்து பேசுவோம்",
    matterMost: "மிகவும் முக்கியமானவை.",
    bookNow: "இப்போது பதிவு செய்க",
    yourTasks: "உங்கள் பணிகள்",
    journal: "பத்திரிகை",
    music: "இசை",
    meditation: "தியானம்",
    games: "விளையாட்டுகள்",
    articles: "கட்டுரைகள்",
    weather: "வானிலை",
    calmNow: "இப்போது அமைதியாக",
    challenges: "சவால்கள்",
    goBackToMainApp: "முக்கிய ஆப்பிக்கு திரும்பவும்",
    healthwise: "ஹெல்த்வைஸ்",
    lifestyle: "வாழ்வுபாடு",
    doctorList: "மருத்துவர்",
    symptoms: "நோய்க்கான அறிகுறிகள்",
    appointment: "நியமனம்",
    cart: "மருந்து ஷாப்பிங்",
    chat: "உரை",
    video_call: "வீடியோ அழைப்பு",
    voice_ass: "வாய்வழி உத",
  };
}
