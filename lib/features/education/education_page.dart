import 'package:flutter/material.dart';
import 'package:protfolio/widgets/app_selection_area.dart';
import 'package:protfolio/widgets/glass_card.dart';
import 'package:protfolio/widgets/section_title.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

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
              const SectionTitle("Education"),
              const SizedBox(height: 36),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: collegeEducation.length,
                    itemBuilder: (context, index) {
                      final item = collegeEducation[index];
                      return _EducationItem(
                        education: item,
                        isFirst: index == 0,
                        isLast: index == collegeEducation.length - 1,
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

class _EducationItem extends StatelessWidget {
  final EducationModel education;
  final bool isFirst;
  final bool isLast;

  const _EducationItem({
    required this.education,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── TIMELINE INDICATOR ──
          SizedBox(
            width: 32,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: isFirst ? 16 : 0,
                  bottom: isLast ? 0 : 0,
                  child: Container(
                    width: 2.0,
                    color: (isFirst && isLast)
                        ? Colors.transparent
                        : theme.colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                Positioned(
                  top: 14,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.35),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                  ),
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
                            child: Text(
                              education.degree,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            education.period,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        education.institution,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.75),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Score: ${education.score}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

class EducationModel {
  final String degree;
  final String institution;
  final String period;
  final String score;

  const EducationModel({
    required this.degree,
    required this.institution,
    required this.period,
    required this.score,
  });
}

const collegeEducation = [
  EducationModel(
    degree: "M.Sc. Network Technology & Information Technology",
    institution: "St. John's College, Palayamkottai, Tirunelveli",
    period: "2020 – 2022",
    score: "78.1%",
  ),
  EducationModel(
    degree: "Bachelor of Computer Applications (BCA)",
    institution: "St. John's College, Palayamkottai, Tirunelveli",
    period: "2017 – 2020",
    score: "71.1%",
  ),
];
