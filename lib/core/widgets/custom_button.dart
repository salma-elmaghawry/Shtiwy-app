import 'package:flutter/material.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';

enum ButtonVariant { primary, secondary, tertiary, outlined, text, icon }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? icon;
  final bool isDisabled;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.isDisabled = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSizes.buttonHeightM48,
      child: _buildButton(theme),
    );
  }

  Widget _buildButton(ThemeData theme) {
    final radius = borderRadius ?? AppSizes.rM12;

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: _buildContent(Colors.white),
        );

      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: _buildContent(Colors.white),
        );

      case ButtonVariant.tertiary:
        return ElevatedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: _buildContent(Colors.black),
        );

      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.primary),
            foregroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: _buildContent(theme.colorScheme.primary),
        );

      case ButtonVariant.option:
        return OutlinedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.12)),
            foregroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, style: TextStyle(color: theme.colorScheme.primary)),
              if (icon != null) ...[
                const SizedBox(width: 8),
                IconTheme(
                  data: IconThemeData(color: theme.colorScheme.primary),
                  child: icon!,
                ),
              ],
            ],
          ),
        );

      case ButtonVariant.text:
        return TextButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: _buildContent(theme.colorScheme.primary),
        );
    }
  }

  Widget _buildContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        if (icon != null) ...[icon!, SizedBox(width: AppSizes.s8)],
        Text(text),
      ],
    );
  }
}
