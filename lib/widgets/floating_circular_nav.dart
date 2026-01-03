import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_navIcons.length, (i) {
                    final selected = state.index == i;

                    return GestureDetector(
                      onTap: () => onTap(i), // ✅ ONLY CALLBACK
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                        ),
                        child: Icon(
                          _navIcons[i],
                          size: 20,
                          color: selected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
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

const _navIcons = [
  Icons.home,
  Icons.person,
  Icons.code,
  Icons.work,
  Icons.school,
  Icons.mail,
];
