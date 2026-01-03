import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollMarquee extends StatefulWidget {
  final List<String> items;
  final double height;
  final Duration speed;

  const AutoScrollMarquee({
    super.key,
    required this.items,
    this.height = 48,
    this.speed = const Duration(milliseconds: 16),
  });

  @override
  State<AutoScrollMarquee> createState() => _AutoScrollMarqueeState();
}

class _AutoScrollMarqueeState extends State<AutoScrollMarquee> {
  final ScrollController _controller = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(widget.speed, (_) {
      if (!_controller.hasClients) return;

      _controller.jumpTo(_controller.offset + 1);

      if (_controller.offset >= _controller.position.maxScrollExtent) {
        _controller.jumpTo(0);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withOpacity(0.9),
            scheme.secondary.withOpacity(0.9),
          ],
        ),
      ),
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.items.length * 2, // infinite effect
        itemBuilder: (_, i) {
          final text = widget.items[i % widget.items.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
