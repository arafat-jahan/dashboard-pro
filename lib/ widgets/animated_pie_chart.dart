import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedPieChart extends StatefulWidget {
  const AnimatedPieChart({super.key});

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart> {

  int touchedIndex = -1;

  List<double> values = [40, 30, 15, 15];

  void randomizeData() {
    final random = Random();
    setState(() {
      values = List.generate(4, (_) => random.nextInt(50) + 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: List.generate(values.length, (i) {
                final isTouched = i == touchedIndex;
                final double radius = isTouched ? 80 : 65;

                final colors = [
                  Colors.indigo,
                  Colors.blue,
                  Colors.teal,
                  Colors.orange,
                ];

                return PieChartSectionData(
                  value: values[i],
                  radius: radius,
                  title: "${values[i].toInt()}%",
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
            swapAnimationDuration: const Duration(milliseconds: 700),
            swapAnimationCurve: Curves.easeInOut,
          ),
        ),

        const SizedBox(height: 16),

        ElevatedButton.icon(
          onPressed: randomizeData,
          icon: const Icon(Icons.refresh),
          label: const Text("Update Pie Data"),
        )
      ],
    );
  }
}