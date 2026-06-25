import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shtiwy/core/resources/app_images.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';

/// A premium, always-on animated logo widget.
///
/// On first appearance it pops in with an elastic bounce + shimmer sweep.
/// After that it floats continuously (vertical sine wave) while a soft
/// primary-colour glow ring pulses underneath — both run forever.
///
/// Drop this anywhere in place of a plain [Image.asset] logo.
class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    // Gentle float: 6 px up → 6 px down, 2.4 s per cycle, repeats forever
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, _floatAnimation.value), child: child),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _GlowRing(),
          _LogoImage(),
        ],
      ),
    )
        // ── Entrance: elastic pop-in ──────────────────────────────────────
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.6, 0.6),
          end: const Offset(1.0, 1.0),
          duration: 700.ms,
          curve: Curves.elasticOut,
        )
        // ── After entrance: shimmer sweep ────────────────────────────────
        .then(delay: 200.ms)
        .shimmer(
          duration: 1200.ms,
          color: Colors.white.withValues(alpha: 0.35),
          angle: 0.4,
        );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pulsing glow ring
// ─────────────────────────────────────────────────────────────────────────────

class _GlowRing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final glowColor = Theme.of(context).colorScheme.primary;
    final size = AppSizes.logo120 + 28;

    return SizedBox(width: size, height: size)
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .custom(
          duration: 2000.ms,
          curve: Curves.easeInOut,
          builder: (context, value, _) {
            final alpha = 0.10 + value * 0.20;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: alpha),
                    blurRadius: 32 + value * 16,
                    spreadRadius: 4 + value * 6,
                  ),
                  BoxShadow(
                    color: glowColor.withValues(alpha: alpha * 0.5),
                    blurRadius: 60 + value * 20,
                    spreadRadius: 10,
                  ),
                ],
              ),
            );
          },
        );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo image
// ─────────────────────────────────────────────────────────────────────────────

class _LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.rL16),
      child: Image.asset(
        AppImages.appLogo,
        height: AppSizes.logo120,
        width: AppSizes.logo120,
        fit: BoxFit.contain,
      ),
    );
  }
}
