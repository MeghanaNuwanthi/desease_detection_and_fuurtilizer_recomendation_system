import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../scan_result/scan_result_screen.dart';

class ScanLoadingScreen extends StatefulWidget {

  final String imagePath;

  const ScanLoadingScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<ScanLoadingScreen> createState() => _ScanLoadingScreenState();
}

class _ScanLoadingScreenState extends State<ScanLoadingScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 200).animate(controller);

    /// Simulate AI prediction
    Timer(const Duration(seconds: 4), () {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultScreen(
            imagePath: widget.imagePath,
          ),
        ),
      );

    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(widget.imagePath),
                width: 260,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),

            /// Scanning Line
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {

                return Positioned(
                  top: animation.value,
                  child: Container(
                    width: 260,
                    height: 3,
                    color: Colors.greenAccent,
                  ),
                );
              },
            ),

            /// Text
            Positioned(
              bottom: -80,
              child: Column(
                children: const [

                  CircularProgressIndicator(
                    color: Colors.green,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "AI is analyzing the crop...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}