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
import 'package:protfolio/features/navigation/bloc/navigation_bloc.dart';
import 'package:protfolio/features/navigation/bloc/navigation_event.dart';
import 'package:protfolio/features/projects/projects_page.dart';
import 'package:protfolio/features/skills/skills_page.dart';
import 'package:protfolio/widgets/floating_circular_nav.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
              textTheme: GoogleFonts.firaCodeTextTheme(),
              colorSchemeSeed: Colors.blue,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              textTheme: GoogleFonts.firaCodeTextTheme(),
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.dark,
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
  late final PageController _pageController;

  final pages = [
    HomePage(),
    AboutPage(),
    SkillsPage(),
    ExperiencePage(),
    ProjectsPage(),
    EducationPage(),
    ContactPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    context.read<NavigationBloc>().add(ScrollToSection(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Image.asset(
              'assets/logo.png',
              height: 100,
              fit: BoxFit.contain,
              color: state.isDark ? Colors.white : Colors.black,
              colorBlendMode: BlendMode.srcIn,
            );
          },
        ),
        actions: const [ThemeToggleSwitch()],
      ),

      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical, // 🔥 WEBSITE SCROLL
            onPageChanged: (index) {
              context.read<NavigationBloc>().add(ScrollToSection(index));
            },
            children: pages,
          ),

          // 🔥 FLOATING NAV FIXED TO BOTTOM
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: FloatingCircularNav(onTap: _onNavTap),
          ),
        ],
      ),
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
