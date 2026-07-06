import 'package:flutter/material.dart';
import 'package:protfolio/widgets/app_selection_area.dart';

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
                    Column(
                      children: [
                        for (int i = 0; i < _featuredProjects.length; i += 3) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _FeaturedProjectCard(project: _featuredProjects[i])),
                              const SizedBox(width: 24),
                              if (i + 1 < _featuredProjects.length) ...[
                                Expanded(child: _FeaturedProjectCard(project: _featuredProjects[i + 1])),
                                const SizedBox(width: 24),
                              ] else ...[
                                const Expanded(child: SizedBox()),
                                const SizedBox(width: 24),
                              ],
                              if (i + 2 < _featuredProjects.length)
                                Expanded(child: _FeaturedProjectCard(project: _featuredProjects[i + 2]))
                              else
                                const Expanded(child: SizedBox()),
                            ],
                          ),
                          if (i + 3 < _featuredProjects.length)
                            const SizedBox(height: 24),
                        ],
                      ],
                    )
                  else if (isTablet)
                    Wrap(
                      spacing: 20,
                      runSpacing: 24,
                      children: _featuredProjects.map((p) => SizedBox(
                        width: (width - 60) / 2,
                        child: _FeaturedProjectCard(project: p),
                      )).toList(),
                    )
                  else
                    Column(
                      children: _featuredProjects.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _FeaturedProjectCard(project: p),
                      )).toList(),
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
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close Catalog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final width = MediaQuery.of(context).size.width;
        final isMobile = width < 600;

        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: width * (isMobile ? 0.88 : 0.45),
              constraints: const BoxConstraints(
                maxWidth: 480,
                minWidth: 320,
              ),
              height: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF11141A) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(-4, 0),
                  ),
                ],
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    width: 1.5,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "All Projects",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "My complete project catalog",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Projects List
                      Expanded(
                        child: ListView(
                          children: [
                            _buildSectionHeader(theme, "FEATURED PROJECTS"),
                            const SizedBox(height: 12),
                            ..._allProjects
                                .where((p) => p.isFeatured)
                                .map((p) => _ProjectExpansionTile(project: p)),
                            const SizedBox(height: 24),
                            _buildSectionHeader(theme, "ADDITIONAL PROJECTS"),
                            const SizedBox(height: 12),
                            ..._allProjects
                                .where((p) => !p.isFeatured)
                                .map((p) => _ProjectExpansionTile(project: p)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuint,
          )),
          child: child,
        );
      },
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

// ===== PROJECT EXPANSION TILE =====
class _ProjectExpansionTile extends StatefulWidget {
  final _CatalogProject project;
  const _ProjectExpansionTile({required this.project});

  @override
  State<_ProjectExpansionTile> createState() => _ProjectExpansionTileState();
}

class _ProjectExpansionTileState extends State<_ProjectExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: _isExpanded
            ? theme.colorScheme.primary.withValues(alpha: 0.04)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: _isExpanded
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.outline.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
          title: Text(
            widget.project.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: _isExpanded ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            ),
          ),
          trailing: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _isExpanded ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          expandedAlignment: Alignment.topLeft,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 16, thickness: 0.8),
                const SizedBox(height: 4),
                // Detailed points
                ...widget.project.details.map((detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 8.0),
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          detail,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 12),
                // Tech chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.project.tech.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      t,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
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
  final String title;
  final List<String> details;
  final List<String> tech;
  final bool isFeatured;
  const _CatalogProject({
    required this.title,
    required this.details,
    required this.tech,
    this.isFeatured = false,
  });
}

const _featuredProjects = [
  _FeaturedProject(
    title: 'Native Android & iOS to Flutter Migration',
    description: 'Successfully migrated legacy native applications to Flutter for B2B and B2C users while preserving session authentication.',
    gradientColors: [Color(0xFF00B4AB), Color(0xFF007A74)],
    appIcon: Icons.swap_calls_rounded,
    tech: ['Flutter', 'Migration', 'iOS/Android'],
  ),
  _FeaturedProject(
    title: 'Shopmate Grocery Application',
    description: 'Developed an e-commerce mobile application with Razorpay payment integration, cart, and secure checkouts.',
    gradientColors: [Color(0xFFFF9A8B), Color(0xFFFF6A88)],
    appIcon: Icons.shopping_cart_rounded,
    tech: ['Flutter', 'Razorpay', 'Firebase'],
  ),
  _FeaturedProject(
    title: 'Production ERP Monitoring Application',
    description: 'Built a production monitoring solution with scan-to-move functionality and real-time tracking.',
    gradientColors: [Color(0xFF434343), Color(0xFF000000)],
    appIcon: Icons.analytics_rounded,
    tech: ['Flutter Web', 'Barcode', 'Audit'],
  ),
  _FeaturedProject(
    title: 'Quality Control Tablet Application',
    description: 'Developed inspection and rejection tracking systems for manufacturing environments with digital audits.',
    gradientColors: [Color(0xFF4F46E5), Color(0xFF312E81)],
    appIcon: Icons.tablet_mac_rounded,
    tech: ['Flutter', 'Tablet UI', 'SQLite'],
  ),
  _FeaturedProject(
    title: 'Hospital Management System',
    description: 'Developed mobile and web solutions for hospital administration, scheduling, patient records, and billing.',
    gradientColors: [Color(0xFF0EA5E9), Color(0xFF0369A1)],
    appIcon: Icons.local_hospital_rounded,
    tech: ['Flutter Web', 'Billing', 'Auth'],
  ),
];

