import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:protfolio/core/theme/theme_bloc.dart';
import 'package:protfolio/core/theme/theme_event.dart';
import 'package:protfolio/core/theme/theme_state.dart';
import 'package:protfolio/features/about/about_page.dart';
import 'package:protfolio/features/contact/contact_page.dart';
import 'package:protfolio/features/education/education_page.dart';
import 'package:protfolio/features/experience/experience_page.dart';
import 'package:protfolio/features/home/home_page.dart';
import 'package:protfolio/features/home/widgets/services_section.dart';
import 'package:protfolio/features/navigation/bloc/navigation_bloc.dart';
import 'package:protfolio/features/navigation/bloc/navigation_event.dart';
import 'package:protfolio/core/navigation_notification.dart';
import 'package:protfolio/features/navigation/bloc/navigation_state.dart';
import 'package:protfolio/features/projects/projects_page.dart';
import 'package:protfolio/features/skills/skills_page.dart';
import 'package:protfolio/widgets/floating_circular_nav.dart';
import 'package:protfolio/widgets/gradient_button.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => NavigationBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              useMaterial3: true,
              textTheme: GoogleFonts.spaceGroteskTextTheme(),
              colorSchemeSeed: const Color(0xFF6366F1), // Modern Indigo
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              textTheme: GoogleFonts.spaceGroteskTextTheme(),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF06070B),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF6366F1),
                surface: Color(0xFF06070B),
                surfaceContainer: Color(0xFF10121A),
                surfaceContainerHighest: Color(0xFF161822),
                outline: Color(0xFF262936),
              ),
            ),
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late final ScrollController _scrollController;
  final List<GlobalKey> _sectionKeys = List.generate(7, (_) => GlobalKey());

  final List<int> _navIndices = [0, 1, 4, 3, 5, 6];
  final List<String> _navLabels = ["Home", "About", "Skills", "Projects", "Experience", "Contact"];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    double minDistance = double.infinity;
    int activeIndex = 0;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final keyContext = _sectionKeys[i].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final distance = position.dy.abs();
          if (distance < minDistance) {
            minDistance = distance;
            activeIndex = i;
          }
        }
      }
    }

    if (activeIndex != context.read<NavigationBloc>().state.index) {
      context.read<NavigationBloc>().add(ScrollToSection(activeIndex));
    }
  }

  void _onNavTap(int index) {
    final keyContext = _sectionKeys[index].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
    context.read<NavigationBloc>().add(ScrollToSection(index));
  }

  Widget _buildHeaderNavBar(BuildContext context, int activeIndex, bool isDark) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "PR",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Prabhu Raj Peter",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          
          // Center: Navigation Links (Desktop only)
          if (isDesktop)
            Row(
              children: List.generate(_navLabels.length, (i) {
                final targetIndex = _navIndices[i];
                final selected = activeIndex == targetIndex || 
                    (targetIndex == 5 && activeIndex == 5); // Experience or Education
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => _onNavTap(targetIndex),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _navLabels[i],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        if (selected) ...[
                          const SizedBox(height: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),

          // Right: Action button / Theme switch
          Row(
            children: [
              GradientButton(
                onPressed: () => _onNavTap(6), // Scrolls to Contact Page (index 6)
                height: 40,
                borderRadius: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Let's Talk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.near_me_rounded, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, navState) {
            return NotificationListener<ScrollToSectionNotification>(
              onNotification: (notification) {
                _onNavTap(notification.index);
                return true;
              },
              child: Scaffold(
                extendBody: true,
                body: Column(
                  children: [
                    // Top Navbar
                    _buildHeaderNavBar(context, navState.index, themeState.isDark),
                    
                    // Main scrollable content
                    Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                HomePage(key: _sectionKeys[0]),
                                AboutPage(key: _sectionKeys[1]),
                                ServicesSection(key: _sectionKeys[2]),
                                ProjectsPage(key: _sectionKeys[3]),
                                SkillsPage(key: _sectionKeys[4]),
                                ExperiencePage(key: _sectionKeys[5]),
                                EducationPage(),
                                ContactPage(key: _sectionKeys[6]),
                                const SizedBox(height: 80), // bottom space for footer
                              ],
                            ),
                          ),
  
                          // Floating Circular Navigation Overlay
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 24,
                            child: FloatingCircularNav(
                              onTap: (index) {
                                _onNavTap(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Switch(
          value: state.isDark,
          thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
            return Icon(
              state.isDark ? Icons.dark_mode : Icons.light_mode,
              size: 16,
            );
          }),
          onChanged: (_) {
            context.read<ThemeBloc>().add(ToggleThemeEvent());
          },
        );
      },
    );
  }
}

