import 'package:flutter/material.dart';
import 'package:protfolio/widgets/section_title.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile ? _mobileLayout() : _desktopLayout(),
        ),
      ),
    );
  }

  // ================= DESKTOP =================

  Widget _desktopLayout() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _ThinkingStyle()),
        SizedBox(width: 56),
        Expanded(flex: 6, child: _AboutNarrative()),
      ],
    );
  }

  // ================= MOBILE =================

  Widget _mobileLayout() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_ThinkingStyle(), SizedBox(height: 48), _AboutNarrative()],
    );
  }
}

// ================= HOW I THINK =================

class _ThinkingStyle extends StatelessWidget {
  const _ThinkingStyle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("How I work"),
        const SizedBox(height: 32),

        _Principle(
          index: "01",
          title: "Clarity first",
          desc:
              "I start by simplifying the problem. Clear structure always leads to better code and better decisions.",
          scheme: scheme,
          theme: theme,
        ),
        const SizedBox(height: 28),

        _Principle(
          index: "02",
          title: "Architecture matters",
          desc:
              "I design systems that scale. Clean Architecture and separation of concerns are non-negotiable.",
          scheme: scheme,
          theme: theme,
        ),
        const SizedBox(height: 28),

        _Principle(
          index: "03",
          title: "Experience over features",
          desc:
              "I focus on how users feel when using the product — smooth flows beat complex features.",
          scheme: scheme,
          theme: theme,
        ),
      ],
    );
  }
}

class _Principle extends StatelessWidget {
  final String index;
  final String title;
  final String desc;
  final ThemeData theme;
  final ColorScheme scheme;

  const _Principle({
    required this.index,
    required this.title,
    required this.desc,
    required this.theme,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          index,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.primary.withOpacity(0.25),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                  color: scheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: scheme.onBackground.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ================= ABOUT TEXT =================

class _AboutNarrative extends StatelessWidget {
  const _AboutNarrative();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I’m a Flutter developer who enjoys turning complex ideas "
          "into clean, scalable, and reliable applications.\n\n"
          "I work across mobile and web, focusing on performance, "
          "maintainability, and thoughtful user experiences. "
          "I enjoy working close to both design and architecture, "
          "making sure the product feels as good as it works.\n\n"
          "I believe strong fundamentals, consistency, and attention "
          "to detail are what separate good apps from great ones.",
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.8,
            color: scheme.onBackground.withOpacity(0.82),
          ),
        ),

        const SizedBox(height: 40),

        Row(
          children: const [
            _Stat(value: "2+", label: "Years Experience"),
            SizedBox(width: 40),
            _Stat(value: "15+", label: "Projects Built"),
            SizedBox(width: 40),
            _Stat(value: "10+", label: "Clients & Teams"),
          ],
        ),
      ],
    );
  }
}

// ================= STATS =================

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onBackground.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}
