import 'package:flutter/material.dart';

class DashboardCardModel {
  final String id; // ✅ MUST for reorder
  final String title;
  final IconData icon;
  final Color color;
  final String? value;
  final String? subtitle;
  final double? progress;
  final String? trend;
  final String? description;
  final String? lastUpdated;

  DashboardCardModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.value,
    this.subtitle,
    this.progress,
    this.trend,
    this.description,
    this.lastUpdated,
  });
}