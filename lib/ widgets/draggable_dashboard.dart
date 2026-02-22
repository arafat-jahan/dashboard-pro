import 'package:flutter/material.dart';
import '../models/dashboard_card_model.dart';
import 'animated_dashboard_card.dart';

class DraggableDashboard extends StatefulWidget {
  final List<DashboardCardModel> cards;

  const DraggableDashboard({super.key, required this.cards});

  @override
  State<DraggableDashboard> createState() => _DraggableDashboardState();
}

class _DraggableDashboardState extends State<DraggableDashboard> {
  late List<DashboardCardModel> _cards;

  @override
  void initState() {
    super.initState();
    _cards = List.from(widget.cards);
  }

  void _reorderCard(
      DashboardCardModel draggedCard,
      DashboardCardModel targetCard,
      ) {
    final oldIndex = _cards.indexOf(draggedCard);
    final newIndex = _cards.indexOf(targetCard);

    if (oldIndex == newIndex) return;

    setState(() {
      final item = _cards.removeAt(oldIndex);
      _cards.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Wrap(
        key: ValueKey(_cards.hashCode),
        spacing: 16,
        runSpacing: 16,
        children: _cards.map((card) {
          return LongPressDraggable<DashboardCardModel>(
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
              opacity: 0.15,
              child: SizedBox(
                width: cardWidth,
                child: AnimatedDashboardCard(model: card),
              ),
            ),

            child: DragTarget<DashboardCardModel>(
              onWillAccept: (data) => true,
              onAccept: (receivedCard) {
                _reorderCard(receivedCard, card);
              },
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: isHovering
                        ? Border.all(
                      color: Colors.indigo,
                      width: 2,
                    )
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
    );
  }
}