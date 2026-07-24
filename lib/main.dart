import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'app_colors.dart';
import 'weather_service.dart';

void main() {
  runApp(const WeatherCloneApp());
}

class WeatherCloneApp extends StatelessWidget {
  const WeatherCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherClone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgLight,
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brandOrange),
      ),
      home: const HomePage(),
    );
  }
}

/// -------------------- BREAKPOINTS --------------------
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

class WeatherIcon {
  /// Description string se Meteocons icon-name decide karta hai.
  static String nameFor(String description, {bool isNight = false}) {
    final d = description.toLowerCase();

    if (d.contains('thunder')) {
      return isNight ? 'thunderstorms-night' : 'thunderstorms-day';
    }
    if (d.contains('snow') || d.contains('sleet')) {
      return 'snow';
    }
    if (d.contains('shower') || d.contains('drizzle')) {
      return isNight ? 'partly-cloudy-night-rain' : 'partly-cloudy-day-rain';
    }
    if (d.contains('rain')) {
      return 'rain';
    }
    if (d.contains('mist') || d.contains('fog') || d.contains('haze')) {
      return isNight ? 'fog-night' : 'fog-day';
    }
    if (d.contains('overcast')) {
      return isNight ? 'overcast-night' : 'overcast-day';
    }
    if (d.contains('partly') && d.contains('cloud')) {
      return isNight ? 'partly-cloudy-night' : 'partly-cloudy-day';
    }
    if (d.contains('cloud')) {
      return isNight ? 'partly-cloudy-night' : 'cloudy';
    }
    if (d.contains('clear') || d.contains('sun')) {
      return isNight ? 'clear-night' : 'clear-day';
    }
    return isNight ? 'partly-cloudy-night' : 'partly-cloudy-day';
  }

  static String urlFor(String description, {bool isNight = false}) {
    final name = nameFor(description, isNight: isNight);
    return 'https://cdn.jsdelivr.net/npm/@meteocons/svg-static@0.1.0/fill/$name.svg';
  }
}

class WeatherImage extends StatelessWidget {
  final String description;
  final double size;
  final bool isNight;

