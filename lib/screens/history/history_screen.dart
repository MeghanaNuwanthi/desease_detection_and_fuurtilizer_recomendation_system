import 'dart:io';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';
import '../../data/disease_catalog.dart';
import '../../services/history_service.dart';
import '../scan_result/scan_result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<ScanHistoryEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _entriesFuture = HistoryService.instance.getAllEntries();
  }

  void _refresh() {
    setState(() {
      _entriesFuture = HistoryService.instance.getAllEntries();
    });
  }

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

      body: FutureBuilder<List<ScanHistoryEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history, size: 60, color: AppColors.grey),
                    const SizedBox(height: 15),
                    const Text(
                      "No scans yet. Scan a crop to see it here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final info = diseaseInfoFor(entry.diseaseKey);

                return historyCard(
                  context,
                  disease: t.translate(info.nameKey),
                  date: _formatDate(entry.scannedAt),
                  confidence: entry.confidencePercent,
                  severity: t.translate(info.severityKey),
                  imagePath: entry.imagePath,
                  onTap: () async {
                    // Push and wait - if the user deletes/re-saves anything
                    // while viewing, refresh the list on return.
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanResultScreen(
                          imagePath: entry.imagePath,
                          diseaseKey: entry.diseaseKey,
                          confidencePercent: entry.confidencePercent,
                          isFromHistory: true,
                        ),
                      ),
                    );
                    _refresh();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
  }
}

Widget historyCard(
  BuildContext context, {
  required String disease,
  required String date,
  required String confidence,
  required String severity,
  required String imagePath,
  required VoidCallback onTap,
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

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          children: [
            /// Leaf Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: File(imagePath).existsSync()
                  ? Image.file(
                      File(imagePath),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: AppColors.lightGreenBackground,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.grey,
                      ),
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
                    style: const TextStyle(color: AppColors.grey, fontSize: 12),
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
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    ),
  );
}
