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

  Map<String, bool> expandedState = {
    "main": false,
    "pie": false,
  };

  List<String> cardOrder = ["main", "pie"];

  void randomizeData() {
    setState(() {
      values = List.generate(values.length, (_) => random.nextDouble() * 10 + 1);
      pieValues = List.generate(4, (_) => random.nextInt(50).toDouble() + 10);
    });
  }

  void switchChart(int index) {
    setState(() {
      selectedChart = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: ReorderableListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cardOrder.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = cardOrder.removeAt(oldIndex);
              cardOrder.insert(newIndex, item);
            });
          },
          itemBuilder: (context, index) {
            final id = cardOrder[index];
            return _buildCard(id, ValueKey(id));
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton.extended(
          onPressed: randomizeData,
          label: const Text("Randomize Data"),
          icon: const Icon(Icons.refresh),
          backgroundColor: Colors.indigo,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ================= CARD =================
  Widget _buildCard(String id, Key key) {
    bool isExpanded = expandedState[id]!;

    return GestureDetector(
      key: key,
      onTap: () {
        setState(() {
          expandedState[id] = !expandedState[id]!;
        });
      },
      onHorizontalDragEnd: (details) {
        if (id == "main" && details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            switchChart((selectedChart + 1) % 2);
          } else if (details.primaryVelocity! > 0) {
            switchChart((selectedChart - 1 + 2) % 2);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        height: isExpanded ? 420 : 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: id == "main"
            ? Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton("Line", 0),
                const SizedBox(width: 12),
                _buildToggleButton("Bar", 1),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: selectedChart == 0 ? _buildLineChart() : _buildBarChart(),
              ),
            ),
          ],
        )
            : _buildPieChart(),
      ),
    );
  }

  // ================= TOGGLE BUTTON =================
  Widget _buildToggleButton(String text, int index) {
    final isActive = selectedChart == index;

    return GestureDetector(
      onTap: () => switchChart(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
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

  // ================= LINE CHART =================
  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i])),
            isCurved: true,
            barWidth: 4,
            gradient: const LinearGradient(colors: [Colors.indigo, Colors.blue]),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  // ================= BAR CHART =================
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
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
    );
  }

  // ================= PIE CHART =================
  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: List.generate(pieValues.length, (i) {
          final isTouched = i == touchedPieIndex;
          return PieChartSectionData(
            value: pieValues[i],
            radius: isTouched ? 70 : 60,
            color: Colors.primaries[i % Colors.primaries.length],
            title: "${pieValues[i].toInt()}%",
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  response == null ||
                  response.touchedSection == null) {
                touchedPieIndex = -1;
                return;
              }
              touchedPieIndex = response.touchedSection!.touchedSectionIndex;
            });
          },
        ),
      ),
    );
  }
}