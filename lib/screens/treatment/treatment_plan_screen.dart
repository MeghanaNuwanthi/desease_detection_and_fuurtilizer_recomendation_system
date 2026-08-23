import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';
import '../../data/disease_catalog.dart';

class TreatmentPlanScreen extends StatelessWidget {
  /// Raw label from the classifier, e.g. "paddy_blast" - drives which
  /// content is shown. This screen is only ever opened for diseased
  /// results, never "healthy_leaf".
  final String diseaseKey;

  const TreatmentPlanScreen({super.key, required this.diseaseKey});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalization.of(context);
    final info = diseaseInfoFor(diseaseKey);
    final diseaseName = t.translate(info.nameKey);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "${t.translate("treatment_plan")} - $diseaseName",
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (info.overviewKey != null)
              sectionCard(
                t.translate("disease_overview"),
                t.translate(info.overviewKey!),
                Icons.info_outline,
              ),

            if (info.overviewKey != null) const SizedBox(height: 15),

            if (info.waterKey != null)
              sectionCard(
                t.translate("water_management"),
                t.translate(info.waterKey!),
                Icons.water_drop,
              ),

            if (info.waterKey != null) const SizedBox(height: 15),

            if (info.fertilizerKey != null)
              sectionCard(
                t.translate("fertilizer_recommendation_title"),
                t.translate(info.fertilizerKey!),
                Icons.eco,
              ),

            if (info.fertilizerKey != null) const SizedBox(height: 15),

            if (info.chemicalKey != null)
              sectionCard(
                t.translate("chemical_treatment"),
                t.translate(info.chemicalKey!),
                Icons.science,
              ),

            if (info.chemicalKey != null) const SizedBox(height: 15),

            if (info.preventionKey != null)
              sectionCard(
                t.translate("prevention_tips"),
                t.translate(info.preventionKey!),
                Icons.shield,
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget sectionCard(String title, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 28),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  text,
                  style: const TextStyle(color: AppColors.grey, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
