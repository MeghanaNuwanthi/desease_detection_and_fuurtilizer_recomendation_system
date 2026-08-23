import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';
import '../../data/disease_info_library.dart';

class DiseaseInfoDetailScreen extends StatelessWidget {

  /// Key into diseaseInfoLibrary, e.g. "paddy_blast", "leaf_scald".
  final String diseaseKey;

  const DiseaseInfoDetailScreen({
    super.key,
    required this.diseaseKey,
  });

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);
    final article = diseaseInfoLibrary[diseaseKey];

    if (article == null) {
      // Shouldn't happen if navigation only ever uses keys from the
      // library, but fail safely instead of crashing if it ever does.
      return Scaffold(
        appBar: AppBar(title: const Text("Disease Info")),
        body: const Center(child: Text("Information not available.")),
      );
    }

    return Scaffold(

      backgroundColor: const Color(0xfff5f5f5),

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                t.translate(article.nameKey),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                ),
              ),
              background: Image.asset(
                article.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: article.color.withOpacity(0.2),
                  child: Icon(Icons.eco, color: article.color, size: 60),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                infoSection(
                  t.translate("causative_agent"),
                  t.translate(article.causativeKey),
                  Icons.biotech,
                ),

                infoSection(
                  t.translate("affected_parts"),
                  t.translate(article.affectedPartsKey),
                  Icons.grass,
                ),

                infoSection(
                  t.translate("symptoms"),
                  t.translate(article.symptomsKey),
                  Icons.search,
                ),

                if (article.conditionsKey != null)
                  infoSection(
                    t.translate("favourable_conditions"),
                    t.translate(article.conditionsKey!),
                    Icons.thermostat,
                  ),

                if (article.chemicalKey != null)
                  infoSection(
                    t.translate("chemical_treatment"),
                    t.translate(article.chemicalKey!),
                    Icons.science,
                  ),

                infoSection(
                  t.translate("management_this_season"),
                  t.translate(article.managementSeasonKey),
                  Icons.calendar_today,
                ),

                infoSection(
                  t.translate("management_next_season"),
                  t.translate(article.managementNextSeasonKey),
                  Icons.event_repeat,
                ),

                if (article.varietiesKey != null)
                  infoSection(
                    t.translate("susceptible_varieties"),
                    t.translate(article.varietiesKey!),
                    Icons.list_alt,
                  ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: AppColors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Source: Rice Research & Development Institute "
                          "(RRDI), Department of Agriculture, Sri Lanka\n"
                          "${article.sourceUrl}",
                          style: const TextStyle(fontSize: 11, color: AppColors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoSection(String title, String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 26),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
