import 'package:flutter/material.dart';
import 'package:protfolio/widgets/app_selection_area.dart';
import 'package:protfolio/widgets/glass_card.dart';
import 'package:protfolio/widgets/section_title.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return AppSelectionArea(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle("Experience"),
              const SizedBox(height: 32),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: experienceData.length,
                    itemBuilder: (context, index) {
                      final item = experienceData[index];
                      return _TimelineItem(
                        experience: item,
                        isFirst: index == 0,
                        isLast: index == experienceData.length - 1,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ExperienceModel experience;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.experience,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── TIMELINE INDICATOR ──
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Top connector
                if (!isFirst)
                  Container(width: 2, height: 16,
                      color: theme.colorScheme.primary.withValues(alpha: 0.25)),
                // Dot
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: experience.isCurrent
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withValues(alpha: 0.65),
                    boxShadow: experience.isCurrent
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.45),
                              blurRadius: 10,
                              spreadRadius: 1.5,
                            )
                          ]
                        : [],
                  ),
                ),
                // Bottom connector
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // ── GLASS CARD CONTENT ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _HoverCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  experience.role,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  experience.company,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            experience.period,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: experience.isCurrent
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        experience.location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.55),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...experience.highlights.map(
                        (highlight) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6, right: 8),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  highlight,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    height: 1.45,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.85),
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
          ),
        ],
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0.0, _hovered ? -5.0 : 0.0, 0.0),
        child: GlassCard(
          borderRadius: 16,
          child: widget.child,
        ),
      ),
    );
  }
}

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

const experienceData = [
  ExperienceModel(
    company: "Zaaroz Services Private Limited",
    role: "Software Engineer",
    period: "Oct 2025 – Present",
    location: "Kovilpatti, Tamil Nadu, India",
    isCurrent: true,
    highlights: [
      "Led the migration of native Android and iOS applications to Flutter for both B2B and B2C platforms.",
      "Preserved existing authentication sessions, enabling users to remain logged in after upgrading to the Flutter application.",
      "Ensured feature parity while improving maintainability through a unified Flutter codebase.",
      "Collaborated closely with backend and QA teams to deliver seamless releases with minimal disruption to users.",
      "Identified and resolved production issues to improve application performance and stability.",
    ],
  ),
  ExperienceModel(
    company: "Techlambdas Pvt Ltd",
    role: "Flutter Developer",
    period: "Feb 2023 – Sep 2025",
    location: "Kovilpatti, Tamil Nadu, India",
    highlights: [
      "Designed and developed feature-rich mobile applications for iOS and Android platforms using Flutter framework.",
      "Collaborated with cross-functional teams, including designers and backend developers, to implement new features.",
      "Implemented state management solutions like Bloc to ensure efficient app architecture.",
      "Debugged and resolved application issues to improve app stability and user experience.",
      "Conducted unit and integration testing to ensure application reliability.",
    ],
  ),
  ExperienceModel(
    company: "Techlambdas Pvt Ltd",
    role: "Flutter Developer Intern",
    period: "Aug 2021 – Jan 2022",
    location: "Kovilpatti, Tamil Nadu, India",
    highlights: [
      "Assisted in the development of mobile applications using Flutter framework under the guidance of senior developers.",
      "Contributed to writing clean and maintainable code for application features.",
      "Gained hands-on experience in integrating APIs and managing local storage solutions.",
      "Participated in team meetings to discuss project requirements and design decisions.",
    ],
  ),
];
