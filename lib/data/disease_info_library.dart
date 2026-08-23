// Content sourced from the Rice Research & Development Institute (RRDI),
// Department of Agriculture, Sri Lanka:
//   https://doa.gov.lk/rrdi_ricediseases_brownspot/
//   https://doa.gov.lk/rrdi_ricediseases_riceblast/
//   https://doa.gov.lk/rrdi_ricediseases_leafscald/

import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class DiseaseInfoArticle {
  final String nameKey;
  final String imageAsset;
  final Color color;
  final String causativeKey;
  final String affectedPartsKey;
  final String symptomsKey;
  final String? conditionsKey;
  final String? chemicalKey;
  final String managementSeasonKey;
  final String managementNextSeasonKey;
  final String? varietiesKey;
  final String sourceUrl;

  const DiseaseInfoArticle({
    required this.nameKey,
    required this.imageAsset,
    required this.color,
    required this.causativeKey,
    required this.affectedPartsKey,
    required this.symptomsKey,
    this.conditionsKey,
    this.chemicalKey,
    required this.managementSeasonKey,
    required this.managementNextSeasonKey,
    this.varietiesKey,
    required this.sourceUrl,
  });
}

const Map<String, DiseaseInfoArticle> diseaseInfoLibrary = {
  "paddy_blast": DiseaseInfoArticle(
    nameKey: "paddy_blast",
    imageAsset: "assets/images/rice_blast.png",
    color: AppColors.errorRed,
    causativeKey: "paddy_blast_info_causative",
    affectedPartsKey: "paddy_blast_info_affected",
    symptomsKey: "paddy_blast_info_symptoms",
    conditionsKey: "paddy_blast_info_conditions",
    chemicalKey: "paddy_blast_info_chemical",
    managementSeasonKey: "paddy_blast_info_management_season",
    managementNextSeasonKey: "paddy_blast_info_management_next",
    varietiesKey: "paddy_blast_info_varieties",
    sourceUrl: "https://doa.gov.lk/rrdi_ricediseases_riceblast/",
  ),
  "brown_spot": DiseaseInfoArticle(
    nameKey: "brown_spot",
    imageAsset: "assets/images/brown_spot.png",
    color: Colors.orange,
    causativeKey: "brown_spot_info_causative",
    affectedPartsKey: "brown_spot_info_affected",
    symptomsKey: "brown_spot_info_symptoms",
    conditionsKey: "brown_spot_info_conditions",
    managementSeasonKey: "brown_spot_info_management_season",
    managementNextSeasonKey: "brown_spot_info_management_next",
    sourceUrl: "https://doa.gov.lk/rrdi_ricediseases_brownspot/",
  ),
  "bacterial_leaf_blight": DiseaseInfoArticle(
    nameKey: "bacterial_leaf_blight",
    imageAsset: "assets/images/bacterial_leaf_blight.png",
    color: Colors.amber,
    causativeKey: "bacterial_leaf_blight_info_causative",
    affectedPartsKey: "bacterial_leaf_blight_info_affected",
    symptomsKey: "bacterial_leaf_blight_info_symptoms",
    managementSeasonKey: "bacterial_leaf_blight_info_management_season",
    managementNextSeasonKey: "bacterial_leaf_blight_info_management_next",
    sourceUrl: "https://doa.gov.lk/rrdi_ricediseases_bacterialleafblight/",
  ),
};
