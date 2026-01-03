import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protfolio/features/navigation/bloc/navigation_bloc.dart';
import 'package:protfolio/features/navigation/bloc/navigation_event.dart';
import 'package:protfolio/features/navigation/bloc/navigation_state.dart';

class NavigationView extends StatelessWidget {
  final List<Widget> pages;

  const NavigationView({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: pages[state.index],
          bottomNavigationBar: isMobile
              ? BottomNavigationBar(
                  currentIndex: state.index,
                  onTap: (i) =>
                      context.read<NavigationBloc>().add(ScrollToSection(i)),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "About",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.code),
                      label: "Skills",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.work),
                      label: "Projects",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.mail),
                      label: "Contact",
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
