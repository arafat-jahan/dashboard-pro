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
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return GestureDetector(
      onTap: toggleCard,
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < 0) {
          widget.onSwipeLeft?.call();
        } else if (velocity > 0) {
          widget.onSwipeRight?.call();
        }
      },
      child: AnimatedScale(
        scale: isExpanded ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            margin: EdgeInsets.symmetric(
              vertical: isMobile ? 8 : 10,
              horizontal: isMobile ? 12 : 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.model.color.withOpacity(0.9),
                  widget.model.color,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                  color: widget.model.color.withOpacity(0.35),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      widget.model.icon,
                      color: Colors.white,
                      size: isMobile ? 22 : 28,
                    ),
                    const SizedBox(width: 10),

                    /// Title
                    Expanded(
                      child: Text(
                        widget.model.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5)
                          .animate(_iconController),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: isMobile ? 22 : 28,
                      ),
                    ),
                  ],
                ),

                /// MAIN VALUE
                Padding(
                  padding: EdgeInsets.only(top: isMobile ? 8 : 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          widget.model.value ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 18 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.model.subtitle ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isMobile ? 11 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// PROGRESS
                if (widget.model.progress != null) ...[
                  SizedBox(height: isMobile ? 8 : 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: widget.model.progress!.clamp(0.0, 1.0),
                      backgroundColor: Colors.white24,
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: isMobile ? 6 : 8,
                    ),
                  ),
                ],

                /// EXPANDED SECTION
                if (isExpanded)
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _iconController,
                      curve: Curves.easeIn,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: isMobile ? 12 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: Colors.white54),
                          const SizedBox(height: 8),
                          Text(
                            widget.model.description ??
                                "No details available",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isMobile ? 12 : 14,
                            ),
                          ),
                          if (widget.model.lastUpdated != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                "Last Updated: ${widget.model.lastUpdated}",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: isMobile ? 11 : 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
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