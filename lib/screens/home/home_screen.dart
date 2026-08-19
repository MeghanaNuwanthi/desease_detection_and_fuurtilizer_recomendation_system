import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../widgets/disease_card.dart';
import '../../localization/app_localization.dart';
import '../../services/camera_service.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../fertilizer/fertilizer_screen.dart';
import '../scan/scan_loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      const SettingsScreen(),
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
              const Text(
                "THURSDAY, 12 OCT",
                style: TextStyle(
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

              weatherCard(),

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    t.translate("common_diseases"),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    t.translate("view_all"),
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 15),

              diseaseSlider(),

              const SizedBox(height: 100),

            ],
          ),
        ),
      ),
    );
  }
}

Widget weatherCard() {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xffdff5df),
      borderRadius: BorderRadius.circular(20),
    ),
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

        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ratnapura",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("High Humidity (82%)"),
          ],
        ),

        const Spacer(),

        const Text(
          "28°C",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}

Widget scanCard(BuildContext context) {

  final t = AppLocalization.of(context);
  final CameraService cameraService = CameraService();

  return Expanded(
    child: GestureDetector(

      onTap: () async {

        final image = await cameraService.captureImage();

        if (image != null) {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanLoadingScreen(
                imagePath: image.path,
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

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanLoadingScreen(
                imagePath: image.path,
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

Widget diseaseSlider() {
  return SizedBox(
    height: 250,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: const [

        DiseaseCard(
          title: "Rice Blast",
          description: "Fungal disease causing lesions on leaves.",
          image: "assets/images/rice_blast.png",
        ),

        DiseaseCard(
          title: "Brown Spot",
          description: "Brown lesions on rice leaves.",
          image: "assets/images/brown_spot.png",
        ),

        DiseaseCard(
          title: "Leaf Scald",
          description: "Grey lesions along leaf edges.",
          image: "assets/images/leaf_scald.png",
        ),
      ],
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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanLoadingScreen(
              imagePath: image.path,
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