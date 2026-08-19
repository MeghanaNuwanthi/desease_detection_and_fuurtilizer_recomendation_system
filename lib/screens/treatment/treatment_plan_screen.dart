import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';

class TreatmentPlanScreen extends StatelessWidget {

  final String diseaseName;

  const TreatmentPlanScreen({
    super.key,
    required this.diseaseName,
  });

  void saveResult(BuildContext context) {

    final t = AppLocalization.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.translate("result_saved")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);

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

            /// Disease Description
            sectionCard(
              t.translate("disease_overview"),
              t.translate("disease_overview_text"),
              Icons.info_outline,
            ),

            const SizedBox(height: 15),

            /// Water Management
            sectionCard(
              t.translate("water_management"),
              t.translate("water_management_text"),
              Icons.water_drop,
            ),

            const SizedBox(height: 15),

            /// Fertilizer Recommendation
            sectionCard(
              t.translate("fertilizer_recommendation_title"),
              t.translate("fertilizer_recommendation_text"),
              Icons.eco,
            ),

            const SizedBox(height: 15),

            /// Chemical Treatment
            sectionCard(
              t.translate("chemical_treatment"),
              t.translate("chemical_treatment_text"),
              Icons.science,
            ),

            const SizedBox(height: 15),

            /// Prevention
            sectionCard(
              t.translate("prevention_tips"),
              t.translate("prevention_tips_text"),
              Icons.shield,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                onPressed: () {
                  saveResult(context);
                },

                icon: const Icon(Icons.save,color: Colors.white),

                label: Text(
                  t.translate("save_result"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 45)

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

          Icon(icon,color: AppColors.primaryGreen,size: 28),

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
                  style: const TextStyle(
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}