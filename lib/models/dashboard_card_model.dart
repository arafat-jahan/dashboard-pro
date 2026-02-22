import 'package:flutter/material.dart';

class DashboardCardModel {
  final String title;
  final IconData icon;
  final Color color;
  final String? value;        // main metric
  final String? subtitle;     // secondary info
  final double? progress;     // 0.0 to 1.0, survey completion
  final String? trend;        // "up", "down", "neutral"
  final String? description;  // short insight
  final String? lastUpdated;  // date/time

  DashboardCardModel({
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