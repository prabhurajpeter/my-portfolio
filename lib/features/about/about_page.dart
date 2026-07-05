import 'package:flutter/material.dart';
import 'package:protfolio/core/navigation_notification.dart';
import 'package:protfolio/widgets/app_selection_area.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 950;

    return AppSelectionArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            bottom: true,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 48,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMobile) ...[
                        _buildLeftSection(context, isMobile: true),
                        const SizedBox(height: 40),
                        const _TerminalCard(),
                        const SizedBox(height: 40),
                        const _BrandIconsRow(),
                      ] else ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: _buildLeftSection(context, isMobile: false),
                            ),
                            const SizedBox(width: 56),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  _TerminalCard(),
                                  SizedBox(height: 40),
                                  _BrandIconsRow(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeftSection(BuildContext context, {required bool isMobile}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_outline_rounded, size: 13, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'ABOUT ME',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
            children: [
              TextSpan(
                text: 'Crafting Digital\n',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              TextSpan(
                text: 'Experiences',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        if (isMobile) ...[
          const _VerticalStatCards(),
          const SizedBox(height: 24),
          _buildBioAndButton(context),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 190, child: _VerticalStatCards()),
              const SizedBox(width: 28),
              Expanded(child: _buildBioAndButton(context)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBioAndButton(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I'm a passionate Flutter Developer and UI/UX Designer with 2.8+ years of experience building beautiful, fast & user-friendly mobile applications.",
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.65,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 28),
        const _MoreAboutMeButton(),
      ],
    );
  }
}

// ===== MORE ABOUT ME BUTTON =====
class _MoreAboutMeButton extends StatefulWidget {
  const _MoreAboutMeButton();
  @override
  State<_MoreAboutMeButton> createState() => _MoreAboutMeButtonState();
}

class _MoreAboutMeButtonState extends State<_MoreAboutMeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => ScrollToSectionNotification(1).dispatch(context),
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
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'More About Me',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _hovered ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.person_add_outlined,
                size: 17,
                color: _hovered ? Colors.white : theme.colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== VERTICAL STAT CARDS =====
class _VerticalStatCards extends StatelessWidget {
  const _VerticalStatCards();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _StatCard(icon: Icons.calendar_today_rounded, iconColor: Color(0xFF7C3AED), number: '2.8+', label: 'Years Experience'),
        SizedBox(height: 12),
        _StatCard(icon: Icons.grid_view_rounded, iconColor: Color(0xFF7C3AED), number: '10+', label: 'Projects Completed'),
        SizedBox(height: 12),
        _StatCard(icon: Icons.emoji_events_rounded, iconColor: Color(0xFF7C3AED), number: '5+', label: 'Happy Clients'),
        SizedBox(height: 12),
        _StatCard(icon: Icons.favorite_rounded, iconColor: Color(0xFF7C3AED), number: '100%', label: 'Commitment'),
      ],
    );
  }
}

