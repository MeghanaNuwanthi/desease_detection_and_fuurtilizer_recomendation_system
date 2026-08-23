class FertilizerStage {
  final String stageLabel; // e.g. "Basic", "2 Weeks"
  final int ureaKgPerHa;
  final int tspKgPerHa;
  final int mopKgPerHa;
  final int zincSulphateKgPerHa;

  const FertilizerStage({
    required this.stageLabel,
    this.ureaKgPerHa = 0,
    this.tspKgPerHa = 0,
    this.mopKgPerHa = 0,
    this.zincSulphateKgPerHa = 0,
  });
}

class FertilizerDurationPlan {
  final String durationLabel; // "3 Month", "3 1/2 Month", "4 Month"
  final List<FertilizerStage> stages;

  const FertilizerDurationPlan({
    required this.durationLabel,
    required this.stages,
  });

  int get totalUrea => stages.fold(0, (sum, s) => sum + s.ureaKgPerHa);
  int get totalTsp => stages.fold(0, (sum, s) => sum + s.tspKgPerHa);
  int get totalMop => stages.fold(0, (sum, s) => sum + s.mopKgPerHa);
  int get totalZinc => stages.fold(0, (sum, s) => sum + s.zincSulphateKgPerHa);
}

class FertilizerWaterCondition {
  final String conditionLabel; // "Irrigated" | "Rainfed"
  final String applicableDistricts;
  final List<FertilizerDurationPlan> durationPlans;

  const FertilizerWaterCondition({
    required this.conditionLabel,
    required this.applicableDistricts,
    required this.durationPlans,
  });
}

const String fertilizerSourceUrlIrrigated =
    "https://doa.gov.lk/rrdi_fertilizerrecomendation_irrigated_wz/";
const String fertilizerSourceUrlRainfed =
    "https://doa.gov.lk/rrdi_fertilizerrecomendation_rainfed_wz/";

const String _wetZoneDistricts =
    "Kegalle, Gampaha, Colombo, Kaluthara; Matale (Yatawaththa, Ukuwela DS "
    "divisions only); Kandy (excluding Minipe, Ududumbara, Panwila, "
    "Medadumbara, Kundasale, Pathahewaheta, Delthota); Nuwara Eliya "
    "(excluding Hanguranketha, Walapane); Mathara (excluding Hakmana, "
    "Kirinda, Devinuwara, Dikwella, Thihagoda, Kamburupitiya); Rathnapura "
    "(excluding Embilipitiya, Kolonna, Balangoda, Imbulpe, Weligepola).";

const FertilizerWaterCondition irrigatedWetZone = FertilizerWaterCondition(
  conditionLabel: "Irrigated",
  applicableDistricts:
      "$_wetZoneDistricts Galle is also included under irrigated conditions.",
  durationPlans: [
    FertilizerDurationPlan(
      durationLabel: "3 Month",
      stages: [
        FertilizerStage(
          stageLabel: "Basic",
          tspKgPerHa: 35,
          zincSulphateKgPerHa: 5,
        ),
        FertilizerStage(stageLabel: "2 Weeks", ureaKgPerHa: 20),
        FertilizerStage(stageLabel: "4 Weeks", ureaKgPerHa: 55, mopKgPerHa: 25),
        FertilizerStage(stageLabel: "6 Weeks", ureaKgPerHa: 45, mopKgPerHa: 25),
        FertilizerStage(stageLabel: "7 Weeks", ureaKgPerHa: 20),
      ],
    ),
    FertilizerDurationPlan(
      durationLabel: "3 1/2 Month",
      stages: [
        FertilizerStage(
          stageLabel: "Basic",
          tspKgPerHa: 35,
          zincSulphateKgPerHa: 5,
        ),
        FertilizerStage(stageLabel: "2 Weeks", ureaKgPerHa: 20),
        FertilizerStage(stageLabel: "4 Weeks", ureaKgPerHa: 55, mopKgPerHa: 25),
        FertilizerStage(stageLabel: "6 Weeks", ureaKgPerHa: 45, mopKgPerHa: 25),
        FertilizerStage(stageLabel: "8 Weeks", ureaKgPerHa: 20),
      ],
    ),
    FertilizerDurationPlan(
      durationLabel: "4 Month",
      stages: [
        FertilizerStage(
          stageLabel: "Basic",
          tspKgPerHa: 35,
          zincSulphateKgPerHa: 5,
        ),
        FertilizerStage(stageLabel: "2 Weeks", ureaKgPerHa: 20),
        FertilizerStage(stageLabel: "4 Weeks", ureaKgPerHa: 55, mopKgPerHa: 25),
        FertilizerStage(stageLabel: "7 Weeks", ureaKgPerHa: 45, mopKgPerHa: 25),
        FertilizerStage(stageLabel: "9 Weeks", ureaKgPerHa: 20),
      ],
    ),
  ],
);

const FertilizerWaterCondition rainfedWetZone = FertilizerWaterCondition(
  conditionLabel: "Rainfed",
  applicableDistricts: _wetZoneDistricts,
  durationPlans: [
    FertilizerDurationPlan(
      durationLabel: "3 Month",
      stages: [
        FertilizerStage(
          stageLabel: "Basic",
          tspKgPerHa: 55,
          zincSulphateKgPerHa: 5,
        ),
        FertilizerStage(stageLabel: "2 Weeks", ureaKgPerHa: 25, mopKgPerHa: 35),
        FertilizerStage(stageLabel: "4 Weeks", ureaKgPerHa: 30, mopKgPerHa: 45),
        FertilizerStage(stageLabel: "6 Weeks", ureaKgPerHa: 25, mopKgPerHa: 30),
        FertilizerStage(stageLabel: "7 Weeks", ureaKgPerHa: 20),
      ],
    ),
    FertilizerDurationPlan(
      durationLabel: "3 1/2 Month",
      stages: [
        FertilizerStage(
          stageLabel: "Basic",
          tspKgPerHa: 55,
          zincSulphateKgPerHa: 5,
        ),
        FertilizerStage(stageLabel: "2 Weeks", ureaKgPerHa: 25, mopKgPerHa: 35),
        FertilizerStage(stageLabel: "4 Weeks", ureaKgPerHa: 30, mopKgPerHa: 45),
        FertilizerStage(stageLabel: "6 Weeks", ureaKgPerHa: 25, mopKgPerHa: 30),
        FertilizerStage(stageLabel: "8 Weeks", ureaKgPerHa: 20),
      ],
    ),
    FertilizerDurationPlan(
      durationLabel: "4 Month",
      stages: [
        FertilizerStage(
          stageLabel: "Basic",
          tspKgPerHa: 55,
          zincSulphateKgPerHa: 5,
        ),
        FertilizerStage(stageLabel: "2 Weeks", ureaKgPerHa: 25, mopKgPerHa: 35),
        FertilizerStage(stageLabel: "4 Weeks", ureaKgPerHa: 30, mopKgPerHa: 45),
        FertilizerStage(stageLabel: "7 Weeks", ureaKgPerHa: 25, mopKgPerHa: 30),
        FertilizerStage(stageLabel: "9 Weeks", ureaKgPerHa: 20),
      ],
    ),
  ],
);
