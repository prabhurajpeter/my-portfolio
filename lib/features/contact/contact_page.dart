import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:protfolio/widgets/app_selection_area.dart';
import 'package:protfolio/widgets/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

// Brand SVGs moved to lib/util/brand_icons.dart

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'prabhurajpeter@gmail.com',
      queryParameters: {
        'subject': 'Project Discussion / Hello from Portfolio',
      },
    );
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      }
    } catch (_) {}
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 850;

    return AppSelectionArea(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  // 🚀 CTA BANNER CARD
                  _buildCtaBanner(context, isMobile),
                  const SizedBox(height: 56),

                  // 🔗 SOCIAL CONNECT ROW
                  _buildSocialConnect(context),
                  const SizedBox(height: 48),

                  // 📄 FOOTER
                  const Divider(height: 1),
                  const SizedBox(height: 24),
                  _buildFooter(context, isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCtaBanner(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1E2F), const Color(0xFF0F0F1A)]
              : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.near_me_rounded,
                  size: 40,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                Text(
                  "Have a Project\nin Mind?",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "I'm always open to discussing new projects, creative ideas, or opportunities to be part of your visions.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                GradientButton(
                  onPressed: _launchEmail,
                  height: 48,
                  borderRadius: 12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.send_rounded, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Let's Connect",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.near_me_rounded,
                            size: 32,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "LET'S WORK TOGETHER",
                            style: theme.textTheme.labelMedium?.copyWith(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Have a Project in Mind?",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "I'm always open to discussing new projects, creative ideas, or opportunities to be part of your visions.",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        onPressed: _launchEmail,
                        height: 48,
                        borderRadius: 12,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.send_rounded, size: 16, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Let's Connect",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSocialConnect(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          "FIND ME ON",
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            _SocialIconBtn(
              icon: 'assets/icons/github.svg',
              label: "GitHub",
              onTap: () => _launchUrl("https://github.com/prabhurajpeter"),
            ),
            _SocialIconBtn(
              icon: 'assets/icons/linkedin.svg',
              label: "LinkedIn",
              onTap: () => _launchUrl("https://www.linkedin.com/in/prabhurajpeter/"),
            ),
            _SocialIconBtn(
              icon: 'assets/icons/instagram.svg',
              label: "Instagram",
              onTap: () => _launchUrl("https://www.instagram.com/_peter026_/"),
            ),
            _SocialIconBtn(
              icon: Icons.mail_outline_rounded,
              label: "Email",
              onTap: _launchEmail,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);

    if (isMobile) {
      return Column(
        children: [
          Text(
            "PR Prabhu Raj Peter",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "© 2026 Prabhu Raj Peter. All rights reserved.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Built with ❤️ using Flutter",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 16,
      runSpacing: 8,
      children: [
        Text(
          "PR Prabhu Raj Peter",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          "© 2026 Prabhu Raj Peter. All rights reserved.",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        Text(
          "Built with ❤️ using Flutter",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

// ================= SOCIAL BUTTON =================

class _SocialIconBtn extends StatefulWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onTap;

  const _SocialIconBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialIconBtn> createState() => _SocialIconBtnState();
}

class _SocialIconBtnState extends State<_SocialIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _hovered
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            border: Border.all(
              color: _hovered
                  ? theme.colorScheme.primary.withValues(alpha: 0.3)
                  : theme.colorScheme.outline.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.icon is String
                  ? SvgPicture.asset(
                      widget.icon as String,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        _hovered ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      widget.icon as IconData,
                      size: 18,
                      color: _hovered ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _hovered ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
