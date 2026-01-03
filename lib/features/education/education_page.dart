import 'package:flutter/material.dart';
import 'package:protfolio/widgets/section_title.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle("Education"),
          const SizedBox(height: 36),

          isMobile ? _mobileLayout(context) : _desktopLayout(context),
        ],
      ),
    );
  }

  // ================= DESKTOP =================

  Widget _desktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _TimelineColumn(title: "College", items: collegeEducation),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: _TimelineColumn(title: "School", items: schoolEducation),
        ),
      ],
    );
  }

  // ================= MOBILE =================

  Widget _mobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineColumn(title: "College", items: collegeEducation),
        const SizedBox(height: 48),
        _TimelineColumn(title: "School", items: schoolEducation),
      ],
    );
  }
}

// ================= TIMELINE COLUMN =================

class _TimelineColumn extends StatelessWidget {
  final String title;
  final List<EducationModel> items;

  const _TimelineColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),

        const SizedBox(height: 28),

        ...List.generate(
          items.length,
          (i) =>
              _TimelineItem(education: items[i], isLast: i == items.length - 1),
        ),
      ],
    );
  }
}

// ================= TIMELINE ITEM =================

class _TimelineItem extends StatelessWidget {
  final EducationModel education;
  final bool isLast;

  const _TimelineItem({required this.education, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🟦 TIMELINE (FIXED HEIGHT)
        SizedBox(
          width: 20,
          height: isLast ? 20 : 72, // 👈 IMPORTANT
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // LINE
              if (!isLast)
                Positioned(
                  top: 10, // center of dot
                  child: Container(
                    width: 2,
                    height: 62,
                    color: theme.colorScheme.primary.withOpacity(0.35),
                  ),
                ),

              // DOT
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 18),

        // 📘 CONTENT
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  education.degree,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  education.institution,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    _MetaText(
                      icon: Icons.calendar_today_rounded,
                      text: education.period,
                    ),
                    _MetaText(
                      icon: Icons.assessment_rounded,
                      text: education.score,
                    ),
                    if (education.board != null)
                      _MetaText(
                        icon: Icons.account_balance_rounded,
                        text: education.board!,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================= META =================

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: theme.colorScheme.onSurface.withOpacity(0.55),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.75),
          ),
        ),
      ],
    );
  }
}

// ================= MODEL =================

class EducationModel {
  final String degree;
  final String institution;
  final String period;
  final String score;
  final String? board;

  const EducationModel({
    required this.degree,
    required this.institution,
    required this.period,
    required this.score,
    this.board,
  });
}

// ================= DATA =================

// 🎓 COLLEGE
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

// 🏫 SCHOOL
const schoolEducation = [
  EducationModel(
    degree: "Higher Secondary Certificate (HSC)",
    institution: "St. Joseph's Higher Secondary School, Kovilpatti",
    period: "2017",
    score: "60.1%",
    board: "State Board",
  ),
  EducationModel(
    degree: "Secondary School Leaving Certificate (SSLC)",
    institution: "St. Andrew's Higher Secondary School, Arakkonam",
    period: "2015",
    score: "71.1%",
    board: "State Board",
  ),
];
