import 'package:flutter/material.dart';
import 'package:protfolio/core/navigation_notification.dart';
import 'package:protfolio/widgets/app_selection_area.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppSelectionArea(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 20, vertical: 24),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF10121C) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: isDesktop
                    ? IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Left: Skills
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(36),
                                child: _SkillsContent(),
                              ),
                            ),
                            // Divider
                            VerticalDivider(
                              width: 1,
                              color: theme.colorScheme.outline.withValues(alpha: 0.1),
                            ),
                            // Right: Experience + Rocket
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(36),
                                child: _ExperienceContent(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(28),
                            child: _SkillsContent(),
                          ),
                          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                          Padding(
                            padding: const EdgeInsets.all(28),
                            child: _ExperienceContent(),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== SKILLS CONTENT =====
class _SkillsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<String> techList = [
      'Flutter', 'Dart', 'Bloc', 'Firebase', 'UI/UX', 'Figma',
      'Git', 'REST API', 'SQLite', 'Clean Architecture',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
          ),
          child: Text(
            'MY SKILLS',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Technologies I Work With',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: techList.map((tech) => _TechChip(label: tech)).toList(),
        ),
      ],
    );
  }
}

class _TechChip extends StatefulWidget {
  final String label;
  const _TechChip({required this.label});
  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: _hovered
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered
                ? theme.colorScheme.primary.withValues(alpha: 0.4)
                : theme.colorScheme.outline.withValues(alpha: 0.15),
            width: 1.1,
          ),
        ),
        child: Text(
          widget.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: _hovered
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }
}

// ===== EXPERIENCE CONTENT =====
class _ExperienceContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPERIENCE',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(
                          text: '2.8+ Years of\n',
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        TextSpan(
                          text: 'Building ',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                        TextSpan(
                          text: 'Solutions',
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'I have worked on various projects from concept to deployment, delivering high-quality digital products.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.55,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _MyExperienceButton(),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const _RocketIllustration(),
          ],
        ),
      ],
    );
  }
}

// ===== MY EXPERIENCE BUTTON =====
class _MyExperienceButton extends StatefulWidget {
  @override
  State<_MyExperienceButton> createState() => _MyExperienceButtonState();
}

class _MyExperienceButtonState extends State<_MyExperienceButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => ScrollToSectionNotification(5).dispatch(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            gradient: _hovered
                ? LinearGradient(colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ])
                : null,
            color: _hovered ? null : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _hovered
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'My Experience',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _hovered ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.send_rounded,
                size: 16,
                color: _hovered ? Colors.white : theme.colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== ROCKET ILLUSTRATION =====
class _RocketIllustration extends StatefulWidget {
  const _RocketIllustration();
  @override
  State<_RocketIllustration> createState() => _RocketIllustrationState();
}

class _RocketIllustrationState extends State<_RocketIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _bob;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _bob = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    if (!AppSelectionArea.isTesting) _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _bob,
      builder: (_, _) => Transform.translate(
        offset: Offset(0, _bob.value),
        child: SizedBox(
          width: 110,
          child: CustomPaint(
            size: const Size(110, 140),
            painter: _RocketPainter(
              primaryColor: theme.colorScheme.primary,
              isDark: theme.brightness == Brightness.dark,
              bobValue: _bob.value,
            ),
          ),
        ),
      ),
    );
  }
}

class _RocketPainter extends CustomPainter {
  final Color primaryColor;
  final bool isDark;
  final double bobValue;
  const _RocketPainter({required this.primaryColor, required this.isDark, required this.bobValue});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Glow
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(cx, cy), 42, glowPaint);

    // Body
    final bodyPaint = Paint()..color = const Color(0xFFDDEAFF);
    final bodyPath = Path()
      ..moveTo(cx, cy - 48)
      ..cubicTo(cx - 18, cy - 20, cx - 18, cy + 10, cx - 18, cy + 22)
      ..lineTo(cx + 18, cy + 22)
      ..cubicTo(cx + 18, cy + 10, cx + 18, cy - 20, cx, cy - 48);
    canvas.drawPath(bodyPath, bodyPaint);

    // Window
    final windowPaint = Paint()..color = primaryColor.withValues(alpha: 0.85);
    canvas.drawCircle(Offset(cx, cy - 12), 10, windowPaint);
    final winHighlight = Paint()..color = Colors.white.withValues(alpha: 0.4);
    canvas.drawCircle(Offset(cx - 3, cy - 15), 4, winHighlight);

    // Left fin
    final finPaint = Paint()..color = primaryColor;
    final lFin = Path()
      ..moveTo(cx - 18, cy + 10)
      ..lineTo(cx - 30, cy + 28)
      ..lineTo(cx - 18, cy + 22);
    canvas.drawPath(lFin, finPaint);

    // Right fin
    final rFin = Path()
      ..moveTo(cx + 18, cy + 10)
      ..lineTo(cx + 30, cy + 28)
      ..lineTo(cx + 18, cy + 22);
    canvas.drawPath(rFin, finPaint);

    // Flame
    final flameFactor = (bobValue + 10) / 20;
    final flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFFFFA726), const Color(0xFFFF5722), Colors.transparent],
      ).createShader(Rect.fromCenter(center: Offset(cx, cy + 38), width: 20, height: 30 + flameFactor * 10));
    final flame = Path()
      ..moveTo(cx - 8, cy + 22)
      ..quadraticBezierTo(cx, cy + 48 + flameFactor * 10, cx, cy + 52 + flameFactor * 10)
      ..quadraticBezierTo(cx, cy + 48 + flameFactor * 10, cx + 8, cy + 22);
    canvas.drawPath(flame, flamePaint);

    // Orbit ring
    final orbitPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 90, height: 30), orbitPaint);

    // Orbit dot
    final angle = bobValue * 0.1;
    final dotX = cx + 45 * (angle - angle.floor()).clamp(0, 1) * 2 - 22;
    final dotPaint = Paint()..color = primaryColor;
    canvas.drawCircle(Offset(cx + 40, cy - 5), 4, dotPaint);
  }

  @override
  bool shouldRepaint(_RocketPainter old) => old.bobValue != bobValue;
}
