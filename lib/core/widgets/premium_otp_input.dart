import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shtiwy/core/theme/app_colors.dart';

class PremiumOtpInput extends StatefulWidget {
  final int length;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSuccess;
  final bool isError;
  final bool isVerifying;
  final ValueChanged<String>? onCompleted;
  final bool obscureText;
  final String obscuringCharacter;

  const PremiumOtpInput({
    super.key,
    this.length = 6,
    required this.controller,
    required this.focusNode,
    this.isSuccess = false,
    this.isError = false,
    this.isVerifying = false,
    this.onCompleted,
    this.obscureText = false,
    this.obscuringCharacter = '●',
  });

  @override
  State<PremiumOtpInput> createState() => _PremiumOtpInputState();
}

class _PremiumOtpInputState extends State<PremiumOtpInput> with SingleTickerProviderStateMixin {
  late AnimationController _cursorAnimationController;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    
    _cursorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    _cursorAnimationController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _onTextChanged() {
    setState(() {});
    if (widget.controller.text.length == widget.length) {
      widget.onCompleted?.call(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final defaultBgColor = isDark ? AppColors.surfaceDark : AppColors.grey100;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Hidden TextField that handles the real text input
        Opacity(
          opacity: 0.01,
          child: SizedBox(
            height: 56,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.number,
              maxLength: widget.length,
              showCursor: false,
              enableInteractiveSelection: false,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 1, color: Colors.transparent),
            ),
          ),
        ),
        // Custom animated visual OTP boxes
        GestureDetector(
          onTap: () {
            widget.focusNode.requestFocus();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.length, (index) {
              final text = widget.controller.text;
              final isFocused = widget.focusNode.hasFocus;
              final isCurrentBox = index == text.length;
              final hasCharacter = index < text.length;
              
              // Resolve states and colors dynamically
              Color borderColor = Colors.transparent;
              Color boxBgColor = defaultBgColor;
              double borderWidth = 1.0;
              
              if (widget.isError) {
                borderColor = AppColors.error;
                borderWidth = 1.5;
              } else if (widget.isSuccess) {
                borderColor = AppColors.success;
                borderWidth = 1.5;
              } else if (isFocused && isCurrentBox) {
                borderColor = AppColors.primary;
                borderWidth = 2.0;
                boxBgColor = isDark ? AppColors.backgroundDark : Colors.white;
              } else if (hasCharacter) {
                borderColor = isDark ? AppColors.grey700 : AppColors.grey300;
                borderWidth = 1.0;
              }

              // Character to display
              String displayChar = '';
              if (hasCharacter) {
                displayChar = widget.obscureText ? widget.obscuringCharacter : text[index];
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: borderWidth),
                  boxShadow: isFocused && isCurrentBox
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.15),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulsing cursor on the active cell
                    if (isFocused && isCurrentBox && !widget.isVerifying)
                      FadeTransition(
                        opacity: _cursorAnimationController,
                        child: Container(
                          width: 2,
                          height: 24,
                          color: AppColors.primary,
                        ),
                      ),
                    
                    // Show loading indicator in the last box when verifying
                    if (widget.isVerifying && isCurrentBox && index == widget.length - 1)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      )
                    else if (displayChar.isNotEmpty)
                      Text(
                        displayChar,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().scale(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOutBack,
                      ),
                  ],
                ),
              );
            }),
          ),
        ).animate(target: widget.isError ? 1.0 : 0.0).shake(
          duration: const Duration(milliseconds: 400),
          hz: 5,
          offset: const Offset(6, 0),
        ),
      ],
    );
  }
}
