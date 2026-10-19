import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../utils/context_extensions.dart';

/// Placeholder block used while real content loads.
///
/// A slow request should show the shape of the answer that is coming, not a
/// spinner in the middle of an empty page, so lists and result panels use
/// these blocks instead.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.radius = AppConstants.radiusSm,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Shimmer(
    child: _SkeletonShape(width: width, height: height, radius: radius),
  );
}

/// Card-shaped skeleton mirroring the history list rows.
///
/// The whole card animates under one [Shimmer] so its blocks stay in phase.
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonShape(width: 220),
              SizedBox(height: AppConstants.spaceSm),
              _SkeletonShape(width: 140, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// Short list of skeleton rows used while a stored list is read.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.rows = 5, this.padding});

  final int rows;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: AppConstants.spaceSm),
      itemCount: rows,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstants.spaceSm),
      itemBuilder: (context, index) => const SkeletonListTile(),
    );
  }
}

/// Plain grey block; animation is supplied by the enclosing [Shimmer].
class _SkeletonShape extends StatelessWidget {
  const _SkeletonShape({
    this.width,
    this.height = 16,
    this.radius = AppConstants.radiusSm,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Sweeping highlight applied to its subtree.
///
/// One controller drives every descendant, so a screenful of blocks animates
/// in step instead of shimmering out of phase.
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.child});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            colors.surfaceContainerHigh,
            colors.surfaceContainerLowest,
            colors.surfaceContainerHigh,
          ],
          stops: const [0.35, 0.5, 0.65],
          transform: _SlideGradient(-1.5 + 3.0 * _controller.value),
        ).createShader(bounds),
        child: child,
      ),
    );
  }
}

/// Shifts a gradient horizontally by a fraction of the painted width.
class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.fraction);

  final double fraction;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * fraction, 0, 0);
}
