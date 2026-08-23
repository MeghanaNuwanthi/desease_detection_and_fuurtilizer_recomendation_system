// lib/data/disease_catalog.dart
//
// Central place mapping a raw classifier label (from labels.txt) to display
// info AND full treatment plan content. Both scan_result_screen.dart,
// treatment_plan_screen.dart, and home_screen.dart's disease slider pull
// from here so nothing drifts out of sync.

import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class DiseaseInfo {
  final String nameKey;
  final String descriptionKey; // short blurb shown on the result card
  final String severityKey; // "high" | "medium" | "low"
  final Color color;
  final String imageAsset; // shown on the home page disease slider card

  // Full treatment plan content - null for healthy_leaf.
  final String? overviewKey;
  final String? waterKey;
  final String? fertilizerKey;
  final String? chemicalKey;
  final String? preventionKey;

  const DiseaseInfo({
    required this.nameKey,
    required this.descriptionKey,
    required this.severityKey,
    required this.color,
    required this.imageAsset,
    this.overviewKey,
    this.waterKey,
    this.fertilizerKey,
    this.chemicalKey,
    this.preventionKey,
  });
}

const Map<String, DiseaseInfo> diseaseCatalog = {
  "paddy_blast": DiseaseInfo(
    nameKey: "paddy_blast",
    descriptionKey: "paddy_blast_description",
    severityKey: "high",
    color: AppColors.errorRed,
    imageAsset: "assets/images/rice_blast.png",
    overviewKey: "paddy_blast_overview_text",
    waterKey: "paddy_blast_water_text",
    fertilizerKey: "paddy_blast_fertilizer_text",
    chemicalKey: "paddy_blast_chemical_text",
    preventionKey: "paddy_blast_prevention_text",
  ),
  "brown_spot": DiseaseInfo(
    nameKey: "brown_spot",
    descriptionKey: "brown_spot_description",
    severityKey: "medium",
    color: Colors.orange,
    imageAsset: "assets/images/brown_spot.png",
    overviewKey: "brown_spot_overview_text",
    waterKey: "brown_spot_water_text",
    fertilizerKey: "brown_spot_fertilizer_text",
    chemicalKey: "brown_spot_chemical_text",
    preventionKey: "brown_spot_prevention_text",
  ),
  "bacterial_leaf_blight": DiseaseInfo(
    nameKey: "bacterial_leaf_blight",
    descriptionKey: "bacterial_leaf_blight_description",
    severityKey: "high",
    color: AppColors.errorRed,
    imageAsset: "assets/images/bacterial_leaf_blight.png",
    overviewKey: "bacterial_leaf_blight_overview_text",
    waterKey: "bacterial_leaf_blight_water_text",
    fertilizerKey: "bacterial_leaf_blight_fertilizer_text",
    chemicalKey: "bacterial_leaf_blight_chemical_text",
    preventionKey: "bacterial_leaf_blight_prevention_text",
  ),
  "healthy_leaf": DiseaseInfo(
    nameKey: "healthy_leaf",
    descriptionKey: "healthy_leaf_description",
    severityKey: "low",
    color: AppColors.primaryGreen,
    imageAsset: "assets/images/paddy.jpg",
    // nothing to treat
  ),
};

DiseaseInfo diseaseInfoFor(String diseaseKey) {
  return diseaseCatalog[diseaseKey] ?? diseaseCatalog["paddy_blast"]!;
}
