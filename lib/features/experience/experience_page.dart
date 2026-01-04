import 'package:flutter/material.dart';
import 'package:protfolio/widgets/glass_card.dart';
import 'package:protfolio/widgets/section_title.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle("Experience"),
          const SizedBox(height: 40),

          Center(
            child: isMobile
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: _TimelineContent(theme: theme),
                  )
                : const _TimelineContent(),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// TIMELINE CONTENT
/// ─────────────────────────────────────────────
class _TimelineContent extends StatelessWidget {
  final ThemeData? theme;

  const _TimelineContent({this.theme});

  @override
  Widget build(BuildContext context) {
    final t = theme ?? Theme.of(context);

    return SizedBox(
      width: 900, // 🔥 fixed width enables horizontal scroll on mobile
      height: 340,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ───── TIMELINE LINE ─────
          Positioned(
            top: 170,
            left: 80,
            right: 80,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: t.colorScheme.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ───── MAIN ROW ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ExperienceNode(experience: experienceData[0], isActive: true),

              _TimelineCenter(theme: t),

              _ExperienceNode(experience: experienceData[1], isActive: false),
            ],
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// CENTER LABEL
/// ─────────────────────────────────────────────
class _TimelineCenter extends StatelessWidget {
  final ThemeData theme;

  const _TimelineCenter({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.timeline, size: 28, color: theme.colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          "Career Journey",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 6),
        Text(
          "2+ Years Experience",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────
/// EXPERIENCE NODE
/// ─────────────────────────────────────────────
class _ExperienceNode extends StatefulWidget {
  final ExperienceModel experience;
  final bool isActive;

  const _ExperienceNode({required this.experience, this.isActive = false});

  @override
  State<_ExperienceNode> createState() => _ExperienceNodeState();
}

class _ExperienceNodeState extends State<_ExperienceNode> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Column(
      children: [
        // ───── DOT + DATE ─────
        Row(
          children: [
            Container(
              width: widget.isActive ? 14 : 10,
              height: widget.isActive ? 14 : 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withOpacity(0.5),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          blurRadius: 12,
                          color: theme.colorScheme.primary.withOpacity(0.6),
                        ),
                      ]
                    : [],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.experience.period,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // ───── CARD ─────
        MouseRegion(
          onEnter: (_) => isDesktop ? setState(() => _hovered = true) : null,
          onExit: (_) => isDesktop ? setState(() => _hovered = false) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            transform: Matrix4.identity()
              ..translate(0.0, _hovered ? -8.0 : 0.0),
            child: GlassCard(
              child: SizedBox(
                width: 230,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.experience.company,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.experience.role,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.experience.location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.65),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.experience.highlights.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            "• $e",
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.4,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.75,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────
/// MODEL
/// ─────────────────────────────────────────────
class ExperienceModel {
  final String company;
  final String role;
  final String period;
  final String location;
  final bool isCurrent;
  final List<String> highlights;

  const ExperienceModel({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    this.isCurrent = false,
    required this.highlights,
  });
}

/// ─────────────────────────────────────────────
/// DATA
/// ─────────────────────────────────────────────
const experienceData = [
  ExperienceModel(
    company: "Zaaroz Pvt Ltd",
    role: "Flutter Developer",
    period: "2025 – Present",
    location: "India",
    isCurrent: true,
    highlights: [
      "Advanced Flutter UI",
      "Scalable Architecture",
      "Design system driven components",
    ],
  ),
  ExperienceModel(
    company: "Techlambdas Pvt Ltd",
    role: "Flutter Developer",
    period: "Feb 2023 – 2025",
    location: "India",
    highlights: [
      "Mobile & Web Apps",
      "REST API & Firebase",
      "Clean Architecture & BLoC",
    ],
  ),
];
