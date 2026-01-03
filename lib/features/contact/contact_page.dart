import 'package:flutter/material.dart';
import 'package:protfolio/widgets/section_title.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle("Contact"),
          const SizedBox(height: 40),

          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _LeftBlock(theme)),
                    const SizedBox(width: 40),
                    _Divider(theme),
                    const SizedBox(width: 40),
                    Expanded(child: _RightBlock(theme)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LeftBlock(theme),
                    const SizedBox(height: 32),
                    _RightBlock(theme),
                  ],
                ),
        ],
      ),
    );
  }
}

class _MiniGallery extends StatelessWidget {
  const _MiniGallery();

  static const images = [
    "assets/gallery/app1.png",
    "assets/gallery/app2.png",
    "assets/gallery/app3.png",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent work",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: images
              .map(
                (img) => _GalleryThumb(
                  image: img,
                  onTap: () => _openPreview(context, img),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _openPreview(BuildContext context, String image) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => _ImagePreview(image: image),
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const _GalleryThumb({required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceVariant,
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String image;

  const _ImagePreview({required this.image});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),

          // ❌ CLOSE BUTTON
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: theme.colorScheme.onSurface,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= LEFT BLOCK =================

class _LeftBlock extends StatelessWidget {
  final ThemeData theme;
  const _LeftBlock(this.theme);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let’s work together",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface, // ✅ dark-safe
          ),
        ),

        const SizedBox(height: 12),

        Text(
          "I’m a Flutter Developer focused on building scalable, "
          "clean, and high-performance mobile & web applications.",
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurface.withOpacity(0.75),
          ),
        ),

        const SizedBox(height: 28),

        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: const [
            _SocialButton(
              label: "GitHub",
              icon: Icons.code,
              url: "https://github.com/yourusername",
            ),
            _SocialButton(
              label: "LinkedIn",
              icon: Icons.business_center_outlined,
              url: "https://linkedin.com/in/yourusername",
            ),
            _SocialButton(
              label: "Portfolio",
              icon: Icons.language,
              url: "https://yourportfolio.com",
            ),
          ],
        ),

        const SizedBox(height: 32),

        // 🖼️ MINI GALLERY
        const _MiniGallery(),
      ],
    );
  }
}

// ================= RIGHT BLOCK =================

class _RightBlock extends StatelessWidget {
  final ThemeData theme;
  const _RightBlock(this.theme);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          icon: Icons.location_on_outlined,
          title: "Location",
          value: "Kovilpatti, Tamil Nadu, India",
        ),
        const SizedBox(height: 18),
        _InfoRow(
          icon: Icons.work_outline,
          title: "Role",
          value: "Flutter Developer",
        ),
        const SizedBox(height: 18),
        _InfoRow(
          icon: Icons.email_outlined,
          title: "Email",
          value: "yourmail@email.com",
          isLink: true,
        ),
        const SizedBox(height: 28),

        Text(
          "Available for full-time roles & freelance projects",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

// ================= INFO ROW =================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isLink;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 1,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: isLink
                  ? () => launchUrl(Uri.parse("mailto:$value"))
                  : null,
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLink
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ================= SOCIAL BUTTON =================

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DIVIDER =================

class _Divider extends StatelessWidget {
  final ThemeData theme;
  const _Divider(this.theme);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 200,
      color: theme.colorScheme.onSurface.withOpacity(0.08),
    );
  }
}
