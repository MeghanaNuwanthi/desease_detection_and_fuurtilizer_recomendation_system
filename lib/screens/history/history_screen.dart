import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        title: Text(t.translate("history")),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          historyCard(
            context,
            disease: t.translate("paddy_blast"),
            date: "12 Oct 2026",
            confidence: "92%",
            severity: t.translate("high"),
            image: "assets/images/rice_blast.png",
          ),

          historyCard(
            context,
            disease: t.translate("brown_spot"),
            date: "10 Oct 2026",
            confidence: "87%",
            severity: t.translate("medium"),
            image: "assets/images/brown_spot.png",
          ),

          historyCard(
            context,
            disease: t.translate("healthy_leaf"),
            date: "08 Oct 2026",
            confidence: "95%",
            severity: t.translate("low"),
            image: "assets/images/paddy.jpg",
          ),

        ],
      ),
    );
  }
}

Widget historyCard(
  BuildContext context, {
  required String disease,
  required String date,
  required String confidence,
  required String severity,
  required String image,
}) {

  final t = AppLocalization.of(context);

  Color severityColor;

  if (severity == t.translate("high")) {
    severityColor = Colors.red;
  } else if (severity == t.translate("medium")) {
    severityColor = Colors.orange;
  } else {
    severityColor = Colors.green;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 18),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
        )
      ],
    ),

    child: Padding(
      padding: const EdgeInsets.all(14),

      child: Row(
        children: [

          /// Leaf Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          /// Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  disease,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [

                    /// Severity badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Text(
                        severity,
                        style: TextStyle(
                          color: severityColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Confidence
                    Text(
                      "${t.translate("confidence")}: $confidence",
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          )
        ],
      ),
    ),
  );
}