const _allProjects = [
  // FEATURED PROJECTS
  _CatalogProject(
    title: 'Native Android & iOS to Flutter Migration',
    isFeatured: true,
    details: [
      'Migrated existing native applications to Flutter for B2B and B2C users.',
      'Preserved user sessions and authentication during application upgrades.',
      'Delivered a seamless transition without affecting existing customers.',
    ],
    tech: ['Flutter', 'iOS & Android', 'Migration', 'Auth Preservation'],
  ),
  _CatalogProject(
    title: 'Shopmate Grocery Application',
    isFeatured: true,
    details: [
      'Developed an e-commerce mobile application with Razorpay payment integration.',
      'Implemented cart management, search functionality, and secure checkout experiences.',
    ],
    tech: ['Flutter', 'Razorpay', 'Firebase', 'Cart Flow'],
  ),
  _CatalogProject(
    title: 'Production ERP Monitoring Application',
    isFeatured: true,
    details: [
      'Built a production monitoring solution with scan-to-move functionality.',
      'Improved operational traceability through digital workflows and real-time tracking.',
    ],
    tech: ['Flutter Web', 'Scan-to-Move', 'Traceability', 'ERP'],
  ),
  _CatalogProject(
    title: 'Quality Control Tablet Application',
    isFeatured: true,
    details: [
      'Developed inspection and rejection tracking systems for manufacturing environments.',
      'Enabled digital quality audits and corrective action workflows.',
      'Reduced manual errors through structured inspection processes.',
    ],
    tech: ['Flutter', 'Tablet UI', 'Offline Cache', 'SQLite'],
  ),
  _CatalogProject(
    title: 'Hospital Management System',
    isFeatured: true,
    details: [
      'Developed mobile and web solutions for hospital administration.',
      'Implemented appointment scheduling, patient records, billing, and secure authentication.',
    ],
    tech: ['Flutter Web', 'Appointments', 'Billing', 'Auth'],
  ),

  // ADDITIONAL PROJECTS
  _CatalogProject(
    title: 'Tripsheet Management Application',
    isFeatured: false,
    details: [
      'Developed an application to track and manage trips, route entries, and vehicle logs.',
      'Provided digital trip sheet submission, distance tracking, and driver log sheets.',
    ],
    tech: ['Flutter', 'Geolocation', 'Offline Sync'],
  ),
  _CatalogProject(
    title: 'Construction Management Entry Application',
    isFeatured: false,
    details: [
      'Built a data entry platform for recording daily site logs, material consumption, and workforce attendance.',
      'Enabled quick field reports and image attachments for proof of work.',
    ],
    tech: ['Flutter', 'Local DB', 'File Handling'],
  ),
  _CatalogProject(
    title: 'Task Management Platform',
    isFeatured: false,
    details: [
      'Designed and implemented a collaborative task board for teams with real-time status updates.',
      'Integrated push notifications and deadline reminders.',
    ],
    tech: ['Flutter', 'Realtime DB', 'Push Notifications'],
  ),
  _CatalogProject(
    title: 'Employee Management Application',
    isFeatured: false,
    details: [
      'Developed a system for profile management, check-in/check-out logs, and leave requests.',
      'Automated HR check-ins and performance history tracking.',
    ],
    tech: ['Flutter', 'REST API', 'Shared Preferences'],
  ),
  _CatalogProject(
    title: 'Staff Management Application (Educational Industry)',
    isFeatured: false,
    details: [
      'Built a comprehensive solution for managing teachers\' schedules, attendance, classes, and lesson plans.',
      'Integrated parent-teacher updates and student attendance tracking.',
    ],
    tech: ['Flutter', 'Firebase', 'Role-based Auth'],
  ),
  _CatalogProject(
    title: 'Billing Application for Local Retail Stores',
    isFeatured: false,
    details: [
      'Created an offline billing app with digital receipt generation, inventory logging, and sales analysis.',
      'Exported PDF invoices and daily summaries.',
    ],
    tech: ['Flutter', 'Hive DB', 'PDF Generator'],
  ),
];