class _StatCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String number;
  final String label;
  const _StatCard({required this.icon, required this.iconColor, required this.number, required this.label});
  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isDark
              ? Colors.white.withValues(alpha: _hovered ? 0.08 : 0.04)
              : Colors.black.withValues(alpha: _hovered ? 0.05 : 0.02),
          border: Border.all(
            color: _hovered
                ? widget.iconColor.withValues(alpha: 0.35)
                : theme.colorScheme.outline.withValues(alpha: 0.12),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.number,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== TERMINAL CARD =====
class _TerminalCard extends StatefulWidget {
  const _TerminalCard();
  @override
  State<_TerminalCard> createState() => _TerminalCardState();
}

class _TerminalCardState extends State<_TerminalCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const cardBg = Color(0xFF0C0E1A);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardBg,
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: _hovered ? 0.55 : 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: _hovered ? 0.18 : 0.06),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _dot(Colors.red),
                  const SizedBox(width: 7),
                  _dot(Colors.amber),
                  const SizedBox(width: 7),
                  _dot(const Color(0xFF3CFF72)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Icon(Icons.refresh_rounded, size: 14,
                        color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    '> About me',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _cursorController,
                    builder: (_, __) => Opacity(
                      opacity: _cursorController.value,
                      child: const Text('_',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _roleLine('Flutter Developer', highlighted: true, theme: theme),
              const SizedBox(height: 10),
              _roleLine('UI/UX Designer', highlighted: true, theme: theme),
              const SizedBox(height: 10),
              _roleLine('Problem Solver', theme: theme),
              const SizedBox(height: 10),
              _roleLine('Lifelong Learner', theme: theme),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.bottomRight,
                child: _PeterSignature(color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color c) => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(shape: BoxShape.circle, color: c),
      );

  Widget _roleLine(String text, {bool highlighted = false, required ThemeData theme}) {
    return Row(
      children: [
        Text(
          '\u00bb ',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: highlighted
                ? theme.colorScheme.primary
                : Colors.white.withValues(alpha: 0.5),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            fontWeight: highlighted ? FontWeight.w700 : FontWeight.w400,
            color: highlighted
                ? theme.colorScheme.primary
                : Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// ===== PETER SIGNATURE =====
class _PeterSignature extends StatelessWidget {
  final Color color;
  const _PeterSignature({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(90, 44),
      painter: _SignaturePainter(color: color),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final Color color;
  const _SignaturePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final p = Path()
      ..moveTo(w * 0.04, h * 0.85)
      ..lineTo(w * 0.04, h * 0.18)
      ..cubicTo(w * 0.04, h * 0.05, w * 0.22, h * 0.05, w * 0.22, h * 0.3)
      ..cubicTo(w * 0.22, h * 0.55, w * 0.04, h * 0.52, w * 0.04, h * 0.52);
    canvas.drawPath(p, paint);

    final eter = Path()
      ..moveTo(w * 0.25, h * 0.55)
      ..cubicTo(w * 0.3, h * 0.32, w * 0.36, h * 0.25, w * 0.42, h * 0.4)
      ..cubicTo(w * 0.48, h * 0.55, w * 0.44, h * 0.7, w * 0.52, h * 0.6)
      ..cubicTo(w * 0.58, h * 0.52, w * 0.6, h * 0.38, w * 0.68, h * 0.42)
      ..cubicTo(w * 0.76, h * 0.46, w * 0.74, h * 0.65, w * 0.82, h * 0.55)
      ..cubicTo(w * 0.88, h * 0.48, w * 0.92, h * 0.35, w * 0.98, h * 0.4);
    canvas.drawPath(eter, paint);

    final under = Path()
      ..moveTo(w * 0.25, h * 0.82)
      ..cubicTo(w * 0.5, h * 0.75, w * 0.75, h * 0.88, w * 0.98, h * 0.78);
    canvas.drawPath(under, paint);
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => old.color != color;
}

// ===== BRAND ICONS ROW =====
class _BrandIconsRow extends StatelessWidget {
  const _BrandIconsRow();

  @override
  Widget build(BuildContext context) {
    final icons = [
      _BIcon(icon: Icons.flutter_dash, color: const Color(0xFF54C5F8), tooltip: 'Flutter'),
      _BIcon(icon: Icons.code, color: const Color(0xFF00B4AB), tooltip: 'Dart'),
      _BIcon(icon: Icons.design_services_rounded, color: const Color(0xFFF24E1E), tooltip: 'Figma'),
      _BIcon(icon: Icons.local_fire_department_rounded, color: const Color(0xFFFFA000), tooltip: 'Firebase'),
      _BIcon(icon: Icons.merge_type, color: const Color(0xFFFF5722), tooltip: 'Git'),
      _BIcon(icon: Icons.favorite_rounded, color: const Color(0xFF7C3AED), tooltip: 'Open Source'),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: icons.map((ic) => _BIconBtn(data: ic)).toList(),
    );
  }
}

class _BIcon {
  final IconData icon;
  final Color color;
  final String tooltip;
  const _BIcon({required this.icon, required this.color, required this.tooltip});
}

class _BIconBtn extends StatefulWidget {
  final _BIcon data;
  const _BIconBtn({required this.data});
  @override
  State<_BIconBtn> createState() => _BIconBtnState();
}

class _BIconBtnState extends State<_BIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: widget.data.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: _hovered
                ? widget.data.color.withValues(alpha: 0.15)
                : theme.colorScheme.surface.withValues(alpha: 0.06),
            border: Border.all(
              color: _hovered
                  ? widget.data.color.withValues(alpha: 0.45)
                  : theme.colorScheme.outline.withValues(alpha: 0.12),
              width: 1.3,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.data.color.withValues(alpha: 0.25),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Icon(
            widget.data.icon,
            color: _hovered
                ? widget.data.color
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
        ),
      ),
    );
  }
}
