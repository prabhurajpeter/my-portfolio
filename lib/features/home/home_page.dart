import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:protfolio/core/navigation_notification.dart';
import 'package:protfolio/widgets/app_selection_area.dart';
import 'package:protfolio/widgets/gradient_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protfolio/util/web_download_stub.dart' if (dart.library.html) 'package:protfolio/util/web_download_web.dart'; // conditional import for download helper
import 'package:url_launcher/url_launcher.dart';

// Brand logos are now moved to lib/util/brand_icons.dart

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
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: isMobile ? 500 : 700),
                      child: Padding(
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
        const Spacer(flex: 1),
        Expanded(
          flex: 5,
          child: _rightContent(context),
        ),
      ],
    );
  }

  // ================= MOBILE =================

  Widget _mobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _rightContent(context, isMobile: true),
        const SizedBox(height: 48),
        _leftContent(context, center: true),
      ],
    );
  }

  // ================= RIGHT CONTENT =================

  Widget _rightContent(BuildContext context, {bool isMobile = false}) {
    // The image is now handled by the AnimatedGradientBackground's Stack.
    // We wrap this Stack in a SizedBox to provide bounded constraints for the layout.
    return SizedBox(
      height: isMobile ? 100 : 500,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!isMobile)
            Positioned(
              top: 60,
              right: 20,
              child: _FloatingWidget(
                child: _CodeSnippetCard(),
              ),
            ),
          // Add a dummy container as a non-positioned child if needed to ensure the stack has a base size,
          // though SizedBox handles it here.
          const SizedBox.expand(),
        ],
      ),
    );
  }

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
              const Text("\u{1F44B}", style: TextStyle(fontSize: 14)),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Find me on",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 16),
            _GlowSocialButton(
              icon: 'assets/icons/github.svg',
              color: Colors.white,
              tooltip: "GitHub",
              onTap: () {
                launchUrl(Uri.parse("https://github.com/prabhurajpeter"));
              },
            ),
            const SizedBox(width: 10),
            _GlowSocialButton(
              icon: 'assets/icons/linkedin.svg',
              color: const Color(0xFF0A66C2),
              tooltip: "LinkedIn",
              onTap: () {
                launchUrl(Uri.parse("https://www.linkedin.com/in/prabhurajpeter/"));
              },
            ),
            const SizedBox(width: 10),
            _GlowSocialButton(
              icon: 'assets/icons/instagram.svg',
              color: const Color(0xFFE1306C),
              tooltip: "Instagram",
              onTap: () {
                launchUrl(Uri.parse("https://www.instagram.com/_peter026_/"));
              },
            ),
            const SizedBox(width: 10),
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
            decoration:BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered
                  ? widget.color.withValues(alpha: 0.1)
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              border: Border.all(
                color: _hovered
                    ? widget.color.withValues(alpha: 0.5)
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: widget.icon is String
                ? SvgPicture.asset(
                    widget.icon as String,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      _hovered ? widget.color : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    widget.icon as IconData,
                    color: _hovered ? widget.color : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 16,
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
      if (_controller.hasClients && _controller.position.maxScrollExtent > 0) {
        _controller.jumpTo(_controller.position.maxScrollExtent / 3);
      }
    });

    _timer = Timer.periodic(const Duration(milliseconds: 18), (_) {
      if (!_controller.hasClients || _controller.position.maxScrollExtent <= 0) return;
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
              Text(
                "\u{2726}",
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _CodeSnippetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10121A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _dot(Colors.red),
              const SizedBox(width: 4),
              _dot(Colors.amber),
              const SizedBox(width: 4),
              _dot(Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          _codeLine("import 'package:flutter/material.dart';", Colors.purpleAccent),
          _codeLine("class Portfolio extends StatelessWidget {", Colors.blueAccent),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _codeLine("Widget build(BuildContext context) {", Colors.blueAccent),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: _codeLine("return Text('Hello World');", Colors.orangeAccent),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: c));
  Widget _codeLine(String text, Color color) => Text(text, style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: color.withValues(alpha: 0.8)));
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
    // 🎈 Smooth interpolation (LERP)
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
          // 🎨 Background
          Positioned.fill(
            child: Container(color: const Color(0xFF06070B)),
          ),

          // 👤 Person Image as Background (Aligned Right)
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                "assets/peter.png",
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          // 🌫️ Soft glow following cursor
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: FractionalOffset(_current.dx, _current.dy),
                      radius: 0.8,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
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
