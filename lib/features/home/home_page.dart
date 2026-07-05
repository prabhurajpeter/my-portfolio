import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protfolio/core/navigation_notification.dart';
import 'package:protfolio/widgets/app_selection_area.dart';
import 'package:protfolio/widgets/gradient_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

import 'package:protfolio/util/web_download_stub.dart' if (dart.library.html) 'package:protfolio/util/web_download_web.dart'; // conditional import for download helper
import 'package:url_launcher/url_launcher.dart';

// ================= SVG BRAND LOGO CONSTANTS =================

const String _githubSvg = '''
<svg viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
  <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/>
</svg>
''';

const String _linkedinSvg = '''
<svg viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
  <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.779-1.75-1.75s.784-1.75 1.75-1.75 1.75.779 1.75 1.75-.784 1.75-1.75 1.75zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
</svg>
''';

const String _instagramSvg = '''
<svg viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.051c-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4.162 4.162 0 110-8.324A4.162 4.162 0 0112 16zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z"/>
</svg>
''';

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

  final marqueeItems = const [
    "Design Thinking",
    "Clean Architecture",
    "Responsive Design",
    "User Friendly",
    "State Management",
    "High Performance",
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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSelectionArea(
      child: AnimatedGradientBackground(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slideUp,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 900;
  
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 64,
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
      ),
    );
  }

  // ================= DESKTOP =================

  Widget _desktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: _leftContent(context),
        ),
        const Spacer(flex: 4),
      ],
    );
  }

  // ================= MOBILE =================

  Widget _mobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _leftContent(context, center: true),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 👋 Hi, I'm badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("👋", style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                "Hi, I'm",
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Headline: Prabhu Raj Peter
        RichText(
          textAlign: center ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -1.0,
            ),
            children: [
              TextSpan(
                text: "Prabhu Raj\n",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              TextSpan(
                text: "Peter",
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Subheadline: Flutter Developer & UI/UX Designer
        Text(
          "Flutter Developer & UI/UX Designer",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary.withValues(alpha: 0.95),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),

        // Paragraph narrative
        Text(
          "I build cross-platform mobile apps with Flutter and design clean, engaging user experiences.",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.6,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 36),

        // Action Buttons: View My Work & Download CV
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: center ? WrapAlignment.center : WrapAlignment.start,
          children: [
            GradientButton(
              onPressed: () {
                ScrollToSectionNotification(3).dispatch(context);
              },
              height: 52,
              borderRadius: 30,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "View My Work",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: handleDownload,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Download CV", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.download_rounded, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),

        // Social handles "Find me on"
        Wrap(
          alignment: center ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            Text(
              "Find me on",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            _GlowSocialButton(
              icon: _githubSvg,
              color: Colors.white,
              tooltip: "GitHub",
              onTap: () {
                launchUrl(Uri.parse("https://github.com/prabhurajpeter"));
              },
            ),
            _GlowSocialButton(
              icon: _linkedinSvg,
              color: const Color(0xFF0A66C2),
              tooltip: "LinkedIn",
              onTap: () {
                launchUrl(Uri.parse("https://linkedin.com/in/prabhurajpeter"));
              },
            ),
            _GlowSocialButton(
              icon: _instagramSvg,
              color: const Color(0xFFE1306C),
              tooltip: "Instagram",
              onTap: () {
                launchUrl(Uri.parse("https://instagram.com/prabhurajpeter"));
              },
            ),
            _GlowSocialButton(
              icon: Icons.mail_outline_rounded,
              color: theme.colorScheme.primary,
              tooltip: "Email",
              onTap: () {
                launchUrl(Uri.parse("mailto:prabhurajpeter@gmail.com"));
              },
            ),
          ],
        ),
      ],
    );
  }

  void handleDownload() {
    if (kIsWeb) {
      triggerDownload('assets/Peter-Resume.pdf');
    } else {
      downloadPdfMobile();
    }
  }

  Future<void> downloadPdfMobile() async {
    try {
      final bytes = await rootBundle.load('assets/Peter-Resume.pdf');
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/Peter-Resume.pdf');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      debugPrint('PDF saved at ${file.path}');
      launchUrl(Uri.parse(file.path));
    } catch (e) {
      debugPrint('Mobile download/view failed: $e');
    }
  }

  // Removed circle profile content
}

class _GlowSocialButton extends StatefulWidget {
  final dynamic icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _GlowSocialButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_GlowSocialButton> createState() => _GlowSocialButtonState();
}

class _GlowSocialButtonState extends State<_GlowSocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            transform: Matrix4.translationValues(0.0, _hovered ? -4.0 : 0.0, 0.0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: Border.all(
                color: _hovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.4)
                    : theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: widget.icon is String
                ? SvgPicture.string(
                    widget.icon as String,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      _hovered ? widget.color : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    widget.icon as IconData,
                    color: _hovered ? widget.color : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    size: 20,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SeamlessMarquee extends StatefulWidget {
  final List<String> items;

  const _SeamlessMarquee({required this.items});

  @override
  State<_SeamlessMarquee> createState() => _SeamlessMarqueeState();
}

class _SeamlessMarqueeState extends State<_SeamlessMarquee> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (AppSelectionArea.isTesting) return;

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
    _timer?.cancel();
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
          // 🎨 Background Image spanning the full width of the screen background
          Positioned.fill(
            child: AppSelectionArea.isTesting
                ? Container(color: const Color(0xFF06070B))
                : Image.asset(
                    "assets/peter.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: const Color(0xFF06070B)),
                  ),
          ),

          // 🌫️ Linear gradient to soften the image on the left for text contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF06070B).withValues(alpha: 0.9),
                    const Color(0xFF06070B).withValues(alpha: 0.5),
                    const Color(0xFF06070B).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),

          // 🌫️ Subtle animated noise layer
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, _) {
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
      ..color = Colors.white.withValues(alpha: opacity)
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
