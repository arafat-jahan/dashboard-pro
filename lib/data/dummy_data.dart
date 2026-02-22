import 'package:flutter/material.dart';
import '../models/dashboard_card_model.dart';

List<DashboardCardModel> dashboardCards = [
  DashboardCardModel(
    title: "Total Customers",
    icon: Icons.people,
    color: Colors.orange,
  ),
  DashboardCardModel(
    title: "Total Drivers",
    icon: Icons.drive_eta,
    color: Colors.blue,
  ),
  DashboardCardModel(
    title: "Total Rides",
    icon: Icons.local_taxi,
    color: Colors.green,
  ),
  DashboardCardModel(
    title: "Revenue",
    icon: Icons.attach_money,
    color: Colors.brown,
  ),
];