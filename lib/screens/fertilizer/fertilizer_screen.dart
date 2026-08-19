import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';

class FertilizerScreen extends StatelessWidget {
  const FertilizerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);

    return Scaffold(

      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        title: Text(t.translate("fertilizer_guide")),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          fertilizerCard(
            t.translate("nitrogen"),
            t.translate("nitrogen_desc"),
            t.translate("nitrogen_rec"),
            Icons.grass,
          ),

          fertilizerCard(
            t.translate("phosphorus"),
            t.translate("phosphorus_desc"),
            t.translate("phosphorus_rec"),
            Icons.eco,
          ),

          fertilizerCard(
            t.translate("potassium"),
            t.translate("potassium_desc"),
            t.translate("potassium_rec"),
            Icons.local_florist,
          ),

          fertilizerCard(
            t.translate("organic_fertilizer"),
            t.translate("organic_desc"),
            t.translate("organic_rec"),
            Icons.energy_savings_leaf,
          ),
        ],
      ),
    );
  }

  Widget fertilizerCard(
      String title,
      String description,
      String recommendation,
      IconData icon,
      ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [

          Icon(icon,size: 40,color: AppColors.primaryGreen),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 6),

                Text(
                  recommendation,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}