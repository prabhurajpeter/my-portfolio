import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slideUp;
  late final Animation<Offset> _imageSlide;
  late final Animation<double> _imageFade;

  final marqueeItems = const [
    "Design Thinking",
    "Empathy",
    "User Friendly",
    "Accessibility",
    "Clean UI",
    "Performance",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_fade);

    _imageSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 1, curve: Curves.easeOut),
          ),
        );

    _imageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slideUp,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 40,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: isMobile
                              ? _mobileLayout(context)
                              : _desktopLayout(context),
                        ),
                      ),
                    ),
                  ),

                  // 🔁 RESTORED SCROLLING TEXT
                  Container(
                    height: 44,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: _SeamlessMarquee(items: marqueeItems),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================

  Widget _desktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 4, child: _leftContent(context)),
        Expanded(
          flex: 3,
          child: FadeTransition(
            opacity: _imageFade,
            child: SlideTransition(
              position: _imageSlide,
              child: _profileImage(),
            ),
          ),
        ),
        Expanded(flex: 3, child: _rightFeatures(context)),
      ],
    );
  }

  // ================= MOBILE =================

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        _leftContent(context, center: true),
        // const SizedBox(height: 32),
        // _profileImage(),
        // const SizedBox(height: 32),
        // _rightFeatures(context, center: true),
      ],
    );
  }

  // ================= LEFT CONTENT =================

  Widget _leftContent(BuildContext context, {bool center = false}) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // 🔥 BOLD UPPERCASE HEADLINE
        Text(
          "BUILDING MODERN\nFLUTTER EXPERIENCES",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            height: 1.05,
            color: theme.colorScheme.onBackground,
          ),
        ),

        const SizedBox(height: 18),

        // 📝 SUBTITLE / DESCRIPTION
        Text(
          "Flutter developer focused on crafting clean, scalable "
          "mobile and web applications with modern UI and "
          "solid architecture principles.",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 12,
            color: theme.colorScheme.onBackground.withOpacity(
              theme.brightness == Brightness.dark ? 0.85 : 0.75,
            ),
            height: 1.6,
          ),
        ),

        const SizedBox(height: 30),

        // 🎯 ACTION BUTTONS
        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: center ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _GlowIconButton(
              icon: 'assets/whatsapp.svg',
              color: const Color(0xFF25D366),
              tooltip: "WhatsApp",
              onTap: () {},
            ),
            _GlowIconButton(
              icon: 'assets/instagram.svg', // Instagram substitute
              color: const Color(0xFFE1306C),
              tooltip: "Instagram",
              onTap: () {},
            ),
            _GlowIconButton(
              icon: 'assets/linkedin.svg', // LinkedIn substitute
              color: const Color(0xFF0A66C2),
              tooltip: "LinkedIn",
              onTap: () {
                handleDownload();
              },
            ),
            _GlowDownloadButton(onTap: () {}),
          ],
        ),

        const SizedBox(height: 40),

        // 📊 STATS
        Row(
          mainAxisAlignment: center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: const [
            _Stat(value: "2+", label: "Years Experience"),
            SizedBox(width: 32),
            _Stat(value: "15+", label: "Projects Delivered"),
          ],
        ),
      ],
    );
  }

  void handleDownload() {
    if (kIsWeb) {
      downloadPdf(); // web version
    } else {
      downloadPdf(); // mobile version (same name, different file)
    }
  }

  Future<void> downloadPdf() async {
    await Permission.storage.request();

    final bytes = await rootBundle.load('assets/Peter-Resume.pdf');
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Peter-Resume.pdf');

    await file.writeAsBytes(bytes.buffer.asUint8List());

    debugPrint('PDF saved at ${file.path}');
  }

  // ================= IMAGE =================

  Widget _profileImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        final baseWidth = isMobile ? 320.0 : 520.0;
        final baseHeight = baseWidth * 2.3; // 🔥 MORE HEIGHT

        return _FloatingWidget(
          child: Transform.scale(
            scale: isMobile ? 1.05 : 1.15,
            child: Container(
              width: baseWidth,
              height: baseHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                image: const DecorationImage(
                  image: AssetImage("assets/peter.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= FEATURES =================

  Widget _rightFeatures(BuildContext context, {bool center = false}) {
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        _StaggeredFeature(
          delay: 0,
          child: const _HoverCard(
            child: _Feature(
              icon: Icons.layers,
              title: "Flutter Development",
              desc: "High-performance mobile and web applications.",
            ),
          ),
        ),
        const SizedBox(height: 24),
        _StaggeredFeature(
          delay: 200,
          child: const _HoverCard(
            child: _Feature(
              icon: Icons.architecture,
              title: "Clean Architecture",
              desc: "Scalable code using BLoC & best practices.",
            ),
          ),
        ),
        const SizedBox(height: 24),
        _StaggeredFeature(
          delay: 400,
          child: const _HoverCard(
            child: _Feature(
              icon: Icons.design_services,
              title: "UI/UX Focus",
              desc: "Modern, user-friendly interfaces.",
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowIconButton extends StatefulWidget {
  final String icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _GlowIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_GlowIconButton> createState() => _GlowIconButtonState();
}

class _GlowIconButtonState extends State<_GlowIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translate(0.0, _hovered ? -6.0 : 0.0)
              ..scale(_hovered ? 1.05 : 1.0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.6),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.6),
                        blurRadius: 28,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: SvgPicture.asset(widget.icon, height: 22, width: 22),
          ),
        ),
      ),
    );
  }
}

class _GlowDownloadButton extends StatefulWidget {
  final VoidCallback onTap;

  const _GlowDownloadButton({required this.onTap});

  @override
  State<_GlowDownloadButton> createState() => _GlowDownloadButtonState();
}

class _GlowDownloadButtonState extends State<_GlowDownloadButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..translate(0.0, _hovered ? -6.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: _hovered
                  ? [theme.colorScheme.primary, theme.colorScheme.secondary]
                  : [theme.colorScheme.surface, theme.colorScheme.surface],
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      blurRadius: 30,
                      color: theme.colorScheme.primary.withOpacity(0.45),
                    ),
                  ]
                : [],
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download,
                size: 18,
                color: _hovered ? Colors.white : theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "DOWNLOAD CV",
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: _hovered ? Colors.white : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
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
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _hovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          color: _hovered
              ? theme.colorScheme.surfaceVariant.withOpacity(0.85)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                    color: theme.colorScheme.primary.withOpacity(0.25),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(16),
        child: widget.child,
      ),
    );
  }
}

