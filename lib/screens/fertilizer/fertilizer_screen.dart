import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';
import '../../data/fertilizer_schedule_data.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {

  bool _isIrrigated = true;
  int _durationIndex = 0;

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);
    final condition = _isIrrigated ? irrigatedWetZone : rainfedWetZone;
    final plan = condition.durationPlans[_durationIndex];
    final sourceUrl =
        _isIrrigated ? fertilizerSourceUrlIrrigated : fertilizerSourceUrlRainfed;

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

          /// General nutrient overview - kept from the original screen
          Text(
            "Nutrient Basics",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 15),

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

          const SizedBox(height: 30),

          /// Official DOA schedule section
          const Text(
            "Official Rice Fertilizer Schedule",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            "Wet Zone - Rice Research & Development Institute (RRDI), "
            "Department of Agriculture, Sri Lanka",
            style: TextStyle(fontSize: 12, color: AppColors.grey),
          ),

          const SizedBox(height: 15),

          /// Irrigated / Rainfed toggle
          Row(
            children: [
              Expanded(
                child: conditionToggleButton(
                  label: "Irrigated",
                  selected: _isIrrigated,
                  onTap: () => setState(() {
                    _isIrrigated = true;
                    _durationIndex = 0;
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: conditionToggleButton(
                  label: "Rainfed",
                  selected: !_isIrrigated,
                  onTap: () => setState(() {
                    _isIrrigated = false;
                    _durationIndex = 0;
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// Applicable districts note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightGreenBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 18, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    condition.applicableDistricts,
                    style: const TextStyle(fontSize: 12, color: AppColors.black),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          /// Crop duration selector
          Row(
            children: List.generate(condition.durationPlans.length, (index) {
              final selected = index == _durationIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(condition.durationPlans[index].durationLabel),
                  selected: selected,
                  selectedColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) => setState(() => _durationIndex = index),
                ),
              );
            }),
          ),

          const SizedBox(height: 15),

          /// Schedule table
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateProperty.all(
                  AppColors.lightGreenBackground,
                ),
                columns: const [
                  DataColumn(label: Text("Stage")),
                  DataColumn(label: Text("Urea")),
                  DataColumn(label: Text("T.S.P")),
                  DataColumn(label: Text("M.O.P")),
                  DataColumn(label: Text("Zn SO₄")),
                ],
                rows: [
                  ...plan.stages.map(
                    (stage) => DataRow(cells: [
                      DataCell(Text(stage.stageLabel)),
                      DataCell(Text(_cellValue(stage.ureaKgPerHa))),
                      DataCell(Text(_cellValue(stage.tspKgPerHa))),
                      DataCell(Text(_cellValue(stage.mopKgPerHa))),
                      DataCell(Text(_cellValue(stage.zincSulphateKgPerHa))),
                    ]),
                  ),
                  DataRow(
                    color: MaterialStateProperty.all(
                      AppColors.lightGreenBackground.withOpacity(0.5),
                    ),
                    cells: [
                      const DataCell(Text(
                        "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataCell(Text(
                        "${plan.totalUrea}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataCell(Text(
                        "${plan.totalTsp}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataCell(Text(
                        "${plan.totalMop}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataCell(Text(
                        "${plan.totalZinc}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            "Figures in kg/hectare. Timing is measured from the date of "
            "field establishment.",
            style: TextStyle(fontSize: 11, color: AppColors.grey),
          ),

          const SizedBox(height: 20),

          /// Source citation + limitation note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.info_outline, size: 16, color: AppColors.grey),
                    SizedBox(width: 6),
                    Text(
                      "Source & scope",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Data reproduced from the Rice Research & Development "
                  "Institute (RRDI), Department of Agriculture, Sri Lanka: "
                  "$sourceUrl\n\n"
                  "This schedule applies to Wet Zone districts only, as "
                  "published by RRDI. Farmers outside these districts "
                  "(Dry Zone, Intermediate Zone) should consult their "
                  "regional agricultural extension office for the correct "
                  "recommendation for their area.",
                  style: const TextStyle(fontSize: 11, color: AppColors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  String _cellValue(int value) => value == 0 ? "-" : "$value";

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

  Widget conditionToggleButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