  const WeatherImage({
    super.key,
    required this.description,
    this.size = 24,
    this.isNight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      WeatherIcon.urlFor(description, isNight: isNight),
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholderBuilder: (context) => SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

/// -------------------- MODELS --------------------
class AlertItem {
  final String severity; // red, orange, yellow
  final String title;
  final String start;
  final String end;
  final String source;

  const AlertItem({
    required this.severity,
    required this.title,
    required this.start,
    required this.end,
    required this.source,
  });
}

class StoryItem {
  final String category;
  final String title;
  final String time;

  const StoryItem({
    required this.category,
    required this.title,
    required this.time,
  });
}

const List<AlertItem> kAlerts = [
  AlertItem(
    severity: 'red',
    title: 'Red Warning for Heavy Rainfall',
    start: '3:42 PM, Thursday, July 23',
    end: '3:38 PM, Friday, July 24',
    source: 'India Meteorological Department',
  ),
  AlertItem(
    severity: 'red',
    title: 'Red Warning for Heavy Rainfall',
    start: '3:57 PM, Thursday, July 23',
    end: '3:38 PM, Friday, July 24',
    source: 'India Meteorological Department',
  ),
  AlertItem(
    severity: 'orange',
    title: 'Orange Alert for Heavy Rainfall',
    start: '10:40 AM, Friday, July 24',
    end: '1:39 PM, Friday, July 24',
    source: 'India Meteorological Department',
  ),
  AlertItem(
    severity: 'yellow',
    title: 'Yellow Watch for Thunderstorms',
    start: '4:03 PM, Thursday, July 23',
    end: '3:51 PM, Friday, July 24',
    source: 'India Meteorological Department',
  ),
];

class HourForecast {
  final String time;
  final int temp;
  final int realFeel;
  final int rainChance;
  final String description;
  final bool isCurrent; // red left-border jaise "abhi" wala indicator
  final List<AlertItem> alerts;

  const HourForecast({
    required this.time,
    required this.temp,
    required this.realFeel,
    required this.rainChance,
    required this.description,
    this.isCurrent = false,
    this.alerts = const [],
  });
}

class DayForecast {
  final String day;
  final String date;
  final int hi;
  final int lo;
  final String description;
  final String note;
  final int rainChance;
  final bool isToday;

  const DayForecast({
    required this.day,
    required this.date,
    required this.hi,
    required this.lo,
    required this.description,
    required this.note,
    required this.rainChance,
    this.isToday = false,
  });
}

const List<HourForecast> kHourly = [
  HourForecast(
    time: '1 PM',
    temp: 29,
    realFeel: 37,
    rainChance: 49,
    description: 'Cloudy',
    isCurrent: true,
    alerts: kAlerts,
  ),
  HourForecast(
    time: '2 PM',
    temp: 30,
    realFeel: 36,
    rainChance: 59,
    description: 'A shower',
  ),
  HourForecast(
    time: '3 PM',
    temp: 30,
    realFeel: 37,
    rainChance: 49,
    description: 'Cloudy',
    isCurrent: true,
    alerts: kAlerts,
  ),
  HourForecast(
    time: '4 PM',
    temp: 29,
    realFeel: 34,
    rainChance: 66,
    description: 'Showers',
  ),
  HourForecast(
    time: '5 PM',
    temp: 29,
    realFeel: 35,
    rainChance: 49,
    description: 'Cloudy',
  ),
  HourForecast(
    time: '6 PM',
    temp: 28,
    realFeel: 34,
    rainChance: 39,
    description: 'Cloudy',
  ),
  HourForecast(
    time: '7 PM',
    temp: 28,
    realFeel: 33,
    rainChance: 20,
    description: 'Cloudy',
  ),
  HourForecast(
    time: '8 PM',
    temp: 28,
    realFeel: 32,
    rainChance: 20,
    description: 'Cloudy',
  ),
];

const List<DayForecast> kTenDay = [
  DayForecast(
    day: 'TODAY',
    date: '7/24',
    hi: 30,
    lo: 27,
    description: 'A few showers this afternoon',
    note: 'Night: Cloudy, a t-storm around late',
    rainChance: 96,
    isToday: true,
  ),
  DayForecast(
    day: 'SAT',
    date: '7/25',
    hi: 29,
    lo: 26,
    description: 'A little afternoon rain',
    note: 'Partly to mostly cloudy',
    rainChance: 65,
  ),
  DayForecast(
    day: 'SUN',
    date: '7/26',
    hi: 31,
    lo: 27,
    description: 'Mostly cloudy, a little rain',
    note: 'A little late-night rain',
    rainChance: 62,
  ),
  DayForecast(
    day: 'MON',
    date: '7/27',
    hi: 31,
    lo: 27,
    description: 'A little rain',
    note: 'Overcast with a stray shower',
    rainChance: 55,
  ),
  DayForecast(
    day: 'TUE',
    date: '7/28',
    hi: 31,
    lo: 28,
    description: 'Breezy with a little rain',
    note: 'Occasional rain late',
    rainChance: 55,
  ),
  DayForecast(
    day: 'WED',
    date: '7/29',
    hi: 29,
    lo: 26,
    description: 'A couple of morning showers',
    note: 'Cloudy with a shower or two',
    rainChance: 70,
  ),
  DayForecast(
    day: 'THU',
    date: '7/30',
    hi: 30,
    lo: 28,
    description: 'Cloudy with occasional rain',
    note: 'Occasional rain',
    rainChance: 62,
  ),
  DayForecast(
    day: 'FRI',
    date: '7/31',
    hi: 31,
    lo: 28,
    description: 'Rain most of the time',
    note: 'A touch of late-night rain',
    rainChance: 62,
  ),
  DayForecast(
    day: 'SAT',
    date: '8/1',
    hi: 30,
    lo: 27,
    description: 'A little afternoon rain',
    note: 'Clouds, a little rain late',
    rainChance: 56,
  ),
  DayForecast(
    day: 'SUN',
    date: '8/2',
    hi: 31,
    lo: 27,
    description: 'A bit of rain in the morning',
    note: 'Partly cloudy with a shower',
    rainChance: 58,
  ),
];

const List<StoryItem> kStories = [
  StoryItem(
    category: 'LIVE BLOG',
    title: 'Live updates: Storm becomes a tropical rainstorm after landfall',
    time: '2 hours ago',
  ),
  StoryItem(
    category: 'HURRICANE',
    title: 'Tropical rainstorm spreads rain across the region',
    time: '3 hours ago',
  ),
  StoryItem(
    category: 'SEVERE WEATHER',
    title: 'Repeated storms threaten high winds, flooding over wide areas',
    time: '11 hours ago',
  ),
  StoryItem(
    category: 'WEATHER NEWS',
    title: 'Record flooding prompts state of emergency',
    time: '12 hours ago',
  ),
];

/// -------------------- HOME PAGE --------------------
/// Ab HomePage stateful hai kyunki tab tap karne par
/// niche ka content (Today / Hourly / etc.) badalna hai.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0; // 0 = TODAY, 1 = HOURLY, baaki tabs abhi placeholder
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherService = WeatherService();
      final weather = await weatherService.getCurrentWeather();
      setState(() {
        _weatherData = weather;
      });
    } catch (e) {
      print('Error fetching weather data for header: $e');
    }
  }

