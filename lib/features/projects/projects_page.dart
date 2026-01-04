import 'package:flutter/material.dart';
import 'package:protfolio/widgets/section_title.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 320,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 320,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle("Projects"),
          const SizedBox(height: 24),

          Stack(
            alignment: Alignment.center,
            children: [
              // 👉 HORIZONTAL SCROLL LIST
              SizedBox(
                height: 260,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),

                  // 🔥 KEY FIX
                  padding: const EdgeInsets.symmetric(horizontal: 48),

                  itemCount: projectData.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemBuilder: (_, i) {
                    return ProjectCard(project: projectData[i]);
                  },
                ),
              ),

              // ⬅ LEFT ARROW
              if (isDesktop)
                Positioned(
                  left: 0,
                  child: _ArrowButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: _scrollLeft,
                  ),
                ),

              // ➡ RIGHT ARROW
              if (isDesktop)
                Positioned(
                  right: 0,
                  child: _ArrowButton(
                    icon: Icons.arrow_forward_ios,
                    onTap: _scrollRight,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surface.withOpacity(0.9),
          boxShadow: [
            BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.15)),
          ],
        ),
        child: Icon(icon, size: 16, color: theme.colorScheme.primary),
      ),
    );
  }
}

// ================= PROJECT CARD =================

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ FULL WIDTH IMAGE (HEADER STYLE)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 120, // 🔥 perfect header height
              child: Image.asset(
                project.image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 28,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),

          // 📄 CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Text(
                  project.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface, // 🔥 theme aware
                  ),
                ),

                const SizedBox(height: 6),

                // DESCRIPTION
                Text(
                  project.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),

                const SizedBox(height: 10),

                // TECH CHIPS
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _buildTechChips(theme),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTechChips(ThemeData theme) {
    final visible = project.tech.take(3).toList();
    final remaining = project.tech.length - visible.length;

    return [
      ...visible.map(
        (e) => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8, // 🔽 smaller
            vertical: 3, // 🔽 smaller
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10), // 🔽 tighter radius
          ),
          child: Text(
            e,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9.5, // 🔽 smaller text
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
              height: 1.2,
            ),
          ),
        ),
      ),

      if (remaining > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "+$remaining",
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9.5,
              height: 1.2,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
    ];
  }
}

// ================= MODEL =================

class ProjectModel {
  final String title;
  final String description;
  final String image;
  final List<String> tech;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.image,
    required this.tech,
  });
}

// ================= DATA =================

const projectData = [
  ProjectModel(
    title: "Hospital Management System",
    description:
        "Production-ready hospital ERP system for managing patients, billing, and workflows.",
    image:
        "https://acropolium.com/blog/how-to-choose-the-best-hospital-management-software-for-healthcare-business/",
    tech: ["Flutter", "BLoC", "REST API", "Firebase"],
  ),
  ProjectModel(
    title: "Production ERP System",
    description:
        "Enterprise ERP for internal operations, reporting, and automation.",
    image: "assets/projects/erp.png",
    tech: ["Flutter Web", "Clean Architecture", "BLoC"],
  ),
  ProjectModel(
    title: "Shopmate Grocery App",
    description:
        "Customer grocery delivery app with live tracking and payments.",
    image: "assets/projects/shopmate.png",
    tech: ["Flutter", "Firebase", "Payments"],
  ),
  ProjectModel(
    title: "Queue Management System",
    description:
        "Tablet-optimized QMS used in hospitals to reduce waiting time.",
    image: "assets/projects/qms.png",
    tech: ["Flutter", "Tablet UI", "Offline-first"],
  ),
];