class _StaggeredFeature extends StatefulWidget {
  final Widget child;
  final int delay;

  const _StaggeredFeature({required this.child, required this.delay});

  @override
  State<_StaggeredFeature> createState() => _StaggeredFeatureState();
}

class _StaggeredFeatureState extends State<_StaggeredFeature>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: widget.child,
      ),
    );
  }
}

// ================= SUPPORT WIDGETS =================

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _Feature({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                desc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatefulWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  State<_Stat> createState() => _StatState();
}

class _StatState extends State<_Stat> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  late final int _targetValue;
  late final String _suffix;

  @override
  void initState() {
    super.initState();

    // 🔍 Extract number + suffix (e.g. "15+")
    final match = RegExp(r'(\d+)(.*)').firstMatch(widget.value);
    _targetValue = int.parse(match?.group(1) ?? '0');
    _suffix = match?.group(2) ?? '';

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(
      begin: 0,
      end: _targetValue.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 ANIMATED VALUE
            Text(
              "${_animation.value.toInt()}$_suffix",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onBackground,
              ),
            ),

            const SizedBox(height: 4),

            // 📝 LABEL
            Text(
              widget.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(
                  theme.brightness == Brightness.dark ? 0.75 : 0.65,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ================= SEAMLESS MARQUEE =================

class _SeamlessMarquee extends StatefulWidget {
  final List<String> items;

  const _SeamlessMarquee({required this.items});

  @override
  State<_SeamlessMarquee> createState() => _SeamlessMarqueeState();
}

class _SeamlessMarqueeState extends State<_SeamlessMarquee> {
  final ScrollController _controller = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent / 3);
      }
    });

    _timer = Timer.periodic(const Duration(milliseconds: 18), (_) {
      if (!_controller.hasClients) return;
      _controller.jumpTo(_controller.offset + 1);
      if (_controller.offset >= _controller.position.maxScrollExtent * 2 / 3) {
        _controller.jumpTo(_controller.position.maxScrollExtent / 3);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    );

    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(widget.items.length * 3, (i) {
          final text = widget.items[i % widget.items.length];
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(text.toUpperCase(), style: style),
              ),
              const Text(
                "✦",
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ================= GRADIENT BACKGROUND =================

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  Offset _target = const Offset(0.5, 0.5);
  Offset _current = const Offset(0.5, 0.5);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_tick);
    _controller.repeat();
  }

  void _tick() {
    // 🧈 Smooth interpolation (LERP)
    _current = Offset(
      _current.dx + (_target.dx - _current.dx) * 0.08,
      _current.dy + (_target.dy - _current.dy) * 0.08,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onHover: (event) {
        final size = MediaQuery.of(context).size;
        _target = Offset(
          (event.position.dx / size.width).clamp(0.0, 1.0),
          (event.position.dy / size.height).clamp(0.0, 1.0),
        );
      },
      child: Stack(
        children: [
          // 🎨 Smooth interactive gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment((_current.dx * 2) - 1, (_current.dy * 2) - 1),
                radius: 1.5,
                colors: isDark
                    ? const [
                        Color(0xFF42A5F5), // Flutter blue
                        Color(0xFF1E2A47), // Navy
                        Color(0xFF0B1020), // Dark base
                      ]
                    : const [
                        Color(0xFFB3E5FC),
                        Color(0xFFE3F2FD),
                        Color(0xFFF7F9FF),
                      ],
              ),
            ),
          ),

          // 🌫️ Subtle animated noise layer
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return CustomPaint(
                    painter: _NoisePainter(opacity: isDark ? 0.06 : 0.04),
                  );
                },
              ),
            ),
          ),

          // Content
          widget.child,
        ],
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final double opacity;
  final Random _random = Random();

  _NoisePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..strokeWidth = 1;

    final count = (size.width * size.height / 900).toInt();

    for (int i = 0; i < count; i++) {
      final dx = _random.nextDouble() * size.width;
      final dy = _random.nextDouble() * size.height;
      canvas.drawPoints(PointMode.points, [Offset(dx, dy)], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _FloatingWidget extends StatefulWidget {
  final Widget child;
  const _FloatingWidget({required this.child});

  @override
  State<_FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<_FloatingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _offset = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _offset.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
