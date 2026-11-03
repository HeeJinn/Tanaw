import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:material_new_shapes/material_new_shapes.dart';
import 'package:b_risk/core/theme/risk_colors.dart';

/// An icon sitting on an M3 Expressive shape (cookie, burst, clover…).
class ShapeIcon extends StatelessWidget {
  final IconData icon;
  final RoundedPolygon shape;
  final Color color;
  final double size;

  const ShapeIcon({
    super.key,
    required this.icon,
    required this.shape,
    required this.color,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _ShapePainter(shape.normalized().toPath(), color.withValues(alpha: 0.18)),
        child: Icon(
          icon,
          color: RiskColors.readable(color, Theme.of(context).brightness),
          size: size * 0.46,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final Path unitPath; // shape inside a 1x1 box
  final Color color;
  final double rotation;

  const _ShapePainter(this.unitPath, this.color, {this.rotation = 0});

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..rotate(rotation)
      ..translate(-size.width / 2, -size.height / 2)
      ..scale(size.width, size.height)
      ..drawPath(unitPath, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_ShapePainter old) =>
      old.unitPath != unitPath || old.color != color || old.rotation != rotation;
}

/// The M3 Expressive loading indicator: a shape that morphs and spins.
class ExpressiveLoader extends StatefulWidget {
  final double size;

  const ExpressiveLoader({super.key, this.size = 48});

  @override
  State<ExpressiveLoader> createState() => _ExpressiveLoaderState();
}

class _ExpressiveLoaderState extends State<ExpressiveLoader>
    with SingleTickerProviderStateMixin {
  static final _shapes = [
    MaterialShapes.softBurst,
    MaterialShapes.cookie9Sided,
    MaterialShapes.pentagon,
    MaterialShapes.pill,
    MaterialShapes.sunny,
    MaterialShapes.cookie4Sided,
    MaterialShapes.oval,
  ].map((s) => s.normalized()).toList();

  static final _morphs = [
    for (var i = 0; i < _shapes.length; i++)
      Morph(_shapes[i], _shapes[(i + 1) % _shapes.length]),
  ];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 650 * _morphs.length),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label: 'Loading',
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = reduceMotion ? 0.0 : _controller.value * _morphs.length;
            final step = t.floor() % _morphs.length;
            final progress = Curves.easeInOutCubic.transform(t - t.floor());
            return CustomPaint(
              painter: _ShapePainter(
                _morphs[step].toPath(progress: progress),
                color,
                rotation: t / _morphs.length * 2 * math.pi,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Corner radii for M3 Expressive grouped lists: round outside, tight inside.
BorderRadius groupedRadius(int index, int count) {
  const outer = Radius.circular(24);
  const inner = Radius.circular(6);
  return BorderRadius.vertical(
    top: index == 0 ? outer : inner,
    bottom: index == count - 1 ? outer : inner,
  );
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: ExpressiveLoader());
}

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShapeIcon(
              icon: Icons.cloud_off_rounded,
              shape: MaterialShapes.cookie12Sided,
              color: theme.colorScheme.error,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
