import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../features/navigation/bloc/navigation_bloc.dart';
import '../features/navigation/bloc/navigation_state.dart';

class FloatingCircularNav extends StatelessWidget {
  final void Function(int) onTap;

  const FloatingCircularNav({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_navItems.length, (i) {
                    final selected = _getNavIndexForSection(state.index) == i;
                    final item = _navItems[i];

                    return Tooltip(
                      message: item.label,
                      child: GestureDetector(
                        onTap: () => onTap(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            item.icon,
                            size: 18,
                            color: selected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

const _navIndices = [0, 1, 4, 3, 5, 6, 7];

int _getNavIndexForSection(int sectionIndex) {
  if (sectionIndex == 2) return 1; // Map ServicesSection (Index 2) to About (Index 1)
  return _navIndices.indexOf(sectionIndex);
}

const List<_NavItem> _navItems = [
  _NavItem(Icons.home_rounded, "Home"),
  _NavItem(Icons.person_outline_rounded, "About"),
  _NavItem(Icons.code_rounded, "Skills"),
  _NavItem(Icons.folder_rounded, "Projects"),
  _NavItem(Icons.work_history_rounded, "Experience"),
  _NavItem(Icons.school_rounded, "Education"),
  _NavItem(Icons.mail_outline_rounded, "Contact"),
];