  void _onTabTap(int index) {
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopUtilityBar(),
              MainHeader(weatherData: _weatherData),
              NavTabs(selectedIndex: _selectedTab, onTabSelected: _onTabTap),
              const AdBanner(height: 250),
              ContentSection(selectedTab: _selectedTab),
              const SiteFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------- TOP UTILITY BAR --------------------
class TopUtilityBar extends StatelessWidget {
  const TopUtilityBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < Breakpoints.mobile;
    final links = [
      'For Business',
      'Warnings',
      'Data Suite',
      'Forensics',
      'Advertising',
      'Superior Accuracy®',
    ];
    return Container(
      width: double.infinity,
      color: AppColors.topBarBlack,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isMobile
          ? Text('For Business', style: AppTextStyles.navLink)
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < links.length; i++) ...[
                    Text(links[i], style: AppTextStyles.navLink),
                    if (i != links.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: 1,
                          height: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}

/// -------------------- MAIN HEADER --------------------
class MainHeader extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const MainHeader({super.key, this.weatherData});

  String _getTemperature() {
    if (weatherData == null) return '27°C';
    
    try {
      final current = weatherData!['current_condition'];
      if (current != null && current.isNotEmpty) {
        final temp = current[0]['temp_C'];
        return '${temp}°C';
      }
    } catch (e) {
      print('Error parsing temperature: $e');
    }
    return '27°C';
  }

  String _getWeatherDescription() {
    if (weatherData == null) return 'Rain';
    
    try {
      final current = weatherData!['current_condition'];
      if (current != null && current.isNotEmpty) {
        final weatherDesc = current[0]['weatherDesc'];
        if (weatherDesc != null && weatherDesc.isNotEmpty) {
          return weatherDesc[0]['value'] ?? 'Partly cloudy';
        }
      }
    } catch (e) {
      print('Error parsing weather description: $e');
    }
    return 'Partly cloudy';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < Breakpoints.mobile;
    final temperature = _getTemperature();
    final weatherDescription = _getWeatherDescription();

    return Container(
      width: double.infinity,
      color: AppColors.headerBlack,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isMobile ? 12 : 16,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 12,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wb_sunny,
                color: AppColors.brandOrange,
                size: 26,
              ),
              const SizedBox(width: 8),
              const Text(
                'WeatherClone',
                style: TextStyle(
                  color: AppColors.textOnDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Surat, Gujarat',
                style: TextStyle(color: AppColors.textOnDark, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Text(
                temperature,
                style: const TextStyle(
                  color: AppColors.textOnDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              WeatherImage(description: weatherDescription, size: 18),
            ],
          ),
          SizedBox(
            width: isMobile ? double.infinity : 340,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.bgWhite,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.search,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: const [
                    Text(
                      'Location',
                      style: TextStyle(
                        color: AppColors.textOnDark,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textOnDark,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.smart_display_outlined,
                  color: AppColors.textOnDark,
                  size: 22,
                ),
                const SizedBox(width: 12),
                const Icon(Icons.menu, color: AppColors.textOnDark, size: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------- NAV TABS --------------------
/// Ab ye tappable hai. Tap karne par onTabSelected(index) call hota hai
/// jo HomePage me _selectedTab update karke niche ka content badal deta hai.
class NavTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const NavTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const tabs = [
    'TODAY',
    'HOURLY',
    '10-DAY',
    'RADAR',
    'MINUTECAST®',
    'MONTHLY',
    'AIR QUALITY',
    'HEALTH & ACTIVITIES',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.bgWhite,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (int i = 0; i < tabs.length; i++)
              InkWell(
                onTap: () => onTabSelected(i),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == selectedIndex
                            ? AppColors.brandOrange
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    style: i == selectedIndex
                        ? AppTextStyles.tabLink.copyWith(
                            color: AppColors.brandOrange,
                          )
                        : AppTextStyles.tabLink,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// -------------------- AD BANNER (reusable placeholder) --------------------
class AdBanner extends StatelessWidget {
  final double height;

  const AdBanner({super.key, this.height = 250});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: height,
      decoration: BoxDecoration(
        color: AppColors.bgAdPlaceholder,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        color: AppColors.adTagBg,
        child: const Text(
          'AD',
          style: TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
      ),
    );
  }
}

/// -------------------- MAIN CONTENT: LEFT PANEL + SIDEBAR --------------------
/// selectedTab ke hisaab se left panel switch hota hai:
/// 0 -> TodayPanel, 1 -> HourlyPanel, baaki -> AlertsPanel (default/placeholder)
class ContentSection extends StatelessWidget {
  final int selectedTab;

  const ContentSection({super.key, required this.selectedTab});

  Widget _buildLeftPanel() {
    switch (selectedTab) {
      case 0:
        return const TodayPanel();
      case 1:
        return const HourlyPanel();
      default:
        return const AlertsPanel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= Breakpoints.tablet;
        final leftPanel = _buildLeftPanel();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: leftPanel),
                    const SizedBox(width: 16),
                    const Expanded(flex: 1, child: SidebarPanel()),
                  ],
                )
              : Column(
                  children: [
                    leftPanel,
                    const SizedBox(height: 16),
                    const SidebarPanel(),
                  ],
                ),
        );
      },
    );
  }
}

/// -------------------- ALERTS PANEL --------------------
class AlertsPanel extends StatelessWidget {
  const AlertsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Surat Alerts', style: AppTextStyles.sectionTitle),
            Text(
              '${kAlerts.length} Active',
              style: AppTextStyles.cardSubtitle.copyWith(
                color: AppColors.linkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final alert in kAlerts) AlertCard(alert: alert),
        const SizedBox(height: 16),
        const AdvisoryInfoBox(),
        const SizedBox(height: 16),
        const AroundTheGlobeBox(),
      ],
    );
  }
}

class AlertCard extends StatelessWidget {
  final AlertItem alert;

  const AlertCard({super.key, required this.alert});

  Color get _severityColor {
    switch (alert.severity) {
      case 'red':
        return AppColors.alertRed;
      case 'orange':
        return AppColors.alertOrange;
      default:
        return AppColors.alertYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _severityColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _severityColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(
                  'Start  ${alert.start}',
                  style: AppTextStyles.cardSubtitle,
                ),
                Text('End    ${alert.end}', style: AppTextStyles.cardSubtitle),
                const SizedBox(height: 4),
                Text('Source: ${alert.source}', style: AppTextStyles.cardMuted),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.chevronGray),
        ],
      ),
    );
  }
}

class AdvisoryInfoBox extends StatelessWidget {
  const AdvisoryInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SURAT WEATHER WARNINGS & ADVISORIES',
            style: AppTextStyles.footerHeading,
          ),
          const SizedBox(height: 10),
          Text(
            'The following official weather warnings and advisories are currently in effect '
            'for Surat, issued by the India Meteorological Department. WeatherClone aggregates '
            'severe weather alerts from official government meteorological authorities across '
            'more than 200 countries and territories to help protect life and property.',
            style: AppTextStyles.cardSubtitle.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class AroundTheGlobeBox extends StatelessWidget {
  const AroundTheGlobeBox({super.key});

  static const items = [
    'Hurricane Tracker',
    'Severe Weather',
    'Radar & Maps',
    'News',
    'Video',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'AROUND THE GLOBE',
                style: AppTextStyles.footerHeading,
              ),
            ),
          ),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.toUpperCase(),
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// -------------------- TODAY PANEL (TODAY tab content) --------------------
class TodayPanel extends StatefulWidget {
  const TodayPanel({super.key});

  @override
  State<TodayPanel> createState() => _TodayPanelState();
}

class _TodayPanelState extends State<TodayPanel> {
  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _forecastData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherService = WeatherService();
      final weather = await weatherService.getCurrentWeather();
      final forecast = await weatherService.getForecast();
      setState(() {
        _weatherData = weather;
        _forecastData = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompactAlertBanner(),
        const SizedBox(height: 12),
        TodaysWeatherCard(weatherData: _weatherData),
        const SizedBox(height: 12),
        CurrentWeatherCard(weatherData: _weatherData),
        const SizedBox(height: 12),
        LookingAheadCard(),
        const SizedBox(height: 12),
        RadarCard(),
        const SizedBox(height: 12),
        HourlyStripCard(forecastData: _forecastData),
        const SizedBox(height: 12),
        TenDayForecastCard(forecastData: _forecastData),
        const SizedBox(height: 12),
        SunMoonCard(weatherData: _weatherData),
        const SizedBox(height: 12),
        AirQualityCard(weatherData: _weatherData),
        const SizedBox(height: 12),
        AllergyOutlookCard(weatherData: _weatherData),
      ],
    );
  }
}

/// Red banner jaisa "5  Red Warning for Heavy Rainfall  ->"
class CompactAlertBanner extends StatelessWidget {
  const CompactAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.alertRed,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_rounded,
            color: AppColors.textOnDark,
            size: 18,
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.textOnDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${kAlerts.length}',
              style: const TextStyle(
                color: AppColors.alertRed,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Red Warning for Heavy Rainfall',
              style: TextStyle(
                color: AppColors.textOnDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward,
            color: AppColors.textOnDark,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class TodaysWeatherCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const TodaysWeatherCard({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    // wttr.in format: current_condition -> temp_C, weatherDesc
    final current = weatherData?['current_condition']?[0] ?? {};
    final temp = int.tryParse(current['temp_C'] ?? '30') ?? 30;
    final description = current['weatherDesc']?[0]?['value'] ?? 'cloudy';

    return _PanelCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('TODAY\'S WEATHER', style: AppTextStyles.footerHeading),
            Text(
              DateTime.now().toString().substring(0, 10).toUpperCase(),
              style: AppTextStyles.footerHeading,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _WeatherBullet(
          iconWidget: WeatherImage(description: description, size: 20),
          text: '$description; current weather conditions',
          bold: 'Hi: $temp°',
        ),
        const SizedBox(height: 12),
        _WeatherBullet(
          iconWidget: WeatherImage(
            description: description,
            size: 20,
            isNight: true,
          ),
          text: 'Tonight: $description expected',
          bold: 'Lo: ${temp - 3}°',
        ),
      ],
    );
  }
}

class _WeatherBullet extends StatelessWidget {
  final Widget iconWidget;
  final String text;
  final String bold;

  const _WeatherBullet({
    required this.iconWidget,
    required this.text,
    required this.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconWidget,
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.cardSubtitle.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
              children: [
                TextSpan(text: '$text  '),
                TextSpan(
                  text: bold,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CurrentWeatherCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const CurrentWeatherCard({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    // wttr.in format: current_condition -> temp_C, FeelsLikeC, humidity, windspeedKmph, weatherDesc
    final current = weatherData?['current_condition']?[0] ?? {};
    final temp = int.tryParse(current['temp_C'] ?? '27') ?? 27;
    final feelsLike = int.tryParse(current['FeelsLikeC'] ?? '35') ?? 35;
    final humidity = current['humidity'] ?? '50';
    final windSpeed = current['windspeedKmph'] ?? '7';
    final description = current['weatherDesc']?[0]?['value'] ?? 'Rain';

    return _PanelCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('CURRENT WEATHER', style: AppTextStyles.footerHeading),
            Text(
              DateTime.now().toString().substring(11, 16),
              style: AppTextStyles.footerHeading,
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 420;
            final left = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherImage(description: description, size: 65),
                    const SizedBox(width: 8),
                    Text(
                      '$temp°',
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'C',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('RealFeel® $feelsLike°', style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                Text(description, style: AppTextStyles.cardTitle),
                Row(
                  children: const [
                    Text(
                      'MORE DETAILS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ],
            );
            final right = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'RealFeel Shade™', value: '$feelsLike°'),
                _DetailRow(label: 'Heat Index', value: '$feelsLike°'),
                _DetailRow(label: 'Wind', value: '$windSpeed km/h'),
                _DetailRow(label: 'Humidity', value: '$humidity%'),
                _DetailRow(
                  label: 'Air Quality',
                  value: current['air_quality']?[0]?['quality'] ?? 'Fair',
                  valueColor: _getAirQualityColor(
                    current['air_quality']?[0]?['quality'] ?? 'Fair',
                  ),
                ),
              ],
            );
            if (narrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [left, const SizedBox(height: 16), right],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                Expanded(child: right),
              ],
            );
          },
        ),
      ],
    );
  }

  Color _getAirQualityColor(String quality) {
    final q = quality.toLowerCase();
    if (q.contains('good') || q.contains('excellent'))
      return AppColors.statusGood;
    if (q.contains('fair') || q.contains('moderate'))
      return AppColors.statusFair;
    if (q.contains('poor') || q.contains('unhealthy'))
      return AppColors.alertRed;
    return AppColors.statusFair;
  }
}

class LookingAheadCard extends StatelessWidget {
  const LookingAheadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _PanelCard(
      children: const [
        Text('LOOKING AHEAD', style: AppTextStyles.footerHeading),
        SizedBox(height: 10),
        Text(
          'Thunderstorms in the area late Friday night through Saturday morning',
          style: AppTextStyles.cardTitle,
        ),
      ],
    );
  }
}

class RadarCard extends StatefulWidget {
  const RadarCard({super.key});

  @override
  State<RadarCard> createState() => _RadarCardState();
}

class _RadarCardState extends State<RadarCard> {
  @override
  Widget build(BuildContext context) {
    return _PanelCard(
      children: [
        const Text('SURAT WEATHER RADAR', style: AppTextStyles.footerHeading),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            color: AppColors.bgAdPlaceholder,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(21.1702, 72.8311), // Surat coordinates
                zoom: 5,
              ),
              zoomGesturesEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _RadarToggle(icon: Icons.cloud, label: 'Clouds', selected: true),
            const SizedBox(width: 10),
            _RadarToggle(
              icon: Icons.thermostat,
              label: 'Temperature',
              selected: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _RadarToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _RadarToggle({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.bgLight : AppColors.bgWhite,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.cardSubtitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class HourlyStripCard extends StatelessWidget {
  final Map<String, dynamic>? forecastData;

  const HourlyStripCard({super.key, this.forecastData});

  @override
  Widget build(BuildContext context) {
    // wttr.in format: weather array contains daily forecasts, each with hourly data
    // We'll take the first day's hourly data (first 8 hours)
    final weatherList = forecastData?['weather'] as List<dynamic>?;
    final hourlyData = weatherList?.isNotEmpty == true
        ? (weatherList![0]['hourly'] as List<dynamic>?)?.take(8).toList() ?? []
        : [];

    return _PanelCard(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('HOURLY WEATHER', style: AppTextStyles.footerHeading),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hourlyData.isEmpty ? kHourly.length : hourlyData.length,
            separatorBuilder: (_, __) => const SizedBox(width: 18),
            itemBuilder: (context, i) {
              if (hourlyData.isEmpty) {
                final h = kHourly[i];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(h.time, style: AppTextStyles.cardSubtitle),
                    const SizedBox(height: 8),
                    WeatherImage(description: h.description, size: 26),
                    const SizedBox(height: 8),
                    Text(
                      '${h.temp}°',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.water_drop,
                          size: 12,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${h.rainChance}%',
                          style: AppTextStyles.cardMuted,
                        ),
                      ],
                    ),
                  ],
                );
              }

              // Use API data
              final hour = hourlyData[i] as Map<String, dynamic>;
              final time = hour['time'] ?? '';
              final temp = hour['tempC'] ?? '0';
              final weatherDesc = hour['weatherDesc']?[0]?['value'] ?? 'Clear';

              // Format time: wttr.in returns time like "0", "100", "200" (0:00, 1:00, 2:00)
              // Convert to 12-hour format with AM/PM
              int? hourInt = int.tryParse(time);
              String displayTime = '';
              if (hourInt != null) {
                int hour24 = hourInt ~/ 100;
                int minute = hourInt % 100;
                int hour12 = hour24 % 12;
                if (hour12 == 0) hour12 = 12;
                String ampm = hour24 >= 12 ? 'PM' : 'AM';
                displayTime = '$hour12 $ampm';
              } else {
                displayTime = time;
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(displayTime, style: AppTextStyles.cardSubtitle),
                  const SizedBox(height: 2),
                  WeatherImage(description: weatherDesc, size: 60),
                  const SizedBox(height: 4),
                  Text(
                    '${temp}°',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${hour['chanceofrain'] ?? '0'}%',
                        style: AppTextStyles.cardMuted,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class TenDayForecastCard extends StatefulWidget {
  final Map<String, dynamic>? forecastData;

  const TenDayForecastCard({super.key, this.forecastData});

  @override
  State<TenDayForecastCard> createState() => _TenDayForecastCardState();
}

class _TenDayForecastCardState extends State<TenDayForecastCard> {
  List<DayForecast> _dynamicForecast = [];
  bool _isParsed = false;

  @override
  void didUpdateWidget(TenDayForecastCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.forecastData != null && !_isParsed) {
      _parseForecastData();
    }
  }

  void _parseForecastData() {
    if (widget.forecastData == null) return;

    try {
      final weatherService = WeatherService();
      final parsedData = weatherService.parseTenDayForecast(widget.forecastData!);
      
      setState(() {
        _dynamicForecast = parsedData.map((data) {
          return DayForecast(
            day: data['day'] ?? 'TODAY',
            date: data['date'] ?? '',
            hi: data['hi'] ?? 30,
            lo: data['lo'] ?? 25,
            description: data['description'] ?? 'Partly cloudy',
            note: data['note'] ?? '',
            rainChance: data['rainChance'] ?? 50,
            isToday: data['isToday'] ?? false,
          );
        }).toList();
        _isParsed = true;
      });
    } catch (e) {
      print('Error parsing forecast: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final forecastList = _dynamicForecast.isNotEmpty ? _dynamicForecast : kTenDay;
    
    return _PanelCard(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '10-DAY WEATHER FORECAST',
            style: AppTextStyles.footerHeading,
          ),
        ),
        const SizedBox(height: 8),
        for (final d in forecastList) _TenDayRow(day: d),
      ],
    );
  }
}

class _TenDayRow extends StatelessWidget {
  final DayForecast day;

  const _TenDayRow({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: day.isToday ? AppColors.alertRed : Colors.transparent,
            width: 3,
          ),
          top: const BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.day,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 12),
                ),
                Text(day.date, style: AppTextStyles.cardMuted),
              ],
            ),
          ),
          WeatherImage(description: day.description, size: 60),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.cardTitle,
                children: [
                  TextSpan(text: '${day.hi}° '),
                  TextSpan(
                    text: '${day.lo}°',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.description,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                ),
                Text(
                  day.note,
                  style: AppTextStyles.cardSubtitle.copyWith(
                    color: AppColors.linkBlue,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.water_drop,
                size: 12,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 2),
              Text('${day.rainChance}%', style: AppTextStyles.cardMuted),
            ],
          ),
        ],
      ),
    );
  }
}

class SunMoonCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const SunMoonCard({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    // wttr.in format: astronomy array contains sun and moon data
    final astronomy = weatherData?['astronomy']?[0] ?? {};
    final sunrise = astronomy['sunrise'] ?? '6:09 AM';
    final sunset = astronomy['sunset'] ?? '7:21 PM';
    final moonrise = astronomy['moonrise'] ?? '3:20 PM';
    final moonset = astronomy['moonset'] ?? '2:11 AM';
    final moonPhase = astronomy['moon_phase'] ?? 'Waxing Gibbous';

    // Calculate day length (simplified)
    final dayLength = _calculateDayLength(sunrise, sunset);

    return _PanelCard(
      children: [
        const Text('SUN & MOON', style: AppTextStyles.footerHeading),
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(Icons.wb_sunny, color: AppColors.brandOrange, size: 22),
            const SizedBox(width: 10),
            Text(dayLength, style: AppTextStyles.cardTitle),
            const Spacer(),
            _SunMoonTimes(
              riseLabel: 'Rise',
              riseTime: sunrise,
              setLabel: 'Set',
              setTime: sunset,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(
              Icons.brightness_2,
              color: AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(moonPhase, style: AppTextStyles.cardTitle),
            const Spacer(),
            _SunMoonTimes(
              riseLabel: 'Rise',
              riseTime: moonrise,
              setLabel: 'Set',
              setTime: moonset,
            ),
          ],
        ),
      ],
    );
  }

  String _calculateDayLength(String sunrise, String sunset) {
    // Simplified calculation - returns a placeholder
    // In a real implementation, you'd parse the times and calculate the difference
    return '13 hrs 12 mins';
  }
}

class _SunMoonTimes extends StatelessWidget {
  final String riseLabel, riseTime, setLabel, setTime;

  const _SunMoonTimes({
    required this.riseLabel,
    required this.riseTime,
    required this.setLabel,
    required this.setTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$riseLabel  $riseTime', style: AppTextStyles.cardSubtitle),
        Text('$setLabel  $setTime', style: AppTextStyles.cardSubtitle),
      ],
    );
  }
}

class AirQualityCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const AirQualityCard({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    // wttr.in format: current_condition -> air_quality
    final current = weatherData?['current_condition']?[0] ?? {};
    final airQuality = current['air_quality']?[0]?['quality'] ?? 'Fair';
    final aqi = current['air_quality']?[0]?['aqi'] ?? '';

    return _PanelCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('AIR QUALITY', style: AppTextStyles.footerHeading),
            Text(
              'SEE MORE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.linkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.air, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            const Text('Air Quality', style: AppTextStyles.cardTitle),
            const Spacer(),
            Text(
              airQuality,
              style: TextStyle(
                color: _getAirQualityColor(airQuality),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _getAirQualityDescription(airQuality),
          style: AppTextStyles.cardSubtitle.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Color _getAirQualityColor(String quality) {
    final q = quality.toLowerCase();
    if (q.contains('good') || q.contains('excellent'))
      return AppColors.statusGood;
    if (q.contains('fair') || q.contains('moderate'))
      return AppColors.statusFair;
    if (q.contains('poor') || q.contains('unhealthy'))
      return AppColors.alertRed;
    return AppColors.statusFair;
  }

  String _getAirQualityDescription(String quality) {
    final q = quality.toLowerCase();
    if (q.contains('good') || q.contains('excellent')) {
      return 'Air quality is satisfactory, and air pollution poses little or no risk.';
    }
    if (q.contains('fair') || q.contains('moderate')) {
      return 'The air quality is generally acceptable for most individuals. However, sensitive groups may experience minor to moderate symptoms from long-term exposure.';
    }
    if (q.contains('poor') || q.contains('unhealthy')) {
      return 'Air quality is unhealthy for sensitive groups. Members of sensitive groups may experience health effects.';
    }
    return 'The air quality is generally acceptable for most individuals.';
  }
}

class AllergyOutlookCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const AllergyOutlookCard({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    // wttr.in doesn't provide allergy data directly, so we use air quality as a proxy
    final current = weatherData?['current_condition']?[0] ?? {};
    final airQuality = current['air_quality']?[0]?['quality'] ?? 'Fair';

    // Map air quality to allergy outlook
    final allergyOutlook = _getAllergyOutlook(airQuality);
    final allergyColor = _getAllergyColor(allergyOutlook);

    return _PanelCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('ALLERGY OUTLOOK', style: AppTextStyles.footerHeading),
            Text(
              'SEE ALL',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.linkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.grass, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            const Text('Dust & Dander', style: AppTextStyles.cardTitle),
            const Spacer(),
            Text(
              allergyOutlook,
              style: TextStyle(
                color: allergyColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 3, height: 16, color: allergyColor),
          ],
        ),
      ],
    );
  }

  String _getAllergyOutlook(String airQuality) {
    final q = airQuality.toLowerCase();
    if (q.contains('good') || q.contains('excellent')) return 'Low';
    if (q.contains('fair') || q.contains('moderate')) return 'Moderate';
    if (q.contains('poor') || q.contains('unhealthy')) return 'Extreme';
    return 'Moderate';
  }

  Color _getAllergyColor(String outlook) {
    final o = outlook.toLowerCase();
    if (o.contains('low')) return const Color(0xFF4CAF50);
    if (o.contains('moderate')) return const Color(0xFFFF9800);
    if (o.contains('extreme')) return const Color(0xFF9C27B0);
    return const Color(0xFFFF9800);
  }
}

/// Reusable white card wrapper used across TodayPanel sections.
class _PanelCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const _PanelCard({
    required this.children,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 0),
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.cardSubtitle),
          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------- HOURLY PANEL (HOURLY tab content) --------------------
class HourlyPanel extends StatelessWidget {
  const HourlyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (final h in kHourly) HourlyExpandedCard(hour: h)],
    );
  }
}

/// Har ghante ka expandable card — alerts (agar hain) + full details grid dikhata hai.
class HourlyExpandedCard extends StatefulWidget {
  final HourForecast hour;

