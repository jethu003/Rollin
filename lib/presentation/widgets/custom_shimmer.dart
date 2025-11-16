import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  const CustomShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.baseColor = const Color(0xFFE0E0E0), // dark grey shimmer base
    this.highlightColor = const Color(0xFFF5F5F5), // light shimmer glow
  });

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> {
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    // 🕒 Disable shimmer animation after the duration
    Timer(widget.duration, () {
      if (mounted) {
        setState(() => _enabled = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If shimmer has stopped, just show child normally
    if (!_enabled) return widget.child;

    // Otherwise show shimmer effect
    return Shimmer.fromColors(
      baseColor: widget.baseColor,
      highlightColor: widget.highlightColor,
      enabled: _enabled,
      child: widget.child,
    );
  }
}
