import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget>
    with SingleTickerProviderStateMixin {

  int selectedChart = 0; // 0 = Line, 1 = Bar
  List<double> values = [3, 4, 6, 2, 5];

  void randomizeData() {
    final random = Random();
    setState(() {
      values = List.generate(
          values.length, (_) => random.nextDouble() * 10);
    });
  }

  void switchChart(int index) {
    setState(() {
      selectedChart = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// Header Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToggleButton("Line", 0),
            const SizedBox(width: 10),
            _buildToggleButton("Bar", 1),
          ],
        ),

        const SizedBox(height: 20),

        /// Swipe + Animated Switch
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              switchChart(1);
            } else {
              switchChart(0);
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: selectedChart == 0
                ? _buildLineChart()
                : _buildBarChart(),
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          onPressed: randomizeData,
          icon: const Icon(Icons.refresh),
          label: const Text("Randomize Data"),
        )
      ],
    );
  }

  Widget _buildToggleButton(String text, int index) {
    final isActive = selectedChart == index;
    return GestureDetector(
      onTap: () => switchChart(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.indigo : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      key: const ValueKey(1),
      height: 260,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                values.length,
                    (i) => FlSpot(i.toDouble(), values[i]),
              ),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.blue],
              ),
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.withOpacity(0.3),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      key: const ValueKey(2),
      height: 260,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          barGroups: List.generate(values.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.indigo],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            );
          }),
        ),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      ),
    );
  }
}