  const HourlyExpandedCard({super.key, required this.hour});

  @override
  State<HourlyExpandedCard> createState() => _HourlyExpandedCardState();
}

class _HourlyExpandedCardState extends State<HourlyExpandedCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final h = widget.hour;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border(
          left: BorderSide(
            color: h.isCurrent ? AppColors.alertRed : Colors.transparent,
            width: 3,
          ),
          top: const BorderSide(color: AppColors.borderLight),
          right: const BorderSide(color: AppColors.borderLight),
          bottom: const BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(h.time, style: AppTextStyles.cardTitle),
                  ),
                  const SizedBox(width: 10),
                  WeatherImage(description: h.description, size: 26),
                  const SizedBox(width: 10),
                  Text(
                    '${h.temp}°',
                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
                  ),
                  const Spacer(),
                  Text(
                    'RealFeel® ${h.realFeel}°',
                    style: AppTextStyles.cardSubtitle,
                  ),
                  const SizedBox(width: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 2),
                      Text('${h.rainChance}%', style: AppTextStyles.cardMuted),
                    ],
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: 4),
              Text(h.description, style: AppTextStyles.cardSubtitle),
              if (h.alerts.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final a in h.alerts) _MiniAlertRow(alert: a),
              ],
              const SizedBox(height: 12),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 420;
                  final left = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _DetailRow(label: 'RealFeel Shade™', value: '34°'),
                      _DetailRow(label: 'Heat Index', value: '36°'),
                      _DetailRow(
                        label: 'Max UV Index',
                        value: '4.2 (Moderate)',
                      ),
                      _DetailRow(label: 'Wind Gusts', value: '44 km/h'),
                      _DetailRow(label: 'Humidity', value: '80%'),
                    ],
                  );
                  final right = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _DetailRow(label: 'Wind', value: 'WSW 19 km/h'),
                      _DetailRow(
                        label: 'Air Quality',
                        value: 'Fair',
                        valueColor: AppColors.statusFair,
                      ),
                      _DetailRow(label: 'Dew Point', value: '26° C'),
                      _DetailRow(label: 'AccuLumen™', value: '1 (Dark)'),
                      _DetailRow(label: 'Cloud Cover', value: '100%'),
                    ],
                  );
                  if (narrow) {
                    return Column(children: [left, right]);
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: left),
                      Expanded(child: right),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniAlertRow extends StatelessWidget {
  final AlertItem alert;

  const _MiniAlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = alert.severity == 'red'
        ? AppColors.alertRed
        : alert.severity == 'orange'
        ? AppColors.alertOrange
        : AppColors.alertYellow;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 3)),
        color: AppColors.bgLight,
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALERTS',
                  style: AppTextStyles.cardMuted.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  alert.title,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                ),
                Text(
                  '${alert.start} - ${alert.end}',
                  style: AppTextStyles.cardMuted,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward,
            size: 14,
            color: AppColors.chevronGray,
          ),
        ],
      ),
    );
  }
}

