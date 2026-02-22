import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  int selectedChart = 0;
  List<double> values = [3, 4, 6, 2, 5];
  List<double> pieValues = [40, 30, 15, 15];

  int touchedPieIndex = -1;
  final Random random = Random();

  void randomizeData() {
    setState(() {
      values =
          List.generate(values.length, (_) => random.nextDouble() * 10 + 1);
      pieValues =
          List.generate(4, (_) => random.nextInt(50).toDouble() + 10);
    });
  }

  void switchChart(int index) {
    setState(() {
      selectedChart = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          /// TOGGLE BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildToggleButton("Line", 0),
              const SizedBox(width: 12),
              _buildToggleButton("Bar", 1),
            ],
          ),

          const SizedBox(height: 24),

          /// LINE / BAR SWITCHER
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
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

          const SizedBox(height: 32),

          /// PIE CHART
          _buildPieChart(),

          const SizedBox(height: 24),

          /// RANDOM BUTTON
          Center(
            child: ElevatedButton.icon(
              onPressed: randomizeData,
              icon: const Icon(Icons.refresh),
              label: const Text("Randomize Data"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// ---------------- TOGGLE BUTTON ----------------
  Widget _buildToggleButton(String text, int index) {
    final bool isActive = selectedChart == index;

    return GestureDetector(
      onTap: () => switchChart(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
        const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.indigo : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// ---------------- LINE CHART ----------------
  Widget _buildLineChart() {
    return SizedBox(
      key: const ValueKey("line"),
      height: 260,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    "P${(value + 1).toInt()}",
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                values.length,
                    (i) => FlSpot(i.toDouble(), values[i]),
              ),
              isCurved: true,
              barWidth: 4,
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.blue],
              ),
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.withOpacity(0.3),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- BAR CHART ----------------
  Widget _buildBarChart() {
    return SizedBox(
      key: const ValueKey("bar"),
      height: 260,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    "P${(value + 1).toInt()}",
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
          ),
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
      ),
    );
  }

  /// ---------------- PIE CHART ----------------
  Widget _buildPieChart() {
    return SizedBox(
      height: 260,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    response == null ||
                    response.touchedSection == null) {
                  touchedPieIndex = -1;
                } else {
                  touchedPieIndex =
                      response.touchedSection!.touchedSectionIndex;
                }
              });
            },
          ),
          sections: List.generate(pieValues.length, (i) {
            final bool isTouched = i == touchedPieIndex;
            final double radius = isTouched ? 80.0 : 65.0;

            final colors = [
              Colors.indigo,
              Colors.blue,
              Colors.teal,
              Colors.orange,
            ];

            return PieChartSectionData(
              value: pieValues[i],
              radius: radius,
              title: "${pieValues[i].toInt()}%",
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              color: colors[i],
            );
          }),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}