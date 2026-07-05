import 'package:flutter/material.dart';
import 'package:protfolio/widgets/app_selection_area.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 950;
    final isTablet = width > 650 && width <= 950;
    final theme = Theme.of(context);

    return AppSelectionArea(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 20, vertical: 48),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                                  Icon(Icons.widgets_rounded, size: 12, color: theme.colorScheme.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'FEATURED PROJECTS',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Headline
                            RichText(
                              text: TextSpan(
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Some Things ",
                                    style: TextStyle(color: theme.colorScheme.onSurface),
                                  ),
                                  TextSpan(
                                    text: "I've Built",
                                    style: TextStyle(color: theme.colorScheme.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (width >= 650) ...[
                        const SizedBox(width: 16),
                        _ViewAllButton(onTap: () => _showAllProjectsDialog(context)),
                      ],
                    ],
                  ),
                  if (width < 650) ...[
                    const SizedBox(height: 16),
                    _ViewAllButton(onTap: () => _showAllProjectsDialog(context)),
                  ],
                  const SizedBox(height: 36),
                  // Project Cards
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _FeaturedProjectCard(project: _featuredProjects[0])),
                        const SizedBox(width: 24),
                        Expanded(child: _FeaturedProjectCard(project: _featuredProjects[1])),
                        const SizedBox(width: 24),
                        Expanded(child: _FeaturedProjectCard(project: _featuredProjects[2])),
                      ],
                    )
                  else if (isTablet)
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _FeaturedProjectCard(project: _featuredProjects[0])),
                            const SizedBox(width: 20),
                            Expanded(child: _FeaturedProjectCard(project: _featuredProjects[1])),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: width * 0.5,
                          child: _FeaturedProjectCard(project: _featuredProjects[2]),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _FeaturedProjectCard(project: _featuredProjects[0]),
                        const SizedBox(height: 24),
                        _FeaturedProjectCard(project: _featuredProjects[1]),
                        const SizedBox(height: 24),
                        _FeaturedProjectCard(project: _featuredProjects[2]),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAllProjectsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161B22) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4))],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48, height: 5,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("All Project Catalog",
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    "Enterprise applications and systems from my resume experience.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      itemCount: _allProjects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = _allProjects[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.08), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(item.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7), height: 1.4)),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8, runSpacing: 8,
                                children: item.tech.map((t) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(t,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                                )).toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ===== VIEW ALL BUTTON =====
class _ViewAllButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ViewAllButton({required this.onTap});
  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? theme.colorScheme.primary.withValues(alpha: 0.15)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? theme.colorScheme.primary.withValues(alpha: 0.45)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1.3,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All Projects',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.grid_view_rounded, size: 16, color: theme.colorScheme.onSurface),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== FEATURED PROJECT CARD =====
class _FeaturedProjectCard extends StatefulWidget {
  final _FeaturedProject project;
  const _FeaturedProjectCard({required this.project});
  @override
  State<_FeaturedProjectCard> createState() => _FeaturedProjectCardState();
}

class _FeaturedProjectCardState extends State<_FeaturedProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF10121C) : Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? theme.colorScheme.primary.withValues(alpha: 0.4)
                : theme.colorScheme.outline.withValues(alpha: 0.12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.12),
              blurRadius: _hovered ? 28 : 12,
              offset: Offset(0, _hovered ? 10 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored gradient image banner
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.project.gradientColors,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background circles for depth
                    Positioned(
                      right: -20, top: -20,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -10, bottom: -10,
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    // App mockup icon
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Icon(
                              widget.project.appIcon,
                              size: 48,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Card body
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.project.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6, runSpacing: 6,
                          children: widget.project.tech.map((t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Text(t,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w600,
                              )),
                          )).toList(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Arrow button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _hovered
                              ? theme.colorScheme.primary
                              : (isDark ? const Color(0xFF1E2030) : Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_outward_rounded,
                          size: 18,
                          color: _hovered ? Colors.white : theme.colorScheme.primary,
                        ),
                      ),
                    ],
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

// ===== DATA =====
class _FeaturedProject {
  final String title, description;
  final List<Color> gradientColors;
  final IconData appIcon;
  final List<String> tech;
  const _FeaturedProject({
    required this.title, required this.description,
    required this.gradientColors, required this.appIcon,
    required this.tech,
  });
}

class _CatalogProject {
  final String title, description;
  final List<String> tech;
  const _CatalogProject({required this.title, required this.description, required this.tech});
}

const _featuredProjects = [
  _FeaturedProject(
    title: 'Roami',
    description: 'A social travel app to connect travelers and explore together.',
    gradientColors: [Color(0xFF7B2FBE), Color(0xFF4A0080)],
    appIcon: Icons.travel_explore_rounded,
    tech: ['Flutter', 'Firebase', 'Maps'],
  ),
  _FeaturedProject(
    title: 'Happiwrap',
    description: 'E-commerce app for gifting platform with beautiful UI.',
    gradientColors: [Color(0xFF2D8B5E), Color(0xFF0F5C3A)],
    appIcon: Icons.card_giftcard_rounded,
    tech: ['Flutter', 'Dio', 'API'],
  ),
  _FeaturedProject(
    title: 'LAX Cinemas',
    description: 'Movie ticket booking app with seat selection and offers.',
    gradientColors: [Color(0xFF6B22B5), Color(0xFF2D0A6B)],
    appIcon: Icons.local_movies_rounded,
    tech: ['Flutter', 'Bloc', 'Payment'],
  ),
];

const _allProjects = [
  _CatalogProject(
    title: 'Native Android & iOS to Flutter Migration',
    description: 'Successfully migrated legacy native B2B/B2C apps into a single Flutter code framework.',
    tech: ['Flutter', 'iOS & Android', 'Migration', 'Auth Preservation'],
  ),
  _CatalogProject(
    title: 'Shopmate Grocery Application',
    description: 'A full-scale grocery store shopping app with payment flow integration and cart actions.',
    tech: ['Flutter', 'Razorpay', 'Firebase', 'Cart Flow'],
  ),
  _CatalogProject(
    title: 'Production ERP Monitoring Application',
    description: 'Enterprise ERP log utility with barcode scanning and manufacturing line audits.',
    tech: ['Flutter Web', 'Scan-to-Move', 'Traceability'],
  ),
  _CatalogProject(
    title: 'Quality Control Tablet Application',
    description: 'Industrial tablet inspections utility logging audits and product rejection reasons.',
    tech: ['Flutter', 'Tablet UI', 'Offline Cache', 'SQLite'],
  ),
  _CatalogProject(
    title: 'Hospital Management System',
    description: 'Clinic administrative system scheduling doctor sessions and handling checkout billing.',
    tech: ['Flutter Web', 'Appointments', 'Billing', 'Auth'],
  ),
  _CatalogProject(
    title: 'Billing Application for Local Retail Stores',
    description: 'Offline billing desktop app with digital invoice creation and financial report exports.',
    tech: ['Flutter', 'Hive', 'Offline-first', 'Invoice Engine'],
  ),
];
