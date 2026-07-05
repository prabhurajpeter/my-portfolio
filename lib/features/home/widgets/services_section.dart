import 'package:flutter/material.dart';
import 'package:protfolio/widgets/app_selection_area.dart';
import 'package:protfolio/widgets/glass_card.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return AppSelectionArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: 64,
        ),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🏷️ Category Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "WHAT I DO",
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 📝 Main Headline
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      TextSpan(
                        text: "Services ",
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: "I Provide",
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // 📦 Services Grid
                isMobile
                    ? Column(
                        children: const [
                          _ServiceCard(
                            icon: Icons.phone_android,
                            title: "Mobile App Development",
                            desc: "Building cross-platform mobile apps using Flutter with clean code and powerful performance.",
                          ),
                          SizedBox(height: 24),
                          _ServiceCard(
                            icon: Icons.brush,
                            title: "UI/UX Design",
                            desc: "Designing intuitive and engaging interfaces that provide great user experiences.",
                          ),
                          SizedBox(height: 24),
                          _ServiceCard(
                            icon: Icons.build,
                            title: "Problem Solving",
                            desc: "Solving complex problems with efficient solutions and clean architecture.",
                          ),
                        ],
                      )
                    : Row(
                        children: const [
                          Expanded(
                            child: _ServiceCard(
                              icon: Icons.phone_android,
                              title: "Mobile App Development",
                              desc: "Building cross-platform mobile apps using Flutter with clean code and powerful performance.",
                            ),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: _ServiceCard(
                              icon: Icons.brush,
                              title: "UI/UX Design",
                              desc: "Designing intuitive and engaging interfaces that provide great user experiences.",
                            ),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: _ServiceCard(
                              icon: Icons.build,
                              title: "Problem Solving",
                              desc: "Solving complex problems with efficient solutions and clean architecture.",
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0.0, _hovered ? -8.0 : 0.0, 0.0),
        child: GlassCard(
          borderRadius: 20,
          border: Border.all(
            color: _hovered
                ? theme.colorScheme.primary.withValues(alpha: 0.45)
                : theme.colorScheme.outline.withValues(alpha: 0.15),
            width: 1.2,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: theme.colorScheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Description
                Text(
                  widget.desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Explore Link
                Row(
                  children: [
                    Text(
                      "Explore",
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
