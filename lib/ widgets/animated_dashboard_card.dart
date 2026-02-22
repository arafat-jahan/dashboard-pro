import 'package:flutter/material.dart';
import '../models/dashboard_card_model.dart';

class AnimatedDashboardCard extends StatefulWidget {
  final DashboardCardModel model;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const AnimatedDashboardCard({
    super.key,
    required this.model,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  State<AnimatedDashboardCard> createState() =>
      _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimatedDashboardCard>
    with TickerProviderStateMixin {

  bool isExpanded = false;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  void toggleCard() {
    setState(() {
      isExpanded = !isExpanded;
      isExpanded ? _iconController.forward() : _iconController.reverse();
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCard,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          widget.onSwipeLeft?.call();
        } else if (details.primaryVelocity! > 0) {
          widget.onSwipeRight?.call();
        }
      },
      child: AnimatedScale(
        scale: isExpanded ? 1.02 : 1,
        duration: const Duration(milliseconds: 300),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.model.color.withOpacity(0.9),
                  widget.model.color,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                  color: widget.model.color.withOpacity(0.4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(widget.model.icon,
                        color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.model.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5)
                          .animate(_iconController),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                if (isExpanded)
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _iconController,
                      curve: Curves.easeIn,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Divider(color: Colors.white54),
                          SizedBox(height: 8),
                          Text(
                            "Expanded Analytics Content",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}