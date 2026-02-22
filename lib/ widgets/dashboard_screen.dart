import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'animated_dashboard_card.dart';
import 'chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List cards = List.from(dashboardCards);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "VistaPanel Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          /// DASHBOARD GRID
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: cards.map((card) {
                  return LongPressDraggable(
                    data: card,
                    feedback: Material(
                      elevation: 12,
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: cardWidth,
                        child: AnimatedDashboardCard(model: card),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: SizedBox(
                        width: cardWidth,
                        child: AnimatedDashboardCard(model: card),
                      ),
                    ),
                    child: DragTarget(
                      onWillAccept: (data) => true,
                      onAccept: (receivedItem) {
                        setState(() {
                          int oldIndex = cards.indexOf(receivedItem);
                          int newIndex = cards.indexOf(card);

                          final item = cards.removeAt(oldIndex);
                          cards.insert(newIndex, item);
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        final isReceiving = candidateData.isNotEmpty;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: isReceiving
                                ? Border.all(
                              color: Colors.indigo,
                              width: 2,
                            )
                                : null,
                            boxShadow: isReceiving
                                ? [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              )
                            ]
                                : null,
                          ),
                          child: SizedBox(
                            width: cardWidth,
                            child: AnimatedDashboardCard(model: card),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          /// CHART SECTION TITLE
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Analytics Overview",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),

          /// CHART SECTION
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 8,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 460, // stacked line+bar chart height
                    child: ChartWidget(), // Professional stacked/swappable chart
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }
}