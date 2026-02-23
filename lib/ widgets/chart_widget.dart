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

  /// expand state per card
  Map<String, bool> expandedState = {
    "main": false,
    "pie": false,
  };

  /// card order
  List<String> cardOrder = ["main", "pie"];

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

  void swapCards(String from, String to) {
    setState(() {
      int fromIndex = cardOrder.indexOf(from);
      int toIndex = cardOrder.indexOf(to);

      final temp = cardOrder[fromIndex];
      cardOrder[fromIndex] = cardOrder[toIndex];
      cardOrder[toIndex] = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: cardOrder
                  .map((id) => _buildDraggableCard(id))
                  .toList(),
            ),
          ),
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
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }

  /// ---------------- DRAGGABLE ----------------
  Widget _buildDraggableCard(String id) {
    return DragTarget<String>(
      onWillAccept: (data) {
        if (data != null && data != id) {
          swapCards(data, id);
        }
        return true;
      },
      builder: (context, candidate, rejected) {
        return LongPressDraggable<String>(
          data: id,
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: _buildCard(id, ValueKey("feedback_$id")),
            ),
          ),
          child: _buildCard(id, ValueKey(id)),
        );
      },
    );
  }

  /// ---------------- CARD ----------------
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
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8)
          ],
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
                duration:
                const Duration(milliseconds: 400),
                child: selectedChart == 0
                    ? _buildLineChart()
                    : _buildBarChart(),
              ),
            ),
          ],
        )
            : _buildPieChart(),
      ),
    );
  }

  Widget _buildToggleButton(String text, int index) {
    final isActive = selectedChart == index;

    return GestureDetector(
      onTap: () => switchChart(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
        const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color:
          isActive ? Colors.indigo : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
              color:
              isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                values.length,
                    (i) => FlSpot(i.toDouble(), values[i])),
            isCurved: true,
            barWidth: 4,
            gradient: const LinearGradient(
              colors: [Colors.indigo, Colors.blue],
            ),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

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
                  colors: [
                    Colors.deepPurple,
                    Colors.indigo
                  ],
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

  Widget _buildPieChart() {
    return PieChart(
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
                    response.touchedSection!
                        .touchedSectionIndex;
              }
            });
          },
        ),
        sections: List.generate(pieValues.length, (i) {
          final isTouched = i == touchedPieIndex;
          final radius = isTouched ? 80.0 : 65.0;

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
                color: Colors.white),
            color: colors[i],
          );
        }),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}