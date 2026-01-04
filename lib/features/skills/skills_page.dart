import 'package:flutter/material.dart';
import 'package:protfolio/widgets/section_title.dart';
import 'package:protfolio/widgets/skill_chip.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: _SkillsIntro()),
        SizedBox(width: 64),
        Expanded(flex: 5, child: _SkillCards()),
      ],
    );
  }

  // ================= MOBILE =================

  Widget _mobileLayout() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkillsIntro(),
        SizedBox(height: 24),
        Expanded(
          // 🔑 FIX: cards take remaining height
          child: _SkillCards(),
        ),
      ],
    );
  }
}

// ================= INTRO =================

class _SkillsIntro extends StatelessWidget {
  const _SkillsIntro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 🔑 IMPORTANT
      children: [
        const SectionTitle("Skills & Tools"),
        const SizedBox(height: 24),
        Text(
          "I specialize in Flutter development with a strong focus on "
          "clean architecture, performance, and scalable systems.\n\n"
          "My approach blends thoughtful UI design with solid "
          "engineering principles to build products that last.",
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.7,
            color: theme.colorScheme.onSurface.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 3,
          width: 140,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

// ================= CARDS =================

class _SkillCards extends StatefulWidget {
  const _SkillCards();

  @override
  State<_SkillCards> createState() => _SkillCardsState();
}

class _SkillCardsState extends State<_SkillCards> {
  late PageController _controller;
  int _currentIndex = 0;

  final _cards = const [
    _SkillCard(
      icon: Icons.flutter_dash,
      title: "Flutter Stack",
      description:
          "Building cross-platform applications with a single codebase, "
          "focused on performance and responsive UI.",
      color: Color(0xFF42A5F5),
      skills: ["Flutter", "Dart", "Flutter Web", "Responsive UI"],
      delay: 0,
    ),
    _SkillCard(
      icon: Icons.architecture,
      title: "Architecture",
      description:
          "Designing scalable app structures using Clean Architecture, "
          "BLoC pattern, and SOLID principles.",
      color: Color(0xFF7E57C2),
      skills: ["BLoC", "Clean Architecture", "SOLID", "DI"],
      delay: 120,
    ),
    _SkillCard(
      icon: Icons.storage_rounded,
      title: "Backend & Data",
      description:
          "Handling data, APIs, and local storage with secure and "
          "efficient data flow.",
      color: Color(0xFF26A69A),
      skills: ["Firebase", "REST API", "Hive"],
      delay: 240,
    ),
    _SkillCard(
      icon: Icons.design_services_rounded,
      title: "Design & Workflow",
      description:
          "Collaborating with design tools and workflows to deliver "
          "polished and user-friendly interfaces.",
      color: Color(0xFFFF7043),
      skills: ["Figma", "Git", "Agile", "Optimization"],
      delay: 360,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;

    _controller = PageController(
      viewportFraction: width < 400
          ? 0.9
          : width < 600
          ? 0.85
          : width < 900
          ? 0.8
          : 0.75,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Column(
      children: [
        Expanded(
          // 🔑 FIX: PageView adapts to available height
          child: PageView.builder(
            controller: _controller,
            itemCount: _cards.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) {
              return AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: i == _currentIndex ? 1 : 0.92,
                child: _cards[i],
              );
            },
          ),
        ),

        if (!isMobile)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ArrowButton(
                  icon: Icons.arrow_back_ios_new,
                  enabled: _currentIndex > 0,
                  onTap: () => _controller.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                  ),
                ),
                const SizedBox(width: 24),
                _ArrowButton(
                  icon: Icons.arrow_forward_ios,
                  enabled: _currentIndex < _cards.length - 1,
                  onTap: () => _controller.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ================= ARROW =================

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(40),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? theme.colorScheme.primary.withOpacity(0.15)
              : theme.disabledColor.withOpacity(0.1),
          border: Border.all(
            color: enabled
                ? theme.colorScheme.primary.withOpacity(0.4)
                : theme.disabledColor.withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? theme.colorScheme.primary : theme.disabledColor,
        ),
      ),
    );
  }
}

// ================= CARD =================

class _SkillCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> skills;
  final Color color;
  final int delay;

  const _SkillCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.skills,
    required this.color,
    required this.delay,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fade);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    final double cardWidth = width < 380
        ? width * 0.85
        : width < 600
        ? 280
        : width < 900
        ? 320
        : 360;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.045),
              border: Border.all(color: widget.color.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                  color: widget.color.withOpacity(0.12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(widget.icon, size: 20, color: widget.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        widget.title.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurface.withOpacity(0.75),
                  ),
                ),

                // Chips hidden on mobile
                if (!isMobile) ...[
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.skills.map((s) => SkillChip(s)).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