/// -------------------- SIDEBAR --------------------
class SidebarPanel extends StatelessWidget {
  const SidebarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdBanner(height: 250),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.borderLight),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Top Stories', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              for (final story in kStories) StoryTile(story: story),
              const SizedBox(height: 4),
              const Text(
                'More Stories',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const AdBanner(height: 250),
      ],
    );
  }
}

class StoryTile extends StatelessWidget {
  final StoryItem story;

  const StoryTile({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.category, style: AppTextStyles.storyCategory),
                const SizedBox(height: 4),
                Text(story.title, style: AppTextStyles.storyTitle),
                const SizedBox(height: 4),
                Text(story.time, style: AppTextStyles.cardMuted),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 56,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.bgAdPlaceholder,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------- FOOTER --------------------
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  static const Map<String, List<String>> columns = {
    'COMPANY': [
      'Proven Superior Accuracy®',
      'About WeatherClone',
      'Digital Advertising',
      'Careers',
      'Press',
      'Contact Us',
    ],
    'PRODUCTS & SERVICES': [
      'For Business',
      'For Partners',
      'For Advertising',
      'APIs',
      'Connect',
      'Personal Weather Stations',
    ],
    'APPS & DOWNLOADS': [
      'iPhone App',
      'Android App',
      'See all Apps & Downloads',
    ],
    'MORE': [
      'Health',
      'Hurricane',
      'Leisure and Recreation',
      'Severe Weather',
      'Space and Astronomy',
      'Sports',
      'Travel',
      'Weather News',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < Breakpoints.tablet;

    return Container(
      width: double.infinity,
      color: AppColors.bgWhite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Text('World', style: AppTextStyles.footerLink),
              Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
              Text('Asia', style: AppTextStyles.footerLink),
              Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
              Text('India', style: AppTextStyles.footerLink),
              Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
              Text('Gujarat', style: AppTextStyles.footerLink),
              Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
              Text('Surat', style: AppTextStyles.footerLink),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          Wrap(
            children: const [
              Text('Weather Near Surat:  ', style: AppTextStyles.footerLink),
              Text('Kadodara, Gujarat  |  ', style: AppTextStyles.footerLink),
              Text('Kamrej, Gujarat  |  ', style: AppTextStyles.footerLink),
              Text('Un, Gujarat', style: AppTextStyles.footerLink),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 24),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in columns.entries) ...[
                      FooterColumn(title: entry.key, links: entry.value),
                      const SizedBox(height: 20),
                    ],
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in columns.entries)
                      Expanded(
                        child: FooterColumn(
                          title: entry.key,
                          links: entry.value,
                        ),
                      ),
                  ],
                ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.facebook, color: AppColors.textSecondary),
              SizedBox(width: 12),
              Icon(Icons.alternate_email, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),
          Text(
            '© 2026 WeatherClone, Inc. "WeatherClone" and sun design are registered trademarks. All Rights Reserved.',
            style: AppTextStyles.cardMuted,
          ),
          const SizedBox(height: 6),
          Wrap(
            children: const [
              Text('Terms of Use | ', style: AppTextStyles.cardMuted),
              Text('Privacy Policy | ', style: AppTextStyles.cardMuted),
              Text('Cookie Policy | ', style: AppTextStyles.cardMuted),
              Text('Data Sources', style: AppTextStyles.cardMuted),
            ],
          ),
        ],
      ),
    );
  }
}

class FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const FooterColumn({super.key, required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.footerHeading),
          const SizedBox(height: 12),
          for (final link in links)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(link, style: AppTextStyles.footerLink),
            ),
        ],
      ),
    );
  }
}
