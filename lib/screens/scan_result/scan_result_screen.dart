import 'dart:io';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';
import '../treatment/treatment_plan_screen.dart';

class ScanResultScreen extends StatelessWidget {

  final String imagePath;

  const ScanResultScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);

    return Scaffold(

      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t.translate("analysis_result"),
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Captured Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(imagePath),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 25),

            /// Disease Card
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    t.translate("detected_disease"),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Paddy Blast",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.errorRed,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    t.translate("disease_description"),
                    style: const TextStyle(color: AppColors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Confidence + Severity
            Row(
              children: [

                Expanded(
                  child: resultCard(
                    title: t.translate("confidence"),
                    value: "92%",
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: resultCard(
                    title: t.translate("severity"),
                    value: t.translate("high"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// Recommendation
            Container(
              padding: const EdgeInsets.all(16),

              decoration: const BoxDecoration(
                color: Color(0xff143814),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),

              child: Row(
                children: [

                  const Icon(Icons.eco,color: Colors.white),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      t.translate("fertilizer_recommendation"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            /// Treatment Button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TreatmentPlanScreen(
                        diseaseName: "Paddy Blast",
                      ),
                    ),
                  );

                },

                child: Text(
                  t.translate("view_treatment_plan"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Scan Again
            SizedBox(
              width: double.infinity,

              child: OutlinedButton(

                onPressed: () {
                  Navigator.pop(context);
                },

                child: Text(
                  t.translate("scan_again"),
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

Widget resultCard({
  required String title,
  required String value,
}) {

  return Container(
    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),

    child: Column(
      children: [

        Text(
          title,
          style: const TextStyle(color: AppColors.grey),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}