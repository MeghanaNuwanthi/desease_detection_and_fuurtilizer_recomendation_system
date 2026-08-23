import 'dart:io';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';
import '../../data/disease_catalog.dart';
import '../../services/history_service.dart';
import '../treatment/treatment_plan_screen.dart';

class ScanResultScreen extends StatefulWidget {
  final String imagePath;

  /// Raw label coming back from the classifier, e.g. "paddy_blast".
  final String diseaseKey;

  /// Pre-formatted confidence string, e.g. "92%".
  final String confidencePercent;

  /// True when opened by tapping a saved entry in History - hides the Save
  /// button (it's already saved) and skips the "Scan Again" action since
  /// there's no active scan session to retry.
  final bool isFromHistory;

  const ScanResultScreen({
    super.key,
    required this.imagePath,
    this.diseaseKey = "paddy_blast",
    this.confidencePercent = "--",
    this.isFromHistory = false,
  });

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  bool _saving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _saved = widget.isFromHistory;
  }

  Future<void> _saveResult() async {
    if (_saving || _saved) return;

    setState(() => _saving = true);

    try {
      await HistoryService.instance.saveEntry(
        ScanHistoryEntry(
          diseaseKey: widget.diseaseKey,
          confidencePercent: widget.confidencePercent,
          imagePath: widget.imagePath,
          scannedAt: DateTime.now(),
        ),
      );

      if (!mounted) return;

      final t = AppLocalization.of(context);
      setState(() {
        _saving = false;
        _saved = true;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.translate("result_saved"))));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not save result: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalization.of(context);

    final info = diseaseInfoFor(widget.diseaseKey);
    final diseaseName = t.translate(info.nameKey);
    final severity = t.translate(info.severityKey);
    final isHealthy = widget.diseaseKey == "healthy_leaf";
    final imageExists = File(widget.imagePath).existsSync();

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
              child: imageExists
                  ? Image.file(
                      File(widget.imagePath),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      color: AppColors.lightGreenBackground,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.grey,
                        size: 40,
                      ),
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
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    diseaseName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: info.color,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    t.translate(info.descriptionKey),
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
                    value: widget.confidencePercent,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: resultCard(
                    title: t.translate("severity"),
                    value: severity,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            if (!isHealthy) ...[
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
                    const Icon(Icons.eco, color: Colors.white),

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
                        builder: (context) =>
                            TreatmentPlanScreen(diseaseKey: widget.diseaseKey),
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
            ] else
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.lightGreenBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Your crop looks healthy. Keep up the good work!",
                        style: TextStyle(color: AppColors.black),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 15),

            /// Save Result
            if (!widget.isFromHistory)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _saved
                        ? AppColors.grey
                        : AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: _saved ? null : _saveResult,

                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          _saved ? Icons.check : Icons.save,
                          color: Colors.white,
                        ),

                  label: Text(
                    _saved
                        ? t.translate("result_saved")
                        : t.translate("save_result"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            if (!widget.isFromHistory) const SizedBox(height: 10),

            /// Scan Again
            if (!widget.isFromHistory)
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

Widget resultCard({required String title, required String value}) {
  return Container(
    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),

    child: Column(
      children: [
        Text(title, style: const TextStyle(color: AppColors.grey)),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
