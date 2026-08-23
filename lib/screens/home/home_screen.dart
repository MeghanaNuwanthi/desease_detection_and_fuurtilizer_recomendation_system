import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';
import '../../services/camera_service.dart';
import '../../services/weather_service.dart';
import '../../services/image_storage_service.dart';
import '../../data/disease_info_library.dart';
import '../disease_info/disease_info_detail_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../fertilizer/fertilizer_screen.dart';
import '../scan/scan_loading_screen.dart';

class HomeScreen extends StatefulWidget {

  final void Function(Locale) onLanguageSelected;

  const HomeScreen({
    super.key,
    required this.onLanguageSelected,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedIndex = 0;

  void onNavTap(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [
      const HomeContent(),
      const HistoryScreen(),
      const SizedBox(),
      const FertilizerScreen(),
      SettingsScreen(onLanguageSelected: widget.onLanguageSelected),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: pages[selectedIndex],

      bottomNavigationBar: buildBottomNav(
        context,
        selectedIndex,
        onNavTap,
      ),

      floatingActionButton: floatingScanButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Date
              Text(
                _formatTodayLabel(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 10),

              /// Greeting
              Text(
                "${t.translate("ayubowan")}\n${t.translate("ready_check")}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 25),

              const WeatherCard(),

              const SizedBox(height: 25),

              /// Diagnosis
              Text(
                t.translate("diagnosis"),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  scanCard(context),
                  const SizedBox(width: 15),
                  uploadCard(context),
                ],
              ),

              const SizedBox(height: 30),

              /// Diseases section
              Text(
                t.translate("common_diseases"),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const DiseaseSlider(),

              const SizedBox(height: 100),

            ],
          ),
        ),
      ),
    );
  }

  String _formatTodayLabel() {
    const weekdays = [
      "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY",
      "FRIDAY", "SATURDAY", "SUNDAY",
    ];
    const months = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC",
    ];
    final now = DateTime.now();
    return "${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}";
  }
}

/// Shows real current-location weather. Handles loading, permission denial,
/// and API failure gracefully - weather is a nice-to-have, it should never
/// block the rest of the app.
class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {

  late Future<WeatherData> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService.instance.getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: _weatherFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _weatherShell(
            child: const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _weatherShell(
            onTap: () {
              setState(() {
                _weatherFuture = WeatherService.instance.getCurrentWeather();
              });
            },
            child: const Row(
              children: [
                Icon(Icons.location_off, color: AppColors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Couldn't get weather - tap to retry (check location permission)",
                    style: TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        final weather = snapshot.data!;

        return _weatherShell(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wb_sunny, color: Colors.orange),
              ),

              const SizedBox(width: 15),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.locationLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${weather.conditionDescription} · Humidity ${weather.humidityPercent}%",
                  ),
                ],
              ),

              const Spacer(),

              Text(
                "${weather.temperatureCelsius.round()}°C",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _weatherShell({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xffdff5df),
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }
}

/// Horizontal slider of disease education cards - pulls from
/// disease_info_library.dart (NOT disease_catalog.dart, which is reserved
/// for AI scan results). Tapping a card opens the full DOA-sourced article.
class DiseaseSlider extends StatelessWidget {
  const DiseaseSlider({super.key});

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);
    final entries = diseaseInfoLibrary.entries.toList();

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final diseaseKey = entries[index].key;
          final article = entries[index].value;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiseaseInfoDetailScreen(diseaseKey: diseaseKey),
                ),
              );
            },
            child: Container(
              width: 220,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.asset(
                      article.imageAsset,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        width: double.infinity,
                        color: article.color.withOpacity(0.12),
                        child: Icon(Icons.eco, color: article.color, size: 40),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          t.translate(article.nameKey),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          t.translate(article.symptomsKey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          t.translate("learn_more"),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget scanCard(BuildContext context) {

  final t = AppLocalization.of(context);
  final CameraService cameraService = CameraService();

  return Expanded(
    child: GestureDetector(

      onTap: () async {

        final image = await cameraService.captureImage();

        if (image != null) {

          final permanentPath =
              await ImageStorageService.instance.copyToPermanentStorage(image.path);

          if (!context.mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanLoadingScreen(
                imagePath: permanentPath,
              ),
            ),
          );

        }

      },

      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage("assets/images/paddy.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 40,
              ),

              const SizedBox(height: 10),

              Text(
                t.translate("scan_crop"),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget uploadCard(BuildContext context) {

  final t = AppLocalization.of(context);
  final CameraService cameraService = CameraService();

  return Expanded(
    child: GestureDetector(

      onTap: () async {

        final image = await cameraService.pickFromGallery();

        if (image != null) {

          final permanentPath =
              await ImageStorageService.instance.copyToPermanentStorage(image.path);

          if (!context.mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanLoadingScreen(
                imagePath: permanentPath,
              ),
            ),
          );

        }

      },

      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.image,
              size: 40,
              color: AppColors.grey,
            ),

            const SizedBox(height: 10),

            Text(
              t.translate("upload"),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              t.translate("from_gallery"),
              style: const TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget floatingScanButton(BuildContext context) {

  return FloatingActionButton(
    backgroundColor: AppColors.primaryGreen,
    elevation: 5,
    shape: const CircleBorder(),
    onPressed: () async {

      final CameraService cameraService = CameraService();
      final image = await cameraService.captureImage();

      if(image != null){

        final permanentPath =
            await ImageStorageService.instance.copyToPermanentStorage(image.path);

        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanLoadingScreen(
              imagePath: permanentPath,
            ),
          ),
        );

      }

    },
    child: const Icon(
      Icons.qr_code_scanner,
      size: 28,
      color: Colors.white,
    ),
  );
}

Widget buildBottomNav(
  BuildContext context,
  int selectedIndex,
  Function(int) onTap,
) {

  final t = AppLocalization.of(context);

  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8,

    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          navItem(Icons.home, t.translate("home"), 0, selectedIndex, onTap),
          navItem(Icons.history, t.translate("history"), 1, selectedIndex, onTap),

          const SizedBox(width: 40),

          navItem(Icons.eco, t.translate("fertilizer"), 3, selectedIndex, onTap),
          navItem(Icons.settings, t.translate("settings"), 4, selectedIndex, onTap),

        ],
      ),
    ),
  );
}

Widget navItem(
  IconData icon,
  String label,
  int index,
  int selectedIndex,
  Function(int) onTap,
) {

  bool isActive = index == selectedIndex;

  return GestureDetector(
    onTap: () => onTap(index),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          icon,
          color: isActive ? AppColors.primaryGreen : AppColors.grey,
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? AppColors.primaryGreen : AppColors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    ),
  );
}
